import QtQuick
import QtQuick.Effects

import qs.config

// thin auto-dismiss countdown track for notification cards: masked to the host
// card's rounded silhouette, sitting behind its content and draining right -> left.
// fill it over the card and drive `remaining` (1 -> 0).
Item {
  id: root

  property real remaining: 1
  property color barColor: Colors.primary
  // match the host card so the track follows its rounded border
  property real radius: 10
  property real inset: 1

  Item {
    anchors.fill: parent
    anchors.margins: root.inset
    // extend to the very bottom so the bar sits a pixel lower, over the border
    anchors.bottomMargin: 0
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: mask
    }

    // opaque backdrop so the bar's antialiased edges blend against the card
    // colour instead of the layer's transparency, avoiding fringe pixels
    Rectangle {
      anchors.fill: parent
      color: Colors.background
    }

    Rectangle {
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      height: 3
      color: root.barColor
      width: Math.round(parent.width * root.remaining)
    }
  }

  Rectangle {
    id: mask
    anchors.fill: parent
    anchors.margins: root.inset
    anchors.bottomMargin: 0
    radius: root.radius - root.inset
    visible: false
    layer.enabled: true
  }
}
