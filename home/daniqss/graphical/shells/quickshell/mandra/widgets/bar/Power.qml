import Quickshell.Io
import QtQuick

import qs.config

BarIndicator {
  icon: "power_settings_new"
  iconWeight: 600
  color: Colors.error

  onClicked: powerProcess.running = true

  Process {
    id: powerProcess
    command: ["vicinae", "vicinae://launch/power"]
  }
}
