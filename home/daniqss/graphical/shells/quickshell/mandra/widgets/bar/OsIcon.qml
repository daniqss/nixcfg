import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config

Item {
  id: launcher

  // distros whose themed logo clashes with the bar get a monochrome glyph
  // from assets/ tinted with the primary color
  readonly property var monoLogos: ({
      "ubuntu": Qt.resolvedUrl("../../assets/ubuntu-logo.png")
    })
  property string distroId: ""
  readonly property bool tinted: monoLogos[distroId] !== undefined

  Layout.alignment: Qt.AlignCenter
  implicitHeight: 20
  implicitWidth: 20

  IconImage {
    id: icon

    anchors.fill: parent
    visible: !launcher.tinted
  }

  MultiEffect {
    anchors.fill: parent
    source: icon
    visible: launcher.tinted
    colorization: 1.0
    colorizationColor: Colors.primary
  }

  Process {
    command: ["sh", "-c", ". /etc/os-release && echo \"$ID\" && echo \"$LOGO\""]
    running: true

    stdout: StdioCollector {
      onStreamFinished: () => {
        const [id, logo] = this.text.trim().split("\n");
        launcher.distroId = id ?? "";
        icon.source = launcher.tinted ? launcher.monoLogos[launcher.distroId] : Quickshell.iconPath(logo ?? "");
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
