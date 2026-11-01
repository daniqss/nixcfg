pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
  id: workspacesSingleton

  function isActive(workspace: HyprlandWorkspace): bool {
    return workspace?.active ?? false;
  }
  function isPrimaryMonitor(workspace: HyprlandWorkspace): bool {
    return workspace?.monitor?.id == 0;
  }
  function isSecondMonitor(workspace: HyprlandWorkspace): bool {
    return workspace?.monitor?.id == 1;
  }

  // shows the workspace on the screen of the clicked bar,
  // pulling it over when it is already visible on the other monitor
  function focusWorkspaceOn(wsIndex: int, screen: ShellScreen) {
    const monitor = Hyprland.monitorFor(screen);
    if (monitor && !monitor.focused)
      Hyprland.dispatch(`hl.dsp.focus({monitor = '${monitor.name}'})`);

    Hyprland.dispatch(`hl.dsp.focus({workspace = '${wsIndex}', on_current_monitor = true})`);
  }

  function defaultWorkspaceApp(wsIndex: int) {
    Hyprland.dispatch(`default_app(${wsIndex})`);
  }
}
