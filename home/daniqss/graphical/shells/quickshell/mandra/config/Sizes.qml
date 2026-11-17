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

  // each group is an inline component so its members are typed for qmlls
  // mirrors general.gaps_out and decoration.rounding in hyprland's settings.lua
  component WindowSizes: QtObject {
    readonly property int gaps: 3
    readonly property int rounding: 10
  }

  component WorkspaceSizes: QtObject {
    readonly property int appIcon: 24
    // space between the app icons and the tile edges
    readonly property int iconPadding: 2
    // the tile wraps the icons tightly, the bar width follows from it
    readonly property int size: appIcon + 2 * iconPadding
    readonly property int spacing: 6
    readonly property real emptyOpacity: 0.5
    readonly property real hoverOpacity: 0.3
    // how long a drag has to rest on a workspace before switching to it
    readonly property int dragSwitchDelay: 500
  }

  component BarSizes: QtObject {
    // the widest component (a workspace button) plus sidePadding on each side and the border
    readonly property int sidePadding: 6
    required property int width

    readonly property int padding: 12
    readonly property int spacing: 14
    readonly property int groupSpacing: 6
    readonly property int separatorLength: 16
    readonly property int osIcon: 22
    readonly property int trayIcon: 16
    readonly property int traySpacing: 10
  }

  component RevealSizes: QtObject {
    readonly property int duration: 280
    // the fade runs this many times faster than the slide
    readonly property real fadeSpeed: 1.6
  }

  component MorphSizes: QtObject {
    readonly property int duration: 220
    // each layout fades during this fraction of the morph, the rest is the resize
    readonly property real fade: 0.3
  }

  component OsdSizes: QtObject {
    // content width of the full osd shown on hover
    readonly property int fullWidth: 340
    readonly property int fullCover: 88
    // compact osd, the cover plus popup padding on each side
    readonly property int width: 68
    readonly property int slider: 140
    readonly property int cover: 44
    readonly property int bands: 8
  }

  component MenuSizes: QtObject {
    readonly property int width: 720
    readonly property int rowHeight: 56
    readonly property int rowIcon: 38
    readonly property int scrollBar: 6
    // room between a list and its scrollbar
    readonly property int scrollGap: 14
    readonly property int tabBar: 56
    readonly property int panelRounding: 16
    // height of the pages that take all the room, the card adds the tab strip
    readonly property int pageHeight: 504
    readonly property int emojiCell: 44
  }

  component PopupSizes: QtObject {
    readonly property int margin: 20
    readonly property int padding: 12
    readonly property int cardWidth: 320
    readonly property int menuWidth: 220
  }

  readonly property WindowSizes window: WindowSizes {}
  readonly property WorkspaceSizes workspace: WorkspaceSizes {}
  readonly property BarSizes bar: BarSizes {
    width: root.workspace.size + 2 * sidePadding + root.border
  }
  readonly property RevealSizes reveal: RevealSizes {}
  readonly property MorphSizes morph: MorphSizes {}
  readonly property OsdSizes osd: OsdSizes {}
  readonly property MenuSizes menu: MenuSizes {}
  readonly property PopupSizes popup: PopupSizes {}
}
