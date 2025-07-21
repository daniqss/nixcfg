import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.components


Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      color: "transparent"
      implicitWidth: 32
      id: bar

      anchors {
        top: true
        bottom: true
        left: true
      }

      margins {
        left: 6
        right: 0
        top: 5
        bottom: 5
      }

      Rectangle {
        anchors.fill: parent
        radius: 20
        color: "#000000"

        ColumnLayout {
          anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            topMargin: 8
          }

          spacing: 5

          Icon{}
          Workspaces {
            bar: bar
            Layout.fillWidth: true
            wsBaseIndex: 1;
          }
        }

        ColumnLayout {
          anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 15
          }

          Clock {
            Layout.alignment: Qt.AlignHCenter
          }
        }
      }
    }
  }
}