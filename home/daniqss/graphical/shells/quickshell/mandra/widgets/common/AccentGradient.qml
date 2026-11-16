import QtQuick

import qs.config

// same accents as the hyprland active border
Gradient {
  id: root

  property bool inverted: false

  orientation: Gradient.Horizontal

  GradientStop {
    position: 0
    color: root.inverted ? Colors.tertiary : Colors.primary
  }

  GradientStop {
    position: 0.5
    color: Colors.secondary
  }

  GradientStop {
    position: 1
    color: root.inverted ? Colors.primary : Colors.tertiary
  }
}
