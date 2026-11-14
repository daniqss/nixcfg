pragma Singleton

import QtQuick
import Quickshell

// which page of the central menu is shown, and whether it is open at all.
// driven from the bar buttons and from hyprland through `qs ipc call menu ...`
Singleton {
  id: root

  readonly property list<string> tabs: ["launcher", "clipboard", "sound", "bluetooth", "power"]

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
}
