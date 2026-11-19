import QtQuick

import qs.config

// animated shown/hidden state shared by everything that slides out of a screen
// edge. `progress` eases 0 -> 1 when shown and back when hidden, and `active`
// stays true until the hide finishes, so windows bound to it (LazyLoader.active,
// PanelWindow.visible) live long enough to animate out
QtObject {
  id: root

  property bool shown: false
  property int duration: Sizes.reveal.duration

  property real progress: shown ? 1 : 0
  readonly property bool active: shown || progress > 0

  Behavior on progress {
    NumberAnimation {
      duration: root.duration
      // decelerate coming in, accelerate going out
      easing.type: root.shown ? Easing.OutCubic : Easing.InCubic
    }
  }
}
