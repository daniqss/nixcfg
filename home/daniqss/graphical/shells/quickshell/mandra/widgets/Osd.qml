pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.config
import qs.widgets.common
import qs.data

// slim panel sliding out of the right screen edge: output volume on top, mic at
// the bottom and, only while spotify is around, its cover and a visualiser in
// between. volume changes and spotify track changes pop it, hovering it before
// it hides morphs it into the full player with horizontal sliders
Scope {
  id: root
  property bool ready: false
  property bool hovered: false
  // grown into the full player, set by hovering and reset once the OSD is gone
  property bool expanded: false
  // how long the OSD stays up after the last trigger; longer for track changes
  // so there is time to see what started playing
  property int showDuration: 1500
  // singletons are created on first use; touching Cava here, at startup, keeps
  // cava running and settled before the OSD first shows the bars
  readonly property int cavaBands: Cava.bands

  Reveal {
    id: osdReveal
    onActiveChanged: {
      if (!active)
        root.expanded = false;
    }
  }

  // pops the OSD and (re)arms the auto hide. ignored during startup so the
  // initial settling of the pipewire bindings doesn't flash the panel.
  function show(duration: int) {
    if (!root.ready)
      return;
    root.showDuration = duration;
    osdReveal.shown = true;
    if (!root.hovered)
      hideTimer.restart();
  }

  Timer {
    running: true
    interval: 1000
    onTriggered: root.ready = true
  }

  // use Audio singleton to avoid no signal connections when the sink/source nodes are null at startup
  Connections {
    target: Audio
    function onSinkVolumeChanged() {
      root.show(1500);
    }
    function onSinkMutedChanged() {
      root.show(1500);
    }
    function onSourceVolumeChanged() {
      root.show(1500);
    }
    function onSourceMutedChanged() {
      root.show(1500);
    }
  }

  Connections {
    target: Player
    function onTrackChanged() {
      root.show(4000);
    }
  }

  Timer {
    id: hideTimer
    interval: root.showDuration
    onTriggered: osdReveal.shown = false
  }

  // leaving dismisses the OSD, after a short grace so a stray pointer leave
  // followed by a re-enter doesn't
  Timer {
    id: leaveTimer
    interval: 250
    onTriggered: {
      if (!root.hovered)
        osdReveal.shown = false;
    }
  }

  component VerticalVolume: ColumnLayout {
    id: volume
    required property PwNode node
    required property string icon

    readonly property real value: node?.audio?.volume ?? 0
    readonly property bool muted: node?.audio?.muted ?? false

    spacing: 12

    MaterialSymbol {
      Layout.alignment: Qt.AlignHCenter
      color: volume.muted ? Colors.outline : Colors.on_surface
      font.pixelSize: Fonts.icon.normal
      font.weight: 600
      icon: volume.icon

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Audio.toggleMute(volume.node)
      }
    }

    VolumeSlider {
      Layout.alignment: Qt.AlignHCenter
      Layout.preferredHeight: Sizes.osd.slider
      implicitWidth: 10
      vertical: true
      value: volume.value
      muted: volume.muted
      onMoved: v => {
        if (volume.node?.audio)
          volume.node.audio.volume = v;
      }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter
      text: Math.round(volume.value * 100)
      color: Colors.on_surface_variant
      font.family: Fonts.mono
      font.pointSize: Fonts.size.small
    }
  }

  LazyLoader {
    active: osdReveal.active

    PanelWindow {
      id: osdWindow

      // only anchored to the right, so it sits vertically centered on that edge.
      // sized for the biggest layout, the panel morphs inside it and the mask
      // keeps the empty part click-through
      anchors.right: true
      exclusiveZone: 0

      implicitWidth: Math.max(panel.compactSize.width, panel.fullSize.width)
      implicitHeight: Math.max(panel.compactSize.height, panel.fullSize.height)
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      // while sliding or morphing the whole window takes input: an input region
      // moving every frame makes hyprland send pointer leaves with the cursor
      // still on the panel, which would dismiss the OSD mid animation
      readonly property bool animating: (osdReveal.progress > 0 && osdReveal.progress < 1) || (panel.morph > 0 && panel.morph < 1)

      // explicit geometry: `item:` only follows the panel's own geometry, not
      // the slide moving its parent, so the input region would stay off screen
      mask: Region {
        x: osdWindow.animating ? 0 : slide.holder.x + panel.x
        y: osdWindow.animating ? 0 : slide.holder.y + panel.y
        width: osdWindow.animating ? osdWindow.width : panel.width
        height: osdWindow.animating ? osdWindow.height : panel.height
      }

      EdgeSlide {
        id: slide
        anchors.fill: parent
        reveal: osdReveal
        edge: Qt.RightEdge
        // only as far as the panel is wide, not the whole window
        distance: panel.width

        MorphPanel {
          id: panel

          // where the cursor came in, the full layout grows around it so it stays
          // under the cursor (it is shorter than the compact one, centering it would
          // leave the cursor outside and the exit would dismiss the OSD)
          property real entryY: parent.height / 2
          readonly property real fullCenter: Math.max(fullSize.height / 2, Math.min(parent.height - fullSize.height / 2, entryY))
          readonly property real center: parent.height / 2 + (fullCenter - parent.height / 2) * panel.morph

          anchors.right: parent.right
          y: Math.round(center - height / 2)
          width: implicitWidth
          height: implicitHeight

          expanded: root.expanded
          // the flares above and below the body and the border pushed off screen
          topInset: padding + Sizes.window.rounding + 8
          bottomInset: padding + Sizes.window.rounding + 8
          rightInset: padding + Sizes.border

          EdgeTab {
            anchors.fill: parent
            edge: Qt.RightEdge
          }

          // hovering stops the auto hide and grows the OSD into the full player;
          // leaving dismisses it right away
          MouseArea {
            anchors.fill: parent
            anchors.topMargin: Sizes.window.rounding
            anchors.bottomMargin: Sizes.window.rounding
            hoverEnabled: true
            onEntered: {
              leaveTimer.stop();
              if (!root.expanded)
                panel.entryY = mapToItem(panel.parent, 0, mouseY).y;
              root.hovered = true;
              root.expanded = true;
              hideTimer.stop();
            }
            onExited: {
              root.hovered = false;
              leaveTimer.restart();
            }
          }

          compact: ColumnLayout {
            spacing: 26

            VerticalVolume {
              Layout.alignment: Qt.AlignHCenter
              node: Audio.sink
              icon: Audio.soundIcon
            }

            ColumnLayout {
              Layout.alignment: Qt.AlignHCenter
              visible: Player.available
              spacing: 18

              Cover {
                Layout.alignment: Qt.AlignHCenter
                size: Sizes.osd.cover
              }

              CavaBars {
                Layout.alignment: Qt.AlignHCenter
                vertical: true
                reach: Sizes.osd.cover
              }
            }

            VerticalVolume {
              Layout.alignment: Qt.AlignHCenter
              node: Audio.source
              icon: Audio.sourceIcon
            }
          }

          // a layout recomputes its own implicit size from the content, so the fixed
          // width lives on a plain item and long device names wrap inside it
          full: Item {
            implicitWidth: Sizes.osd.fullWidth
            implicitHeight: fullColumn.implicitHeight

            ColumnLayout {
              id: fullColumn
              anchors.fill: parent
              spacing: 16

              NodeVolume {
                Layout.fillWidth: true
                node: Audio.sink
                icon: Audio.soundIcon
                label: Audio.sinkName
              }

              NodeVolume {
                Layout.fillWidth: true
                node: Audio.source
                icon: Audio.sourceIcon
                label: Audio.sourceName
              }

              PlayerDisplay {
                Layout.fillWidth: true
                Layout.topMargin: 6
                Layout.preferredHeight: Sizes.osd.fullCover
                visible: Player.available
              }
            }
          }
        }
      }
    }
  }
}
