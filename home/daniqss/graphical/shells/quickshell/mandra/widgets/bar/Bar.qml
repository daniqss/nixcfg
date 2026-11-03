pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.widgets.bar
import qs.config

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar

      property var modelData

      color: "transparent"
      implicitWidth: Sizes.bar.width
      screen: modelData

      WlrLayershell.layer: WlrLayer.Bottom

      // flush against the left edge, spanning the whole screen height
      anchors {
        left: true
        top: true
        bottom: true
      }

      Rectangle {
        anchors.fill: parent
        color: Colors.background

        // only the edge facing the windows gets a border
        Rectangle {
          anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
          }
          implicitWidth: Sizes.border
          color: Colors.outline_variant
        }

        ColumnLayout {
          id: content

          anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            topMargin: Sizes.bar.padding
            bottomMargin: Sizes.bar.padding
          }
          spacing: Sizes.bar.spacing

          OsIcon {}
          Workspaces {
            bar: bar
            wsCount: 9
          }

          // pushes the status widgets to the bottom of the bar
          Item {
            Layout.fillHeight: true
          }

          Systray {
            id: systray
          }
          Separator {
            visible: systray.visible
          }
          ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Sizes.bar.groupSpacing

            Sound {}
            Network {}
            Bluetooth {}
            Vpn {}
          }
          Separator {}
          Battery {
            id: battery
          }
          Separator {
            visible: battery.visible
          }
          Clock {}
          Separator {}
          Power {}
        }
      }
    }
  }
}
