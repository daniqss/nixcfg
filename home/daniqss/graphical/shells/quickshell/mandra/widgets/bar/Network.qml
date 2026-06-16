import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.data
import qs.widgets.common
import qs.config

RowLayout {
  id: network
  spacing: 0

  visible: Networking.active !== null || Networking.ethernet

  readonly property string networkName: {
    if (Networking.ethernet)
      return "Wired";
    if (Networking.active)
      return Networking.active.ssid;
    return "";
  }

  Process {
    id: networkProcess
    command: ["ghostty", "-e", "nmtui"]
  }

  Item {
    implicitWidth: networkRow.implicitWidth
    implicitHeight: networkRow.implicitHeight
    Layout.fillHeight: true

    RowLayout {
      id: networkRow
      anchors.fill: parent
      spacing: 0

      MaterialSymbol {
        color: Colors.on_background
        font.pixelSize: 20
        icon: {
          if (Networking.ethernet)
            return "lan";
          if (Networking.active)
            return Networking.active.icon;
          return "signal_wifi_statusbar_not_connected";
        }
      }

      Text {
        clip: true
        color: Colors.on_background
        font.family: "CaskaydiaCove Nerd Font"
        font.pointSize: 11
        text: network.networkName

        opacity: networkMouse.containsMouse ? 1 : 0
        Layout.preferredWidth: networkMouse.containsMouse ? implicitWidth : 0

        Behavior on opacity {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
        Behavior on Layout.preferredWidth {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
      }
    }

    MouseArea {
      id: networkMouse
      anchors.fill: parent
      hoverEnabled: true
      onClicked: {
        if (!networkProcess.running)
          networkProcess.running = true;
      }
    }
  }
}
