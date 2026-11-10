import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import qs.config
import qs.data

Item {
  id: root

  required property var bar
  required property int wsCount

  // a touchpad sends smaller deltas than a wheel notch, so add them up until they make one
  property real wheelAccumulator: 0

  signal workspaceAdded(workspace: HyprlandWorkspace)

  function scrollWorkspaces(delta: real) {
    root.wheelAccumulator += delta;
    const steps = Math.trunc(root.wheelAccumulator / 120);
    if (steps === 0)
      return;
    root.wheelAccumulator -= steps * 120;

    const current = Hyprland.monitorFor(root.bar.screen)?.activeWorkspace?.id ?? 1;
    const target = Math.max(1, Math.min(root.wsCount, current - steps));
    if (target !== current)
      WsData.focusWorkspaceOn(target, root.bar.screen);
  }

  Layout.alignment: Qt.AlignHCenter
  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight

  Component.onCompleted: {
    for (const workspace of Hyprland.workspaces.values) {
      root.workspaceAdded(workspace);
    }
  }

  ColumnLayout {
    id: column

    anchors.fill: parent
    spacing: Sizes.workspace.spacing

    Repeater {
      model: root.wsCount

      WorkspaceButton {}
    }
  }

  WheelHandler {
    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
    onWheel: event => root.scrollWorkspaces(event.angleDelta.y)
  }

  Connections {
    function onObjectInsertedPost(workspace) {
      root.workspaceAdded(workspace);
    }

    target: Hyprland.workspaces
  }
}
