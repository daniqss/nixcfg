import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.config
import qs.widgets.common

ColumnLayout {
  id: root

  required property var bar
  required property int wsCount

  spacing: 0

  signal workspaceAdded(workspace: HyprlandWorkspace)

  Component.onCompleted: {
    for (const workspace of Hyprland.workspaces.values) {
      root.workspaceAdded(workspace);
    }
  }

  Repeater {
    model: root.wsCount

    WorkspaceButton {}
  }

  Connections {
    function onObjectInsertedPost(workspace) {
      root.workspaceAdded(workspace);
    }

    target: Hyprland.workspaces
  }
}
