import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.widgets.common

Item {
  id: launcher

  // distros whose themed logo clashes with the bar get a monochrome glyph
  // from assets/ filled with the accent gradient
  readonly property var monoLogos: ({
      "nixos": Qt.resolvedUrl("../../assets/nixos-logo.png"),
      "ubuntu": Qt.resolvedUrl("../../assets/ubuntu-logo.png")
    })
  property string distroId: ""
  readonly property bool tinted: monoLogos[distroId] !== undefined

  Layout.alignment: Qt.AlignHCenter
  implicitHeight: Sizes.bar.osIcon
  implicitWidth: Sizes.bar.osIcon

  IconImage {
    id: icon

    anchors.fill: parent
    visible: !launcher.tinted
    layer.enabled: true
  }

  Rectangle {
    anchors.fill: parent
    visible: launcher.tinted
    gradient: AccentGradient {}
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: icon
      maskThresholdMin: 0.5
      maskSpreadAtMin: 1.0
    }
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
    id: vicinaeProcess

    command: ["vicinae", "vicinae://launch/applications?toggle=true"]
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor

    onClicked: vicinaeProcess.running = true
  }
}
