pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.config
import qs.data

// floating central menu replacing vicinae: launcher, clipboard, sound,
// bluetooth and power pages behind a rail of icons on its left side.
// `qs ipc call menu toggle <page>` opens it from hyprland keybinds
Scope {
  id: root

  readonly property var pages: [
    {
      name: "launcher",
      icon: "apps"
    },
    {
      name: "clipboard",
      icon: "content_paste"
    },
    {
      name: "sound",
      icon: "volume_up"
    },
    {
      name: "bluetooth",
      icon: "bluetooth"
    },
    {
      name: "power",
      icon: "power_settings_new"
    }
  ]

  // 0 hidden, 1 fully shown; kept separate from MenuState.opened so it can fade out
  property real reveal: MenuState.opened ? 1 : 0

  Behavior on reveal {
    NumberAnimation {
      duration: 180
      easing.type: Easing.OutCubic
    }
  }

  IpcHandler {
    target: "menu"

    function toggle(page: string): void {
      MenuState.toggle(page);
    }
    function open(page: string): void {
      MenuState.open(page);
    }
    function close(): void {
      MenuState.close();
    }
  }

  LazyLoader {
    active: root.reveal > 0

    PanelWindow {
      id: window

      // always comes up on the monitor holding the focus
      screen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name) ?? Quickshell.screens[0]

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }
      exclusiveZone: -1
      color: "transparent"

      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.namespace: "quickshell:menu"
      WlrLayershell.keyboardFocus: MenuState.opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

      // dim the desktop, clicking anywhere outside the card closes the menu
      Rectangle {
        anchors.fill: parent
        color: Colors.withAlpha(Colors.scrim, 0.35 * root.reveal)

        MouseArea {
          anchors.fill: parent
          onClicked: MenuState.close()
        }
      }

      FocusScope {
        id: keys
        anchors.fill: parent
        focus: true

        // page switching and closing work from every page
        Keys.onEscapePressed: MenuState.close()
        Keys.onTabPressed: MenuState.cycle(1)
        Keys.onBacktabPressed: MenuState.cycle(-1)
        Keys.onPressed: event => {
          if (event.modifiers & Qt.AltModifier && event.key >= Qt.Key_1 && event.key <= Qt.Key_5) {
            MenuState.open(MenuState.tabs[event.key - Qt.Key_1]);
            event.accepted = true;
          }
        }

        Rectangle {
          id: card

          anchors.centerIn: parent
          width: 780
          height: 520
          scale: 0.94 + 0.06 * root.reveal
          opacity: root.reveal

          radius: Sizes.window.rounding
          color: Colors.background
          border.width: Sizes.border
          border.color: Colors.surface_bright

          // swallow clicks so they don't reach the closing backdrop
          MouseArea {
            anchors.fill: parent
          }

          RowLayout {
            anchors {
              fill: parent
              margins: Sizes.popup.padding
            }
            spacing: Sizes.popup.padding

            // the rail of page icons
            Rectangle {
              Layout.fillHeight: true
              implicitWidth: rail.implicitWidth + 12
              radius: Sizes.radius
              color: Colors.surface_container_low
              border.width: Sizes.border
              border.color: Colors.outline_variant

              ColumnLayout {
                id: rail
                anchors.centerIn: parent
                spacing: 14

                Repeater {
                  model: root.pages

                  delegate: IconButton {
                    required property var modelData
                    size: 40
                    icon: modelData.icon
                    active: MenuState.tab === modelData.name
                    onClicked: MenuState.open(modelData.name)
                  }
                }
              }
            }

            StackLayout {
              id: stack
              Layout.fillWidth: true
              Layout.fillHeight: true
              currentIndex: MenuState.tabs.indexOf(MenuState.tab)

              function activateCurrent(): void {
                const page = stack.children[stack.currentIndex];
                if (page)
                  page.activate();
              }

              onCurrentIndexChanged: activateCurrent()
              Component.onCompleted: activateCurrent()

              LauncherTab {}
              ClipboardTab {}
              SoundTab {}
              BluetoothTab {}
              PowerTab {}
            }
          }
        }
      }

      // reopening while the close animation still runs reuses this window
      Connections {
        target: MenuState
        function onOpenedChanged() {
          if (MenuState.opened)
            stack.activateCurrent();
        }
      }
    }
  }
}
