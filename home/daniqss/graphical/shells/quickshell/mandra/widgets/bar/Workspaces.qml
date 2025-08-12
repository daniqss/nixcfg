pragma ComponentBehavior: Bound;

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io
import qs.widgets.common
import qs.widgets.bar
import qs.config

FullwidthMouseArea {
	id: root
	acceptedButtons: Qt.NoButton

	required property var bar
	required property int wsBaseIndex
	property int wsCount: 9
	property bool hideWhenEmpty: false

	implicitHeight: column.implicitHeight
	fillWindowWidth: true

	property int currentIndex: 0
	property int existsCount: 0
	readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen)

	visible: !hideWhenEmpty || existsCount > 0

	signal workspaceAdded(workspace: HyprlandWorkspace)


    // Process {
    //     id: workspaceProcess
    //     command: ["hyprqtile", "-w", `${target}`]
    // }

	onWheel: event => {
		event.accepted = true
		const step = -Math.sign(event.angleDelta.y)
		let target = currentIndex + step

		if (target < wsBaseIndex) target = wsBaseIndex
		if (target >= wsBaseIndex + wsCount) target = wsBaseIndex + wsCount - 1

		if (target !== currentIndex) {
			Hyprland.dispatch(`workspace ${target}`)
    		// onPressed: workspaceProcess.running = true;
		}
	}

	ColumnLayout {
		id: column
		spacing: 0
		anchors.fill: parent
		anchors.margins: 5

		Repeater {
			model: root.wsCount

			WorkspaceButton{}
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
