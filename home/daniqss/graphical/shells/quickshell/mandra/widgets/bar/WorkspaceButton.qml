import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

import qs.config as Config
import qs.widgets.common

Item {
  id: wsButton

  property bool active: workspace?.active ?? false
  property real animActive: active ? 1 : 0
  property bool focused: true
  required property int index
  property HyprlandWorkspace workspace: null
  property int wsIndex: index + 1

  Layout.fillHeight: true
  Layout.leftMargin: active ? 4 : 0
  Layout.rightMargin: active ? 4 : 0
  width: 20

  Behavior on animActive {
    NumberAnimation {
      duration: 150
    }
  }

  Rectangle {
    anchors.centerIn: parent
    color: {
      // ws.modelData.workspace ?? false ? Colors.monitorColors[ws.modelData.workspace?.monitor?.id] : Colors.bgBlur;
      if (wsButton.workspace) {
        if (wsButton.workspace?.monitor?.id == 0 && wsButton.active) {
          return Config.Colors.primary;
        } else if (wsButton.workspace?.monitor?.id == 1 && wsButton.active) {
          return Config.Colors.tertiary;
        }
      }

      return Config.Colors.primary;
    }
    height: wsButton.active ? (parent.width / 1.3) : (wsButton.workspace ? 12 : 10)
    opacity: wsButton.workspace ? 1 : 0.5
    radius: 10
    scale: 1 + wsButton.animActive * 0.1
    width: wsButton.active ? 22 : (wsButton.workspace ? 12 : 10)

    Connections {
      function onWorkspaceAdded(workspace: HyprlandWorkspace) {
        if (workspace.id === wsButton.wsIndex)
          wsButton.workspace = workspace;
      }

      target: root
    }

    // maybe mouseareas should be bigger using the same styled rectangles
    // Rectangle {
    //   color: Config.Colors.error
    //   height: 5
    //   width: 5
    // }

    // accepted inputs in the button
    MouseArea {
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor

      onPressed: event => {
        if (event.button === Qt.RightButton) {
          defaultAppProcess.running = true;
        } else if (event.button === Qt.LeftButton) {
          workspaceProcess.running = true;
        }
      }
    }
  }

  // processes that will run on left and right click
  Process {
    id: workspaceProcess

    // rofi or future quickshell launcher
    command: ["hyprqtile", "-w", `${wsButton.wsIndex}`]
  }

  Process {
    id: defaultAppProcess

    command: ["defaultApp", `${wsButton.wsIndex}`]
  }
}
