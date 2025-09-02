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
    moveToWorkspaceSilentProcess.wsIndex = wsIndex;
    moveToWorkspaceSilentProcess.running = true;
  }

  function defaultWorkspaceApp(wsIndex: int) {
    defaultWorkspaceAppProcess.wsIndex = wsIndex;
    defaultWorkspaceAppProcess.running = true;
  }

  IpcHandler {
    target: "workspaces"

    function moveToWorkspaceSilent(wsIndex: string) {
      workspacesSingleton.moveToWorkspaceSilent(wsIndex);
    }

    function defaultWorkspaceApp(wsIndex: string) {
      workspacesSingleton.defaultWorkspaceApp(wsIndex);
    }
  }

  Process {
    id: moveToWorkspaceSilentProcess
    property int wsIndex

    command: ["hyprqtile", "-w", wsIndex]
    onExited: Hyprland.refreshMonitors()
  }

  Process {
    id: defaultWorkspaceAppProcess
    property int wsIndex

    command: ["defaultApp", wsIndex]
  }
}
