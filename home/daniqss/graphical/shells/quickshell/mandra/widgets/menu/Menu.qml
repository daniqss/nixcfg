pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import qs.config
import qs.data
import qs.widgets.common

// floating central menu replacing vicinae: launcher, clipboard, emoji, sound,
// bluetooth and power pages over a strip of page tabs along its bottom.
// hyprland keybinds open it through the `quickshell:menu-toggle-<page>` global
// shortcuts, scripts through `qs ipc call menu runWith toggle <page>`.
// it shows and hides at once, only switching pages is animated (MorphStack).
//
// the windows are never destroyed: a closed menu stays mapped, empty and
// click-through on the background layer, and opening it just raises it to the
// overlay layer and takes the keyboard. mapping a fresh surface took ~200 ms
// before hyprland gave it the keyboard, eating the first typed characters
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
      name: "emoji",
      icon: "mood"
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

  // monitor the menu opened on, the one focused when it was opened
  property string openScreen: ""

  Connections {
    target: MenuState
    function onOpenedChanged() {
      if (MenuState.opened)
        root.openScreen = Hyprland.focusedMonitor?.name ?? Quickshell.screens[0]?.name ?? "";
    }
  }

  CommunicationHandler {
    target: "menu"
    commands: [
      {
        name: "toggle",
        description: "open the page, or close the menu if it is already on it",
        args: MenuState.tabs,
        run: page => MenuState.toggle(page)
      },
      {
        name: "open",
        description: "open the menu on the page",
        args: MenuState.tabs,
        shortcut: false,
        run: page => MenuState.open(page)
      },
      {
        name: "close",
        description: "close the menu",
        shortcut: false,
        run: () => MenuState.close()
      }
    ]
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: window

      required property ShellScreen modelData
      readonly property bool shown: MenuState.opened && root.openScreen === modelData.name

      screen: modelData

      anchors {
        top: true
        bottom: true
        left: true
        right: true
      }
      exclusiveZone: -1
      color: "transparent"

      // closed: below every window, empty and click-through
      WlrLayershell.layer: shown ? WlrLayer.Overlay : WlrLayer.Background
      WlrLayershell.namespace: "quickshell:menu"
      WlrLayershell.keyboardFocus: shown ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
      mask: shown ? null : noInput

      Region {
        id: noInput
      }

      onShownChanged: {
        if (!shown)
          return;
        // whatever page switch happened while closed is not animated
        stack.finish();
        stack.activateCurrent();
      }

      // dim the desktop, clicking anywhere outside the card closes the menu
      Rectangle {
        anchors.fill: parent
        color: Colors.withAlpha(Colors.scrim, 0.35)
        visible: window.shown

        MouseArea {
          anchors.fill: parent
          onClicked: MenuState.close()
        }
      }

      FocusScope {
        anchors.fill: parent
        visible: window.shown
        focus: true

        Keys.onEscapePressed: MenuState.close()
        Keys.onTabPressed: MenuState.cycle(1)
        Keys.onBacktabPressed: MenuState.cycle(-1)
        // page switching from every page: the alt shortcuts (search boxes handle
        // them themselves before typing the letter) and, on pages without a search
        // box, plain e / b too, which only reach here when no text input eats them
        Keys.onPressed: event => {
          if (MenuState.handleKey(event)) {
            event.accepted = true;
          } else if (event.modifiers === Qt.NoModifier && event.key === Qt.Key_E) {
            MenuState.cycle(1);
            event.accepted = true;
          } else if (event.modifiers === Qt.NoModifier && event.key === Qt.Key_B) {
            MenuState.cycle(-1);
            event.accepted = true;
          }
        }

        // a dark base holding the page tabs. the page panel shares the card's
        // border along the top and sides and only curves away from it at the
        // bottom, where it rests on the base
        Rectangle {
          id: card

          anchors.centerIn: parent
          width: Sizes.menu.width
          height: panel.height + Sizes.menu.tabBar

          radius: Sizes.window.rounding
          color: Colors.surface_container_lowest
          border.width: Sizes.border
          border.color: Colors.surface_bright

          // swallow clicks so they don't reach the closing backdrop
          MouseArea {
            anchors.fill: parent
          }

          Rectangle {
            id: panel

            anchors {
              top: parent.top
              left: parent.left
              right: parent.right
            }
            height: stack.implicitHeight

            topLeftRadius: card.radius
            topRightRadius: card.radius
            bottomLeftRadius: Sizes.menu.panelRounding
            bottomRightRadius: Sizes.menu.panelRounding
            color: Colors.surface_container_low
            // same border as the card, drawn over it so both read as one
            border.width: Sizes.border
            border.color: card.border.color

            MorphStack {
              id: stack

              anchors.fill: parent
              padding: Sizes.popup.padding + 4
              defaultPageSize: Qt.size(Sizes.menu.width - 2 * padding, Sizes.menu.pageHeight - 2 * padding)
              currentIndex: MenuState.tabs.indexOf(MenuState.tab)

              function activateCurrent(): void {
                const page = stack.pages[stack.currentIndex];
                if (page)
                  page.activate();
              }

              onCurrentIndexChanged: activateCurrent()
              Component.onCompleted: activateCurrent()

              pages: [
                LauncherTab {},
                ClipboardTab {},
                EmojiTab {},
                SoundTab {},
                BluetoothTab {},
                PowerTab {}
              ]
            }
          }

          // page tabs spread evenly over the base
          RowLayout {
            anchors {
              left: parent.left
              right: parent.right
              bottom: parent.bottom
              leftMargin: Sizes.popup.padding
              rightMargin: Sizes.popup.padding
            }
            height: Sizes.menu.tabBar
            spacing: 0

            Repeater {
              model: root.pages

              delegate: Item {
                id: tab
                required property var modelData

                Layout.fillWidth: true
                Layout.fillHeight: true

                IconButton {
                  anchors.centerIn: parent
                  size: 40
                  icon: tab.modelData.icon
                  color: Colors.on_surface_variant
                  active: MenuState.tab === tab.modelData.name
                  onClicked: MenuState.open(tab.modelData.name)
                }
              }
            }
          }
        }
      }
    }
  }
}
