import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

import qs.config as Config
import qs.widgets.common 

Item {
    id: wsButton

    required property int index
    property int wsIndex: index + 1
    property bool focused: true
    property HyprlandWorkspace workspace: null
    property bool active: workspace?.active ?? false


    Layout.fillHeight: true
    Layout.leftMargin: active ? 8 : 0
    Layout.rightMargin: active ? 8 : 0
    width: 20

    Rectangle {
        anchors.centerIn: parent

        height: wsButton.active ? (parent.width / 1.3) : 12
        width: wsButton.active ? 26 : 12
        radius: width / 2
        scale: 1 + wsButton.animActive * 0.1


        color: Config.Colors.primary
        opacity: wsButton.active ? 1 : 0.5

        
        Connections {
            target: root
            function onWorkspaceAdded(workspace: HyprlandWorkspace) {
                if (workspace.id === wsButton.wsIndex)
                    wsButton.workspace = workspace
            }
        }

        // accepted inputs in the button
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
            onPressed: event => {
                if (event.button === Qt.RightButton) {
                    defaultAppProcess.running = true;
                }
                else if (event.button === Qt.LeftButton) {
                    workspaceProcess.running = true;
                }
            }
        }
    }

    property real animActive: active ? 1 : 0
    Behavior on animActive { NumberAnimation { duration: 150 } }

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

