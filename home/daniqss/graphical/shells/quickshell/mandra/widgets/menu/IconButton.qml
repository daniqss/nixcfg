import QtQuick

import qs.config
import qs.widgets.common

// round material symbol button, filled with the accent when `active`
MouseArea {
  id: root

  required property string icon
  property bool active: false
  property color color: Colors.on_surface
  property int size: 34

  implicitWidth: size
  implicitHeight: size
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor

  Rectangle {
    anchors.fill: parent
    radius: height / 2
    color: root.active ? Colors.primary : root.containsMouse ? Colors.surface_container_highest : "transparent"
  }

  MaterialSymbol {
    anchors.centerIn: parent
    color: root.active ? Colors.on_primary : root.color
    font.pixelSize: Fonts.icon.normal
    font.weight: 600
    fill: root.active ? 1 : 0
    icon: root.icon
  }
}
