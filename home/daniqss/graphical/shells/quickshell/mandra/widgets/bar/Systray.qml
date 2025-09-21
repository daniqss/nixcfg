import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

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

      onClicked: event => {
        if (item.hasMenu) {
          menu.open();
        }

        event.accepted = true;
      }

      // TODO: Create a bespoke menu design instead of using QsMenu.
      QsMenuAnchor {
        id: menu

        anchor.edges: Edges.Bottom
        anchor.rect.height: trayItem.height

        // Yes I know, this is a confusing way to get the position for the menu, but that's
        // just how Qt is.
        anchor.rect.x: bar.width - (sysTrayRow.width - trayItem.x)
        anchor.rect.y: bar.height - 10
        anchor.window: bar
        menu: trayItem.item.menu
      }

      IconImage {
        id: trayIcon

        anchors.centerIn: parent
        height: parent.height
        source: trayItem.item.icon
        width: parent.width
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
    }
  }
}
