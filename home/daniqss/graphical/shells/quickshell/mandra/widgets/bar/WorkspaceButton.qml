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

    property int wsIndex: 1 + index
    property HyprlandWorkspace workspace: null
    property bool exists: workspace != null
    property bool active: Hyprland.focusedWorkspace?.id == wsIndex

    Process {
        id: workspaceProcess
        // rofi or future quickshell launcher
        command: ["hyprqtile", "-w", `${wsIndex}`]
    }
    Process {
        id: defaultAppProcess
        command: ["defaultApp"]
    }

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

    Layout.fillHeight: true
    width: 22

    property real animActive: active ? 1 : 0
    Behavior on animActive { NumberAnimation { duration: 150 } }

    Rectangle {
        anchors.centerIn: parent
        height: 22
        width: 22
        radius: width / 2

        color: Colors.primary
        opacity: active ? 1 : 0.5
    }
}

