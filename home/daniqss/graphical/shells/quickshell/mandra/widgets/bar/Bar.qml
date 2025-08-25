pragma ComponentBehavior: Bound
import Quickshell
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

      anchors {
        bottom: true
        left: true
        right: true
      }

      Rectangle {
        anchors.fill: parent
        color: Config.Colors.background

        RowLayout {
          spacing: 20

          anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
          }

          RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 14

            Icon {
            }

            Workspaces {
              bar: bar
              wsCount: 9
            }
          }

          // qs warns this but I didn't get this in center with Layout.alignament
          // anchors.horizontalCenter: parent.horizontalCenter

          // Taskbar {
          // }
          RowLayout {
          }

          RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Systray {
            }

            Clock {
            }
            // Common.MaterialSymbol {
            //   color: Config.Colors.primary
            //   font.pixelSize: 20
            //   icon: "battery_5_bar"
            // }
          }
        }
      }
    }
  }
}
