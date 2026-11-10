pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.config
import qs.widgets.common
import qs.data

Scope {
  id: root
  property bool ready: false
  property bool shouldShowOsd: false
  // how long the OSD stays up after the last trigger; longer for track changes
  // so there is time to read the metadata and reach the playback controls
  property int showDuration: 1500

  // pops the OSD and (re)arms the auto hide. ignored during startup so the
  // initial settling of the pipewire bindings doesn't flash the panel.
  function show(duration: int) {
    if (!root.ready)
      return;
    root.showDuration = duration;
    root.shouldShowOsd = true;
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
    onTriggered: root.shouldShowOsd = false
  }

  component DeviceVolume: ColumnLayout {
    id: dv
    property string icon
    property string deviceName
    property real volume

    spacing: 6

    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      MaterialSymbol {
        color: Colors.on_surface
        font.pixelSize: Fonts.icon.medium
        font.weight: 600
        icon: dv.icon
      }

      Text {
        Layout.fillWidth: true
        text: dv.deviceName
        color: Colors.on_surface
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
        elide: Text.ElideRight
      }
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      Text {
        Layout.preferredWidth: 34
        horizontalAlignment: Text.AlignRight
        text: Math.round(dv.volume * 100)
        color: Colors.on_surface_variant
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
      }

      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 16
        radius: Sizes.radius
        color: Colors.surface_container_high

        Rectangle {
          property real wantedWidth: parent.width * Math.max(0, Math.min(1, dv.volume))
          anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
          }

          implicitWidth: {
            if (wantedWidth === 0 || wantedWidth >= 16)
              return wantedWidth;
            return 16;
          }
          radius: parent.radius
          color: Colors.primary
        }
      }
    }
  }

  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      // bottom right corner of the screen
      anchors {
        bottom: true
        right: true
      }
      exclusiveZone: 0

      implicitWidth: 360
      implicitHeight: card.implicitHeight
      color: "transparent"

      mask: Region {
        item: card
      }

      // comes out of the bottom right corner like the bar does from the left edge,
      // the bottom and right sides are pushed off screen so it stays flush
      Rectangle {
        id: card
        anchors {
          fill: parent
          bottomMargin: -Sizes.border
          rightMargin: -Sizes.border
        }
        implicitHeight: contentColumn.implicitHeight + 24

        topLeftRadius: Sizes.window.rounding
        color: Colors.background
        border.width: Sizes.border
        border.color: Colors.outline_variant

        // hovering pauses the auto hide so the controls stay reachable;
        // leaving after a hover dismisses the OSD right away
        MouseArea {
          id: cardMouse
          anchors.fill: parent
          hoverEnabled: true
          onEntered: hideTimer.stop()
          onExited: root.shouldShowOsd = false
        }

        ColumnLayout {
          id: contentColumn
          anchors {
            fill: parent
            margins: Sizes.popup.padding
          }
          spacing: 14

          PlayerDisplay {
            Layout.fillWidth: true
            visible: Player.available
          }

          DeviceVolume {
            Layout.fillWidth: true
            icon: Audio.soundIcon
            deviceName: Audio.sinkName
            volume: Audio.sinkVolume ?? 0
          }

          DeviceVolume {
            Layout.fillWidth: true
            icon: Audio.sourceIcon
            deviceName: Audio.sourceName
            volume: Audio.sourceVolume ?? 0
          }
        }
      }
    }
  }
}
