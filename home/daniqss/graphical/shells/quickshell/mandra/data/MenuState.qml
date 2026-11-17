pragma Singleton

import QtQuick
import Quickshell

// which page of the central menu is shown, and whether it is open at all.
Singleton {
  id: root

  readonly property list<string> tabs: ["launcher", "clipboard", "emoji", "sound", "bluetooth", "power"]

  property bool opened: false
  property string tab: "launcher"

  function open(name: string): void {
    if (tabs.includes(name))
      root.tab = name;
    root.opened = true;
  }

  // toggling the page already on screen closes the menu, any other page switches to it
  function toggle(name: string): void {
    if (root.opened && (name === "" || name === root.tab))
      root.opened = false;
    else
      root.open(name);
  }

  function close(): void {
    root.opened = false;
  }

  function cycle(step: int): void {
    const i = tabs.indexOf(root.tab);
    root.tab = tabs[(i + step + tabs.length) % tabs.length];
  }

  // shared key handling for all menus
  function handleKey(event: var): bool {
    if (!(event.modifiers & Qt.AltModifier) || event.modifiers & (Qt.ControlModifier | Qt.ShiftModifier))
      return false;
    if (event.key === Qt.Key_E) {
      cycle(1);
      return true;
    }
    if (event.key === Qt.Key_B) {
      cycle(-1);
      return true;
    }
    // xkb keycodes 10 to 15 are the 1 to 6 keys
    const page = event.nativeScanCode - 10;
    if (page >= 0 && page < tabs.length) {
      root.tab = tabs[page];
      return true;
    }
    return false;
  }
}
