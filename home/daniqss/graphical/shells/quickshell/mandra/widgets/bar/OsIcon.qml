import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config

IconImage {
  id: launcher

  Layout.alignment: Qt.AlignHCenter
  height: 23
  width: 23

  Process {
    command: ["sh", "-c", ". /etc/os-release && echo $LOGO"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: () => {
        launcher.source = Quickshell.iconPath(this.text.trim());
      }
    }
  }

  Process {
    id: applauncherProcess

    // rofi or future quickshell launcher
    command: ["applauncher"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: applauncherProcess.running = true
  }
}
