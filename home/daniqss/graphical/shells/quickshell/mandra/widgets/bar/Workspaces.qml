import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import qs.config
import qs.widgets.common

Item {
    id: root
    required property int wsCount
	required property var bar

    RowLayout {
        id: row
        anchors.fill: parent
        spacing: 6

        Repeater {
            model: wsCount

            WorkspaceButton {
                wsIndex: index + 1
            }
        }
    }
}