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
      implicitHeight: 34
      screen: modelData

      WlrLayershell.layer: WlrLayer.Bottom

      anchors {
        bottom: true
        left: true
        right: true
      }

      Rectangle {
        anchors.fill: parent
        color: Config.Colors.background

        RowLayout {
          anchors.bottom: parent.bottom
          anchors.left: parent.left
          anchors.top: parent.top

          anchors.leftMargin: height / 3
          anchors.rightMargin: height / 3
          spacing: height / 3

          OsIcon {}
          Workspaces {
            bar: bar
            wsCount: 9
          }
        }

        RowLayout {
          anchors.bottom: parent.bottom
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top

          anchors.leftMargin: height / 3
          anchors.rightMargin: height / 3
          spacing: height / 3

          Taskbar {}
        }

        RowLayout {
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          anchors.top: parent.top

          anchors.leftMargin: height / 3
          anchors.rightMargin: height / 3
          spacing: height / 3

          Systray {}
          RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 2

            Sound {}
            Network {}
            Battery {}
          }
          Clock {}
        }
      }
    }
  }
}
