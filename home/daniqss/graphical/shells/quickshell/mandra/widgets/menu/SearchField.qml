import QtQuick
import QtQuick.Layouts

import qs.config
import qs.widgets.common

// search box that also drives the list below it: arrows / ctrl+j,k move,
// enter accepts and shift+delete removes the selected entry
Rectangle {
  id: root

  property alias text: input.text
  property string placeholder: "Search"
  property string icon: "search"

  signal moved(int step)
  signal accepted
  signal removeRequested

  function clear(): void {
    input.text = "";
  }

  function focusInput(): void {
    input.forceActiveFocus();
  }

  Layout.fillWidth: true
  implicitHeight: 40
  radius: Sizes.radius
  color: Colors.surface_container
  border.width: Sizes.border
  border.color: input.activeFocus ? Colors.primary : Colors.outline_variant

  RowLayout {
    anchors {
      fill: parent
      leftMargin: 12
      rightMargin: 12
    }
    spacing: 10

    MaterialSymbol {
      color: Colors.on_surface_variant
      font.pixelSize: Fonts.icon.normal
      icon: root.icon
    }

    TextInput {
      id: input
      Layout.fillWidth: true
      color: Colors.on_surface
      selectionColor: Colors.primary
      selectedTextColor: Colors.on_primary
      font.family: Fonts.mono
      font.pointSize: Fonts.size.medium
      clip: true
      focus: true

      Text {
        anchors.verticalCenter: parent.verticalCenter
        visible: input.text === ""
        text: root.placeholder
        color: Colors.outline
        font: input.font
      }

      Keys.onUpPressed: root.moved(-1)
      Keys.onDownPressed: root.moved(1)
      Keys.onReturnPressed: root.accepted()
      Keys.onEnterPressed: root.accepted()
      Keys.onPressed: event => {
        if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_J) {
          root.moved(1);
          event.accepted = true;
        } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_K) {
          root.moved(-1);
          event.accepted = true;
        } else if (event.modifiers & Qt.ShiftModifier && event.key === Qt.Key_Delete) {
          root.removeRequested();
          event.accepted = true;
        }
      }
    }
  }
}
