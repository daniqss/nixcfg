pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
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

  function moveToWorkspaceSilent(wsIndex: int) {
    Hyprland.dispatch("workspace " + wsIndex);
  }

  function defaultWorkspaceApp(wsIndex: int) {
    defaultWorkspaceAppProcess.wsIndex = wsIndex;
    defaultWorkspaceAppProcess.running = true;
  }

  Process {
    id: defaultWorkspaceAppProcess
    property int wsIndex

    command: ["defaultApp", wsIndex]
  }
}
