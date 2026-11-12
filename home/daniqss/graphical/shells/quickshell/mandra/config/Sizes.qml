pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: root

  readonly property int radius: 10
  readonly property int radiusTile: 4
  readonly property int radiusSmall: 8
  readonly property int border: 1
  readonly property int animDuration: 150

  // mirrors general.gaps_out and decoration.rounding in hyprland's settings.lua
  readonly property QtObject window: QtObject {
    readonly property int gaps: 3
    readonly property int rounding: 10
  }

  readonly property QtObject workspace: QtObject {
    readonly property int appIcon: 24
    // space between the app icons and the tile edges
    readonly property int iconPadding: 2
    // the tile wraps the icons tightly, the bar width follows from it
    readonly property int size: appIcon + 2 * iconPadding
    readonly property int spacing: 6
    readonly property real emptyOpacity: 0.5
    readonly property real hoverOpacity: 0.3
  }

  readonly property QtObject bar: QtObject {
    // the widest component (a workspace button) plus sidePadding on each side and the border
    readonly property int sidePadding: 6
    readonly property int width: root.workspace.size + 2 * sidePadding + root.border

    readonly property int padding: 12
    readonly property int spacing: 14
    readonly property int groupSpacing: 6
    readonly property int separatorLength: 16
    readonly property int osIcon: 22
    readonly property int trayIcon: 16
    readonly property int traySpacing: 10
  }

  readonly property QtObject popup: QtObject {
    readonly property int margin: 20
    readonly property int padding: 12
    readonly property int cardWidth: 320
    readonly property int menuWidth: 220
  }
}
