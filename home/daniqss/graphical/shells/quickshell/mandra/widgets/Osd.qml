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
        font.pixelSize: 22
        font.weight: 600
        icon: dv.icon
      }

      Text {
        Layout.fillWidth: true
        text: dv.deviceName
        color: Colors.on_surface
        font.family: "CaskaydiaCove Nerd Font"
        font.pointSize: 11
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
        font.family: "CaskaydiaCove Nerd Font"
        font.pointSize: 11
      }

      Rectangle {
        Layout.fillWidth: true
        implicitHeight: 16
        radius: 10
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
      anchors {
        top: true
        left: true
      }
      exclusiveZone: 0

      implicitWidth: 380
      implicitHeight: card.implicitHeight + 20
      color: "transparent"

      mask: Region {
        item: card
      }

      Rectangle {
        id: card
        anchors {
          fill: parent
          leftMargin: 20
          topMargin: 20
        }
        implicitHeight: contentColumn.implicitHeight + 24

        radius: 10
        color: Colors.background
        border.width: 1
        border.color: Colors.outline_variant

        // hovering pauses the auto hide so the controls stay reachable
        MouseArea {
          id: cardMouse
          anchors.fill: parent
          hoverEnabled: true
          onContainsMouseChanged: {
            if (containsMouse)
              hideTimer.stop();
            else
              hideTimer.restart();
          }
        }

        ColumnLayout {
          id: contentColumn
          anchors {
            fill: parent
            margins: 12
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
