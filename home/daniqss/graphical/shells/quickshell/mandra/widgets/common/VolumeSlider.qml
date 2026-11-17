import QtQuick

import qs.config

// rounded track that can be dragged, clicked or scrolled to pick a value in [0, 1].
// vertical ones fill from the bottom up
Item {
  id: root

  property real value: 0
  property bool muted: false
  property bool vertical: false
  property color fillColor: Colors.primary

  signal moved(real value)

  readonly property real length: vertical ? height : width
  readonly property real thickness: vertical ? width : height

  implicitHeight: vertical ? 0 : 14
  implicitWidth: vertical ? 14 : 0

  function clamp(v: real): real {
    return Math.max(0, Math.min(1, v));
  }

  function valueAt(event: var): real {
    return clamp(vertical ? 1 - event.y / height : event.x / width);
  }

  Rectangle {
    anchors.fill: parent
    radius: root.thickness / 2
    color: Colors.surface_container_high

    Rectangle {
      readonly property real wanted: root.length * root.clamp(root.value)
      // never shorter than the pill is thick so the rounded ends stay round
      property real size: wanted === 0 ? 0 : Math.max(wanted, root.thickness)

      x: 0
      y: root.vertical ? parent.height - size : 0
      width: root.vertical ? parent.width : size
      height: root.vertical ? size : parent.height
      radius: parent.radius
      color: root.muted ? Colors.outline : root.fillColor

      Behavior on size {
        enabled: !mouse.pressed
        NumberAnimation {
          duration: Sizes.animDuration
          easing.type: Easing.OutCubic
        }
      }
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    preventStealing: true

    onPressed: event => root.moved(root.valueAt(event))
    onPositionChanged: event => {
      if (pressed)
        root.moved(root.valueAt(event));
    }
    onWheel: event => root.moved(root.clamp(root.value + (event.angleDelta.y > 0 ? 0.05 : -0.05)))
  }
}
