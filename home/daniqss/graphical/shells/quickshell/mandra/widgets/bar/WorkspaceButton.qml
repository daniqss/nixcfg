import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.config as Config
import qs.widgets.common
import qs.data

Item {
  id: wsButton

  property HyprlandWorkspace ws: null
  property bool focused: true
  required property int index
  property int wsIndex: index + 1
  property int animActive: WsData.isActive(ws) ? 1 : 0

  Layout.fillWidth: true
  Layout.topMargin: WsData.isActive(ws) ? 3 : 0
  Layout.bottomMargin: WsData.isActive(ws) ? 3 : 0
  height: 20

  Behavior on animActive {
    NumberAnimation {
      duration: 150
    }
  }

  Rectangle {
    anchors.centerIn: parent
    color: {
      if (wsButton.ws) {
        if (WsData.isPrimaryMonitor(ws) && WsData.isActive(ws)) {
          return Config.Colors.primary;
        } else if (WsData.isSecondMonitor(ws) && WsData.isActive(ws)) {
          return Config.Colors.tertiary;
        }
      }

      return Config.Colors.primary;
    }
    height: WsData.isActive(ws) ? (parent.width / 1.6) : (wsButton.ws ? 12 : 10)
    opacity: wsButton.ws ? 1 : 0.5
    radius: 10
    scale: 1 + animActive * 0.1
    width: WsData.isActive(ws) ? 16 : (wsButton.ws ? 11 : 10)

    Connections {
      function onWorkspaceAdded(workspace: HyprlandWorkspace) {
        if (workspace.id === wsButton.wsIndex)
          wsButton.ws = workspace;
      }

      target: root
    }

    MouseArea {
      // accepted inputs in the button
      acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor

      onPressed: event => {
        if (event.button === Qt.LeftButton) {
          WsData.moveToWorkspaceSilent(wsButton.wsIndex);
        } else if (event.button === Qt.RightButton) {
          WsData.defaultWorkspaceApp(wsButton.wsIndex);
        }
      }
    }
  }
}
