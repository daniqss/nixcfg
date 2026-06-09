import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

import qs.config
import qs.widgets.common

RowLayout {
  id: sysTrayRow
  spacing: 10

  Repeater {
    id: sysTray

    model: SystemTray.items

    MouseArea {
      id: trayItem

      property SystemTrayItem item: modelData

      implicitHeight: 16
      implicitWidth: 16
      visible: !trayItem.item.icon.includes("spotify-linux-32")

      acceptedButtons: Qt.LeftButton | Qt.RightButton

      function toggleMenu() {
        if (!trayItem.item.hasMenu)
          return;
        const p = trayItem.mapToItem(null, trayItem.width / 2, 0);
        menuPopup.anchorX = p.x;
        menuPopup.visible = !menuPopup.visible;
      }

      onClicked: event => {
        if (event.button === Qt.LeftButton) {
          if (trayItem.item.onlyMenu)
            trayItem.toggleMenu();
          else
            trayItem.item.activate();
        } else if (event.button === Qt.RightButton) {
          trayItem.toggleMenu();
        }

        event.accepted = true;
      }

      IconImage {
        id: trayIcon

        anchors.centerIn: parent
        height: parent.height
        width: parent.width
        source: trayItem.item.icon
      }

      Loader {
        anchors.fill: trayIcon

        sourceComponent: MultiEffect {
          blurEnabled: false
          blurMax: 1
          shadowBlur: 0
          shadowColor: "black"
          shadowEnabled: true
          shadowHorizontalOffset: 1
          shadowOpacity: 1
          shadowScale: 1
          shadowVerticalOffset: 1
          source: trayIcon
        }
      }

      HoverHandler {
        id: mouse

        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: Qt.PointingHandCursor
      }

      QsMenuOpener {
        id: menuOpener

        menu: trayItem.item.menu
      }

      PopupWindow {
        id: menuPopup

        property real anchorX: 0
        // becomes true once the pointer has entered the menu, so it does not
        // close instantly when it opens before the cursor reaches it
        property bool armed: false

        anchor.window: trayItem.QsWindow.window
        anchor.rect.x: menuPopup.anchorX
        anchor.rect.y: 0
        anchor.rect.width: 1
        anchor.rect.height: 1
        anchor.edges: Edges.Top
        anchor.gravity: Edges.Top | Edges.Left

        visible: false
        color: "transparent"

        implicitWidth: 220
        implicitHeight: menuColumn.implicitHeight + 12

        onVisibleChanged: {
          menuPopup.armed = false;
          closeTimer.stop();
        }

        Timer {
          id: closeTimer
          interval: 250
          onTriggered: menuPopup.visible = false
        }

        Rectangle {
          anchors.fill: parent
          color: Colors.background
          radius: 10
          border.width: 1
          border.color: Colors.outline_variant

          HoverHandler {
            id: popupHover
            onHoveredChanged: {
              if (hovered) {
                closeTimer.stop();
                menuPopup.armed = true;
              } else if (menuPopup.armed) {
                closeTimer.restart();
              }
            }
          }

          ColumnLayout {
            id: menuColumn

            anchors {
              fill: parent
              margins: 6
            }
            spacing: 2

            Repeater {
              model: menuOpener.children

              delegate: Loader {
                id: entryLoader

                required property var modelData

                Layout.fillWidth: true
                sourceComponent: entryLoader.modelData.isSeparator ? separatorComponent : entryComponent

                Component {
                  id: separatorComponent

                  Item {
                    implicitHeight: 9

                    Rectangle {
                      anchors.centerIn: parent
                      width: parent.width - 12
                      height: 1
                      color: Colors.outline_variant
                    }
                  }
                }

                Component {
                  id: entryComponent

                  Rectangle {
                    id: entryRect

                    implicitHeight: 30
                    radius: 6
                    color: (entryMouse.containsMouse && entryLoader.modelData.enabled) ? Colors.surface_container_highest : "transparent"
                    opacity: entryLoader.modelData.enabled ? 1.0 : 0.4

                    RowLayout {
                      anchors {
                        fill: parent
                        leftMargin: 10
                        rightMargin: 10
                      }
                      spacing: 8

                      // Checkbox / radio indicator
                      Rectangle {
                        visible: entryLoader.modelData.buttonType !== QsMenuButtonType.None
                        Layout.preferredWidth: 15
                        Layout.preferredHeight: 15
                        radius: entryLoader.modelData.buttonType === QsMenuButtonType.RadioButton ? 8 : 3
                        color: "transparent"
                        border.width: 1.5
                        border.color: entryLoader.modelData.checkState !== Qt.Unchecked ? Colors.primary : Colors.outline

                        Rectangle {
                          anchors.centerIn: parent
                          width: 7
                          height: 7
                          radius: entryLoader.modelData.buttonType === QsMenuButtonType.RadioButton ? 4 : 2
                          color: Colors.primary
                          visible: entryLoader.modelData.checkState !== Qt.Unchecked
                        }
                      }

                      // Entry icon
                      Image {
                        visible: entryLoader.modelData.icon !== "" && entryLoader.modelData.buttonType === QsMenuButtonType.None
                        source: entryLoader.modelData.icon
                        Layout.preferredWidth: 16
                        Layout.preferredHeight: 16
                        sourceSize.width: 16
                        sourceSize.height: 16
                        smooth: true
                      }

                      Text {
                        text: entryLoader.modelData.text
                        color: Colors.on_surface
                        font.family: "CaskaydiaCove Nerd Font"
                        font.pixelSize: 13
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                      }

                      MaterialSymbol {
                        visible: entryLoader.modelData.hasChildren
                        icon: "chevron_right"
                        color: Colors.on_surface_variant
                        font.pixelSize: 16
                      }
                    }

                    MouseArea {
                      id: entryMouse
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: entryLoader.modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                      onClicked: {
                        if (!entryLoader.modelData.enabled)
                          return;
                        if (entryLoader.modelData.hasChildren)
                          return; // TODO: nested submenus
                        entryLoader.modelData.triggered();
                        menuPopup.visible = false;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
