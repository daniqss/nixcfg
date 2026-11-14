pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

import qs.config

// audio visualiser fed by cava. cava only runs while `running` is set, so
// bind it to whether the bars are actually on screen.
//
// the box is fixed and every band lives in its own slot, so one band growing
// never moves its neighbours. bands grow both ways from the centre line,
// across `vertical` stacks, along it otherwise. no Behavior on the size:
// cava already smooths per frame, an animation restarting every sample only
// adds judder. sizes stay fractional so the antialiased edge carries motion
// finer than a pixel instead of stepping
Item {
  id: root

  property bool running: false
  property bool vertical: false
  property color color: Colors.primary
  // thickness of a band and the gap after it
  property int band: 4
  property int gap: 4
  // how far a band can grow
  property real reach: 18

  readonly property int bands: Sizes.osd.bands
  property list<real> levels: []

  implicitWidth: vertical ? reach : bands * (band + gap) - gap
  implicitHeight: vertical ? bands * (band + gap) - gap : reach

  Process {
    running: root.running
    command: ["cava", "-p", Quickshell.shellPath("assets/cava.conf")]

    stdout: SplitParser {
      onRead: line => root.levels = line.split(";").filter(v => v !== "").map(v => Number(v) / 100)
    }

    onRunningChanged: {
      if (!running)
        root.levels = [];
    }
  }

  Repeater {
    model: root.bands

    delegate: Rectangle {
      required property int index
      // at rest each band is a round dot, not a squashed pill
      readonly property real size: Math.max(root.band, root.reach * (root.levels[index] ?? 0))
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
