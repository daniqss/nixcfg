pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Pipewire

import qs.config
import qs.widgets.common
import qs.data

// slim panel sliding out of the right screen edge: output volume on top, mic at
// the bottom and, only while spotify is around, its cover and a visualiser in
// between. volume changes and spotify track changes pop it
Scope {
  id: root
  property bool ready: false
  property bool hovered: false
  // how long the OSD stays up after the last trigger; longer for track changes
  // so there is time to see what started playing
  property int showDuration: 1500

  Reveal {
    id: osdReveal
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
      // only anchored to the right, so it sits vertically centered on that edge
      anchors.right: true
      exclusiveZone: 0

      implicitWidth: Sizes.osd.width
      implicitHeight: content.implicitHeight + 2 * Sizes.popup.padding + 2 * Sizes.window.rounding + 16
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      mask: Region {
        item: slide.holder
      }

      EdgeSlide {
        id: slide
        anchors.fill: parent
        reveal: osdReveal
        edge: Qt.RightEdge

        EdgeTab {
          anchors.fill: parent
          edge: Qt.RightEdge
        }

        // hovering pauses the auto hide so the sliders stay reachable;
        // leaving after a hover dismisses the OSD right away.
        // TODO: grow into the full player (title, artist, album, media controls,
        // horizontal sliders) when hovered before it hides
        MouseArea {
          anchors.fill: parent
          anchors.topMargin: Sizes.window.rounding
          anchors.bottomMargin: Sizes.window.rounding
          hoverEnabled: true
          onEntered: {
            root.hovered = true;
            hideTimer.stop();
          }
          onExited: {
            root.hovered = false;
            osdReveal.shown = false;
          }
        }

        ColumnLayout {
          id: content
          anchors {
            centerIn: parent
            // centered in the body, left of the border pushed off screen
            horizontalCenterOffset: -Sizes.border / 2
          }
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

            Item {
              Layout.alignment: Qt.AlignHCenter
              implicitWidth: Sizes.osd.cover
              implicitHeight: Sizes.osd.cover

              Rectangle {
                id: coverMask
                anchors.fill: parent
                radius: Sizes.radiusTile
                color: Colors.surface_container_high
                layer.enabled: true
              }

              Image {
                anchors.fill: parent
                source: Player.artUrl
                // decoded at the size it is drawn, not the cover's native 600+ px
                sourceSize.width: Sizes.osd.cover * 2
                sourceSize.height: Sizes.osd.cover * 2
                fillMode: Image.PreserveAspectCrop
                visible: status === Image.Ready
                layer.enabled: true
                layer.effect: MultiEffect {
                  maskEnabled: true
                  maskSource: coverMask
                }
              }

              MaterialSymbol {
                anchors.centerIn: parent
                visible: Player.artUrl === ""
                color: Colors.primary
                font.pixelSize: Fonts.icon.normal
                icon: "music_note"
              }

              MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Player.player?.togglePlaying()
              }
            }

            CavaBars {
              Layout.alignment: Qt.AlignHCenter
              vertical: true
              reach: Sizes.osd.cover
              running: osdReveal.shown && Player.playing
            }
          }

          VerticalVolume {
            Layout.alignment: Qt.AlignHCenter
            node: Audio.source
            icon: Audio.sourceIcon
          }
        }
      }
    }
  }
}
