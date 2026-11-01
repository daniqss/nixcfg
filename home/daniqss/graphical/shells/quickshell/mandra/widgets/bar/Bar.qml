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
      implicitHeight: Math.min(content.implicitHeight + 2 * Sizes.bar.padding, modelData.height - 2 * Sizes.bar.margin)
      screen: modelData

      WlrLayershell.layer: WlrLayer.Bottom

      // only the left edge, so the compositor centers it vertically and it is as tall as its content
      anchors.left: true
      margins.left: Sizes.bar.margin

      Rectangle {
        anchors.fill: parent
        color: Colors.background
        radius: Sizes.bar.radius
        border.width: Sizes.border
        border.color: Colors.outline_variant

        ColumnLayout {
          id: content

          anchors.top: parent.top
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.topMargin: Sizes.bar.padding
          spacing: Sizes.bar.spacing

          OsIcon {}
          Workspaces {
            bar: bar
            wsCount: 9
          }

          Item {
            implicitHeight: Sizes.bar.sectionGap
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
