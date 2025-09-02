pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
  id: workspacesSingleton

  function moveToWorkspaceSilent(workspace: int) {
    moveToWorkspaceSilentProcess.workspace = workspace;
    moveToWorkspaceSilentProcess.running = true;
  }

  function defaultWorkspaceApp(workspace: int) {
    defaultWorkspaceAppProcess.workspace = workspace;
    defaultWorkspaceAppProcess.running = true;
  }

  IpcHandler {
    target: "workspaces"

    function moveToWorkspaceSilent(workspace: string) {
      workspacesSingleton.moveToWorkspaceSilent(workspace);
    }

    function defaultWorkspaceApp(workspace: string) {
      workspacesSingleton.defaultWorkspaceApp(workspace);
    }
  }

  Process {
    id: moveToWorkspaceSilentProcess

    property int workspace

    command: ["hyprqtile", "-w", workspace]

    onExited: Hyprland.refreshMonitors()
  }

  Process {
    id: defaultWorkspaceAppProcess

    property int workspace

    command: ["defaultApp", workspace]
  }

  Component.onCompleted: {
    console.log("WorkspacesIpc inicializado en arranque");
  }
}
