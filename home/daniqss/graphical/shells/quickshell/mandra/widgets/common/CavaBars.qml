pragma ComponentBehavior: Bound
import QtQuick

import qs.config
import qs.data

// audio visualiser drawing the levels of the Cava singleton.
Item {
  id: root

  property bool vertical: false
  property color color: Colors.primary
  // thickness of a band and the gap after it
  property int band: 4
  property int gap: 4
  // how far a band can grow
  property real reach: 18

  readonly property int bands: Cava.bands

  implicitWidth: vertical ? reach : bands * (band + gap) - gap
  implicitHeight: vertical ? bands * (band + gap) - gap : reach

  Repeater {
    model: root.bands

    delegate: Rectangle {
      required property int index
      // at rest each band is a round dot, not a squashed pill
      readonly property real size: Math.max(root.band, root.reach * (Cava.levels[index] ?? 0))
      readonly property real slot: index * (root.band + root.gap)

      antialiasing: true
      radius: root.band / 2
      color: root.color

      x: root.vertical ? (root.reach - size) / 2 : slot
      y: root.vertical ? slot : (root.reach - size) / 2
      width: root.vertical ? size : root.band
      height: root.vertical ? root.band : size
    }
  }
}
