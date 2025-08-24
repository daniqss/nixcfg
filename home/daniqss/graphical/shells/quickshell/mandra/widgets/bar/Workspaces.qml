pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config
import qs.widgets.common

Item {
  id: root

  required property var bar
  required property int wsCount

  signal workspaceAdded(workspace: HyprlandWorkspace)

  Component.onCompleted: {
    for (const workspace of Hyprland.workspaces.values) {
      root.workspaceAdded(workspace);
    }
  }

  RowLayout {
    id: row

    anchors.fill: parent
    spacing: 0

    Repeater {
      model: root.wsCount

      WorkspaceButton {
      }
    }
  }

  Connections {
    function onObjectInsertedPost(workspace) {
      root.workspaceAdded(workspace);
    }

    target: Hyprland.workspaces
  }
}
