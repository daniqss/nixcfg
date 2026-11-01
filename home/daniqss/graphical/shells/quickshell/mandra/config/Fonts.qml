pragma Singleton

import QtQuick
import Quickshell

Singleton {
  readonly property string mono: "CaskaydiaCove Nerd Font"
  readonly property string cjk: "Noto Sans CJK JP"
  readonly property string icons: "Material Symbols Rounded"

  // point sizes for text
  readonly property QtObject size: QtObject {
    readonly property real small: 9
    readonly property real workspace: 10
    readonly property real medium: 11
    readonly property real large: 14
  }

  // pixel sizes for material symbols
  readonly property QtObject icon: QtObject {
    readonly property int small: 16
    readonly property int normal: 20
    readonly property int medium: 22
    readonly property int large: 24
    readonly property int huge: 26
  }
}
