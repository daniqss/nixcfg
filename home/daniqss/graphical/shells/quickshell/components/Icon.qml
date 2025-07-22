import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets

IconImage {
  id: launcher
  source: Quickshell.iconPath("nix-snowflake")

  Layout.alignment: Qt.AlignCenter

  width: 20
  height: 20

  Process {
    id: launcherProcess
    command: ["qs", "ipc", "call", "launcher", "toggle"]
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: () => console.log("hola caracola")
  }
}