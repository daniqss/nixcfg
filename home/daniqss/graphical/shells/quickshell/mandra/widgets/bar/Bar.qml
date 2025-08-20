pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.widgets.bar
import qs.widgets.common
import qs.config

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      color: "transparent"
      implicitHeight: 36
      id: bar

      anchors {
        bottom: true
        right: true
        left: true
      }

      Rectangle {
        anchors.fill: parent
        color: Colors.background

        RowLayout {
          anchors {
            fill: parent
            rightMargin: 10
            leftMargin: 10
          }
          spacing: 20

          RowLayout {
            Layout.alignment: Qt.AlignLeft
            spacing: 10

            Icon {}
            Workspaces {
              bar: bar
              wsCount: 9
            }
          }

          RowLayout {
            Layout.alignment: Qt.AlignCenter
            
            Text {
                id: hours
                font.pointSize: 13
                color: Colors.on_background
                font.family: "CaskaydiaCove Nerd Font"
                // Layout.alignment: Qt.AlignHCenter

                text: "hola"
            }
          }

          RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            Clock {}
            MaterialSymbol {
              color: Colors.primary
              font.pixelSize: 20
              icon: "battery_5_bar"
            }
          }
        }
      }
    }
  }
}
