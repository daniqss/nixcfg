pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.widgets.bar
import qs.widgets.common as Common
import qs.config as Config

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: bar

      property var modelData

      color: "transparent"
      implicitHeight: 30
      screen: modelData

      WlrLayershell.layer: WlrLayer.Bottom

      anchors {
        bottom: true
        left: true
        right: true
      }

      margins {
        bottom: 5
        left: 6
        right: 6
        top: -2
      }

      Rectangle {
        anchors.fill: parent
        color: Config.Colors.background
        radius: bar.implicitHeight / 2

        RowLayout {
          spacing: 20

          anchors {
            fill: parent
            leftMargin: 12
            rightMargin: 12
          }

          RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 14

            OsIcon {}

            Workspaces {
              bar: bar
              wsCount: 9
            }
          }

          // qs warns this but I didn't get this in center with Layout.alignament
          // anchors.horizontalCenter: parent.horizontalCenter

          // Taskbar {
          // }
          RowLayout {}

          RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Systray {}
            Battery {}
            Clock {}
          }
        }
      }
    }
  }
}
