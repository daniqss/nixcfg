pragma Singleton

import QtQuick
import Quickshell

Singleton {
  readonly property int radius: 10
  readonly property int radiusTile: 7
  readonly property int radiusSmall: 8
  readonly property int border: 1
  readonly property int animDuration: 150

  readonly property QtObject bar: QtObject {
    readonly property int width: 44
    readonly property int padding: 12
    readonly property int spacing: 14
    readonly property int groupSpacing: 6
    readonly property int separatorLength: 16
    readonly property int osIcon: 22
    readonly property int trayIcon: 16
    readonly property int traySpacing: 10
  }

  readonly property QtObject workspace: QtObject {
    readonly property int size: 30
    readonly property int spacing: 6
    readonly property int appIcon: 24
    readonly property real emptyOpacity: 0.5
    readonly property real hoverOpacity: 0.3
  }

  readonly property QtObject battery: QtObject {
    readonly property int width: 26
    readonly property int height: 13
    readonly property real border: 1.5
    readonly property int inset: 2
    readonly property int tipWidth: 2
    readonly property int tipHeight: 5
  }

  readonly property QtObject popup: QtObject {
    readonly property int margin: 20
    readonly property int padding: 12
    readonly property int cardWidth: 320
    readonly property int menuWidth: 220
  }
}
