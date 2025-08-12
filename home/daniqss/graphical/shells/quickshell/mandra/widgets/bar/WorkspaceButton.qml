import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

import qs.config
import qs.widgets.common

FullwidthMouseArea {
    id: wsItem
    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

    required property int index

    property int wsIndex: root.wsBaseIndex + index
    property HyprlandWorkspace workspace: null
    property bool exists: workspace != null
    property bool active: workspace?.active ?? false

    Process {
        id: workspaceProcess
        // rofi or future quickshell launcher
        command: ["hyprqtile", "-w", `${wsIndex}`]
    }
    Process {
        id: defaultAppProcess
        command: ["defaultApp"]
    }
    // onPressed: 
    // onPressed: Hyprland.dispatch(`workspace ${wsIndex}`)
    onPressed: event => {
        if (event.button === Qt.RightButton) {
            defaultAppProcess.running = true;
        }
        else if (event.button === Qt.LeftButton) {
            workspaceProcess.running = true;
        }
    }

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

        color: active ? Colors.primary : Colors.tertiary
        border.width: 1
    }
}

