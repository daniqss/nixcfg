import QtQuick
import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import Quickshell.Widgets
import qs.config as Config

RowLayout {
  id: taskbar

  property string topLevelClass: ToplevelManager.activeToplevel?.activated && ToplevelManager.activeToplevel?.appId || ""
  property string topLevelTitle: ToplevelManager.activeToplevel?.activated && ToplevelManager.activeToplevel?.title || ""

  spacing: 10

  IconImage {
    id: appicon

    Layout.alignment: Qt.AlignCenter
    Layout.preferredHeight: 22
    Layout.preferredWidth: 22
    source: Quickshell.iconPath(taskbar.topLevelClass)

    // Process {
    //   id: applauncherProcess
    //   // rofi or future quickshell launcher
    //   command: ["applauncher"]
    // }

    MouseArea {
      anchors.fill: parent
      // cursorShape: Qt.PointingHandCursor
      // onClicked: applauncherProcess.running = true;
    }
  }

  Text {
    id: apptitle

    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: taskbar.topLevelTitle
  }
}
