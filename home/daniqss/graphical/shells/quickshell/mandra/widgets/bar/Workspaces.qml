pragma ComponentBehavior: Bound;

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config
import qs.widgets.common

Item {
    id: root
    required property int wsCount
	required property var bar

    signal workspaceAdded(workspace: HyprlandWorkspace)

    RowLayout {
        id: row
		anchors.fill: parent
        spacing: 0

        Repeater {
            model: root.wsCount

            WorkspaceButton {}
        }
    }

    Connections {
        target: Hyprland.workspaces
        function onObjectInsertedPost(workspace) {
            root.workspaceAdded(workspace)
        }
	}

    Component.onCompleted: {
        for (const workspace of Hyprland.workspaces.values) {
            root.workspaceAdded(workspace)
        }
    }
}