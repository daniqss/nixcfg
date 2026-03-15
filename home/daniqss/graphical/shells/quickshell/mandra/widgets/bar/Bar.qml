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
      implicitWidth: 36
      screen: modelData

      WlrLayershell.layer: WlrLayer.Top

      anchors {
        left: true
        top: true
        bottom: true
      }

      Rectangle {
        anchors.fill: parent
        color: Config.Colors.background

        ColumnLayout {
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right

          anchors.topMargin: width / 3
          anchors.bottomMargin: width / 3
          spacing: width / 3

          OsIcon {
            Layout.alignment: Qt.AlignHCenter
          }
          Workspaces {
            bar: bar
            wsCount: 9
            Layout.alignment: Qt.AlignHCenter
          }
        }

        ColumnLayout {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.verticalCenter: parent.verticalCenter

          anchors.topMargin: width / 3
          anchors.bottomMargin: width / 3
          spacing: width / 3

          Clock {
            Layout.alignment: Qt.AlignHCenter
          }
        }

        ColumnLayout {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.right: parent.right

          anchors.topMargin: width / 3
          anchors.bottomMargin: width / 3
          spacing: 15

          Systray {}

          ColumnLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 5

            Sound {}
            Network {}
            Battery {}
          }
        }
      }
    }
  }
}
