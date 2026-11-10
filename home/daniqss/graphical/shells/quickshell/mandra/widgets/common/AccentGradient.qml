import QtQuick

import qs.config

// same accents as the hyprland active border
Gradient {
  property bool inverted: false

  orientation: Gradient.Horizontal

  GradientStop {
    position: 0
    color: inverted ? Colors.tertiary : Colors.primary
  }

  GradientStop {
    position: 0.5
    color: Colors.secondary
  }

  GradientStop {
    position: 1
    color: inverted ? Colors.primary : Colors.tertiary
  }
}
