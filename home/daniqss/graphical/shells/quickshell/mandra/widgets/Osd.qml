import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.config
import qs.widgets.common
import qs.data

Scope {
  id: root
  property bool isFirstLaunch: true
  property bool shouldShowOsd: false

  Connections {
    target: Audio.sink?.audio

    function onVolumeChanged() {
      if (root.isFirstLaunch) {
        root.isFirstLaunch = false;
        return;
      }

      root.shouldShowOsd = true;
      hideTimer.restart();
    }

    function onMutedChanged() {
      root.shouldShowOsd = true;
      hideTimer.restart();
    }
  }

  Timer {
    id: hideTimer
    interval: 1500
    onTriggered: root.shouldShowOsd = false
  }

  // The OSD window will be created and destroyed based on shouldShowOsd.
  // PanelWindow.visible could be set instead of using a loader, but using
  // a loader will reduce the memory overhead when the window isn't open.
  LazyLoader {
    active: root.shouldShowOsd

    PanelWindow {
      // Since the panel's screen is unset, it will be picked by the compositor
      // when the window is created. Most compositors pick the current active monitor.

      anchors {
        top: true
        left: true
      }
      exclusiveZone: 0

      implicitWidth: 300
      implicitHeight: 50
      color: "transparent"

      // An empty click mask prevents the window from blocking mouse events.
      mask: Region {}

      Rectangle {
        anchors.fill: parent
        radius: 10
        color: Colors.surface_container_high
        anchors {
          leftMargin: 20
          topMargin: 20
        }

        RowLayout {
          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
          }

          MaterialSymbol {
            color: Colors.on_surface
            font.pixelSize: 26
            font.weight: 600
            icon: Audio.soundIcon
          }

          Rectangle {
            // Stretches to fill all left-over space
            Layout.fillWidth: true

            implicitHeight: 16
            radius: 10
            color: Colors.surface_container_high

            Rectangle {
              property real wantedWidth: parent.width * (Audio.volume ?? 0)
              anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
              }

              implicitWidth: {
                if (wantedWidth == 0 || wantedWidth >= 16)
                  return wantedWidth;
                return 16;
              }
              radius: parent.radius
              color: Colors.primary
            }
          }
        }
      }
    }
  }
}
