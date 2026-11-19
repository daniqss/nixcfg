import QtQuick
import QtQuick.Layouts

import qs.config
import qs.data
import qs.widgets.common

// search box that also drives the list below it: arrows, alt+hjkl and
// ctrl+j,k move, alt+e/b and alt+digits switch menu pages, enter accepts and
// shift+delete removes the selected entry
Rectangle {
  id: root

  property alias text: input.text
  property string placeholder: "Search"
  property string icon: "search"
  // left / right move through a grid instead of the text cursor
  property bool gridKeys: false

  signal moved(int step)
  signal movedSideways(int step)
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
  // sunk into the page panel
  color: Colors.surface_container_lowest
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
        // alt+hjkl move like the plain keys do on pages without a search box,
        // caught before the input could type the letter
        const vim = event.modifiers === Qt.AltModifier ? {
          [Qt.Key_H]: () => root.movedSideways(-1),
          [Qt.Key_J]: () => root.moved(1),
          [Qt.Key_K]: () => root.moved(-1),
          [Qt.Key_L]: () => root.movedSideways(1)
        }[event.key] : undefined;
        if (vim) {
          vim();
          event.accepted = true;
        } else if (MenuState.handleKey(event)) {
          event.accepted = true;
        } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_J) {
          root.moved(1);
          event.accepted = true;
        } else if (event.modifiers & Qt.ControlModifier && event.key === Qt.Key_K) {
          root.moved(-1);
          event.accepted = true;
        } else if (root.gridKeys && (event.key === Qt.Key_Left || event.key === Qt.Key_Right)) {
          root.movedSideways(event.key === Qt.Key_Left ? -1 : 1);
          event.accepted = true;
        } else if (event.modifiers & Qt.ShiftModifier && event.key === Qt.Key_Delete) {
          root.removeRequested();
          event.accepted = true;
        }
      }
    }
  }
}
