import QtQuick

import qs.config

// moves its content in from `edge` and fades it in following a Reveal.
// fill the window with it and put the panel inside; the content keeps its
// own geometry, only the holder is translated
Item {
  id: root

  required property Reveal reveal
  property int edge: Qt.RightEdge
  // how far the content travels, the whole panel by default so it fully hides
  property real distance: edge === Qt.LeftEdge || edge === Qt.RightEdge ? width : height

  default property alias content: holder.data
  readonly property alias holder: holder

  readonly property real offset: Math.round((1 - reveal.progress) * distance)

  Item {
    id: holder

    width: root.width
    height: root.height
    x: root.edge === Qt.LeftEdge ? -root.offset : root.edge === Qt.RightEdge ? root.offset : 0
    y: root.edge === Qt.TopEdge ? -root.offset : root.edge === Qt.BottomEdge ? root.offset : 0
    // fades faster than it moves so it reads as appearing, not just sliding
    opacity: Math.min(1, root.reveal.progress * Sizes.reveal.fadeSpeed)
  }
}
