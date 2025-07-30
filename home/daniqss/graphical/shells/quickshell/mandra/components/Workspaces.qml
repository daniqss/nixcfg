pragma ComponentBehavior: Bound;

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.components
import qs.config

FullwidthMouseArea {
	id: root
	required property var bar
	required property int wsBaseIndex
	property int wsCount: 9
	property bool hideWhenEmpty: false

	implicitHeight: column.implicitHeight
	fillWindowWidth: true
	acceptedButtons: Qt.NoButton

	property int currentIndex: 0
	property int existsCount: 0
	readonly property HyprlandMonitor monitor: Hyprland.monitorFor(bar.screen)

	visible: !hideWhenEmpty || existsCount > 0

	signal workspaceAdded(workspace: HyprlandWorkspace)

	onWheel: event => {
		event.accepted = true
		const step = -Math.sign(event.angleDelta.y)
		let target = currentIndex + step

		if (target < wsBaseIndex) target = wsBaseIndex
		if (target >= wsBaseIndex + wsCount) target = wsBaseIndex + wsCount - 1

		if (target !== currentIndex) {
			Hyprland.dispatch(`workspace ${target}`)
		}
	}

	ColumnLayout {
		id: column
		spacing: 0
		anchors.fill: parent
		anchors.margins: 5

		Repeater {
			model: root.wsCount

			FullwidthMouseArea {
				id: wsItem
				required property int index

				property int wsIndex: root.wsBaseIndex + index
				property HyprlandWorkspace workspace: null
				property bool exists: workspace != null
				property bool active: workspace?.active ?? false

				onPressed: Hyprland.dispatch(`workspace ${wsIndex}`)

				onActiveChanged: if (active) root.currentIndex = wsIndex
				onExistsChanged: root.existsCount += exists ? 1 : -1

				Layout.fillWidth: true
				implicitHeight: active ? 32 : 22
				fillWindowWidth: true

				Connections {
					target: root
					function onWorkspaceAdded(workspace: HyprlandWorkspace) {
						if (workspace.id === wsItem.wsIndex)
							wsItem.workspace = workspace
					}
				}

				property real animActive: active ? 1 : 0
				property real animExists: exists ? 1 : 0

				Behavior on animActive { NumberAnimation { duration: 150 } }
				Behavior on animExists { NumberAnimation { duration: 100 } }

				Rectangle {
					anchors.centerIn: parent
					width: active ? (parent.width / 1.3) : 16
					height: active ? 28 : 16
					radius: height / 2
					scale: 1 + animActive * 0.1

					color: Global.interpolateColors(
						animExists,
						Global.colors.widget,
						Global.colors.widgetActive
					)
					border.color: Global.colors.widgetOutline
					border.width: 1
				}
			}
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
