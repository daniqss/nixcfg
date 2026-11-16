pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

import qs.config
import qs.data

// cava keeps running for as long as spotify plays, not only while something shows the bars
// TODO: maybe this should be used with libcava, as caelestia does?
// https://github.com/caelestia-dots/shell/discussions/749
Singleton {
  id: root

  readonly property int bands: Sizes.osd.bands
  property list<real> levels: []

  Process {
    running: Player.playing
    command: ["cava", "-p", Quickshell.shellPath("assets/cava.conf")]

    stdout: SplitParser {
      onRead: line => root.levels = line.split(";").filter(v => v !== "").map(v => Number(v) / 100)
    }

    onRunningChanged: {
      if (!running)
        root.levels = [];
    }
  }
}
