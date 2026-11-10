pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// wg-quick names the wireguard interface after its config file
Singleton {
  id: root

  property list<string> interfaces: []
  readonly property string active: interfaces[0] ?? ""

  Process {
    id: query

    command: ["ip", "-j", "link", "show", "type", "wireguard"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          root.interfaces = JSON.parse(this.text).filter(l => l.ifname).map(l => l.ifname);
        } catch (e) {
          root.interfaces = [];
        }
      }
    }
  }

  Process {
    command: ["ip", "monitor", "link"]
    running: true

    stdout: SplitParser {
      onRead: debounce.restart()
    }
  }

  Timer {
    id: debounce
    interval: 200
    onTriggered: query.running = true
  }
}
