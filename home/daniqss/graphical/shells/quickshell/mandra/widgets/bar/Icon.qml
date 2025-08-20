import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config

IconImage {
  id: launcher
  source: Quickshell.iconPath("nix-snowflake")

  Layout.alignment: Qt.AlignCenter

  width: 22
  height: 22

  Process {
    id: applauncherProcess
    // rofi or future quickshell launcher
    command: ["applauncher"]
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: applauncherProcess.running = true;
  }
}
