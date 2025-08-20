import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Io

import qs.config
import qs.widgets.common

Item {
    id: wsButton

    required property int wsIndex
    property bool focused: true

    Layout.fillHeight: true
    width: 22

    Rectangle {
        anchors.centerIn: parent
        height: 22
        width: 22
        radius: width / 2

        color: Colors.primary
        opacity: focused ? 1 : 0.5

        Text {
            text: wsIndex
            anchors.centerIn: parent
            color: Colors.on_primary
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onPressed: event => console.log(`${event} in ws ${wsIndex}`)
        }
    }

}

