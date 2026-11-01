import Quickshell.Io
import QtQuick

import qs.data

BarIndicator {
  visible: Networking.active !== null || Networking.ethernet
  icon: {
    if (Networking.ethernet)
      return "lan";
    if (Networking.active)
      return Networking.active.icon;
    return "signal_wifi_statusbar_not_connected";
  }
  label: {
    if (Networking.ethernet)
      return "Wired";
    return Networking.active?.ssid ?? "";
  }
  verticalLabel: true

  onClicked: {
    if (!networkProcess.running)
      networkProcess.running = true;
  }

  Process {
    id: networkProcess
    command: ["ghostty", "-e", "nmtui"]
  }
}
