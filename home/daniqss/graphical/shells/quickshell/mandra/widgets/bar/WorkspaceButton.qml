pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets

import qs.config
import qs.data
import qs.widgets.common

Item {
  id: wsButton

  property HyprlandWorkspace ws: null
  required property int index
  readonly property int wsIndex: index + 1
  readonly property var kanji: ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十"]
  readonly property bool active: WsData.isActive(ws)
  readonly property var toplevels: ws?.toplevels.values ?? []
  readonly property bool hovered: mouseArea.containsMouse || dropArea.containsDrag
  // the gap left around the icons, reused everywhere so nothing adds its own padding
  readonly property int gap: Sizes.workspace.iconPadding

  Layout.alignment: Qt.AlignHCenter
  implicitWidth: Sizes.workspace.size
  implicitHeight: toplevels.length > 0 ? content.implicitHeight + 2 * gap : Sizes.workspace.size

  Connections {
    function onWorkspaceAdded(workspace: HyprlandWorkspace) {
      if (workspace.id === wsButton.wsIndex)
        wsButton.ws = workspace;
    }

    target: root
  }

  Rectangle {
    anchors.fill: parent
    radius: Sizes.radiusTile
    // a faint preview of the active tile on hover, to hint where a click takes you
    opacity: wsButton.active ? 1 : wsButton.hovered ? Sizes.workspace.hoverOpacity : 0
    gradient: AccentGradient {
      inverted: WsData.isSecondMonitor(wsButton.ws)
    }

    Behavior on opacity {
      NumberAnimation {
        duration: Sizes.animDuration
      }
    }
  }

  ColumnLayout {
    id: content

    // full button width so the number is centered the same way with or without app icons
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    spacing: wsButton.gap

    GradientText {
      Layout.fillWidth: true
      text: wsButton.kanji[wsButton.index] ?? wsButton.wsIndex
      font.family: Fonts.cjk
      font.pointSize: Fonts.size.workspace
      font.weight: Font.Black
      color: wsButton.active ? Colors.on_primary : Colors.primary
      opacity: wsButton.active || wsButton.toplevels.length > 0 ? 1 : Sizes.workspace.emptyOpacity
      gradientEnabled: !wsButton.active && wsButton.toplevels.length > 0
    }

    Repeater {
      model: wsButton.toplevels

      Item {
        id: appIcon

        required property HyprlandToplevel modelData
        readonly property string appId: modelData.wayland?.appId ?? modelData.lastIpcObject?.class ?? ""
        readonly property DesktopEntry entry: {
          // entries are scanned asynchronously, depend on them to look up again once loaded
          DesktopEntries.applications.values;
          return DesktopEntries.heuristicLookup(appId);
        }
        // empty when neither the entry nor the theme has an icon, the generic theme fallback looks out of place
        readonly property string iconPath: {
          const icon = entry?.icon ?? appId;
          // absolute paths (like nix store icons) aren't theme icons, so the check would reject them
          return icon.startsWith("/") ? `file://${icon}` : Quickshell.iconPath(icon, true);
        }

        Layout.alignment: Qt.AlignHCenter
        implicitWidth: Sizes.workspace.appIcon
        implicitHeight: Sizes.workspace.appIcon

        IconImage {
          anchors.fill: parent
          visible: appIcon.iconPath !== ""
          source: appIcon.iconPath
        }

        MaterialSymbol {
          anchors.centerIn: parent
          visible: appIcon.iconPath === ""
          icon: "web_asset"
          fill: 1
          font.pixelSize: Sizes.workspace.appIcon
          color: wsButton.active ? Colors.on_primary : Colors.primary
        }
      }
    }
  }

  MouseArea {
    id: mouseArea

    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    cursorShape: Qt.PointingHandCursor

    onPressed: event => {
      if (event.button === Qt.LeftButton)
        WsData.focusWorkspaceOn(wsButton.wsIndex, root.bar.screen);
      else if (event.button === Qt.RightButton)
        WsData.defaultWorkspaceApp(wsButton.wsIndex);
    }
  }

  // resting a drag on the button switches to its workspace, so it can be dropped on a window there
  DropArea {
    id: dropArea

    anchors.fill: parent
  }

  Timer {
    interval: Sizes.workspace.dragSwitchDelay
    running: dropArea.containsDrag && !wsButton.active
    onTriggered: WsData.focusWorkspaceOn(wsButton.wsIndex, root.bar.screen)
  }
}
