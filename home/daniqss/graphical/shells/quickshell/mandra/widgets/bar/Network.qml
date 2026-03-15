import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.data
import qs.widgets.common
import qs.config

ColumnLayout {
  id: network
  spacing: 0
  Layout.alignment: Qt.AlignHCenter

  visible: Networking.active !== null

  Process {
    id: networkProcess
    command: ["ghostty", "-e", "nmtui"]
  }

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 22
    icon: Networking.active ? Networking.active.icon : "signal_wifi_statusbar_not_connected"

    MouseArea {
      anchors.fill: parent
      onClicked: event => {
        if (!networkProcess.running)
          networkProcess.running = true;
      }
    }
  }
}
