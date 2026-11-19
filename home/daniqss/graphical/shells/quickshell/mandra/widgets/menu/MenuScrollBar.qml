import QtQuick
import QtQuick.Controls

import qs.config

// slim always-visible scrollbar for the menu lists, attach it with
// `ScrollBar.vertical: MenuScrollBar {}`
ScrollBar {
  id: root

  policy: size < 1 ? ScrollBar.AlwaysOn : ScrollBar.AlwaysOff
  implicitWidth: Sizes.menu.scrollBar
  padding: 0

  contentItem: Rectangle {
    implicitWidth: Sizes.menu.scrollBar
    radius: width / 2
    color: root.pressed ? Colors.primary : root.hovered ? Colors.outline : Colors.outline_variant

    Behavior on color {
      ColorAnimation {
        duration: Sizes.animDuration
      }
    }
  }

  background: Rectangle {
    implicitWidth: Sizes.menu.scrollBar
    radius: width / 2
    color: Colors.surface_container_lowest
  }
}
