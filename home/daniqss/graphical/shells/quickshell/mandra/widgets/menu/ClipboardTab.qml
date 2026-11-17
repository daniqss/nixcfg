pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell.Io

import qs.config
import qs.data
import qs.widgets.common

// cliphist history with a preview of the selected entry; enter copies it back,
// shift+delete removes it
FocusScope {
  id: root

  readonly property string query: search.text.toLowerCase()
  readonly property var results: Clipboard.entries.filter(e => e.text.toLowerCase().includes(query))
  readonly property var current: results[list.currentIndex] ?? null

  function activate(): void {
    Clipboard.refresh();
    search.clear();
    list.currentIndex = 0;
    search.focusInput();
  }

  function copy(entry: var): void {
    if (!entry)
      return;
    Clipboard.copy(entry);
    MenuState.close();
  }

  // decode the selected image to the cache, the preview loads it once written
  property string previewSource: ""
  onCurrentChanged: {
    previewSource = "";
    decode.running = false;
    if (current?.isImage) {
      decode.command = Clipboard.decodeCommand(current);
      decode.running = true;
    }
  }

  Process {
    id: decode
    onExited: {
      if (root.current?.isImage)
        root.previewSource = "file://" + Clipboard.imagePath(root.current);
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: 12

    RowLayout {
      Layout.fillWidth: true
      spacing: 8

      SearchField {
        id: search
        placeholder: "Search clipboard"
        icon: "content_paste_search"
        onTextChanged: list.currentIndex = 0
        onMoved: step => list.currentIndex = Math.max(0, Math.min(list.count - 1, list.currentIndex + step))
        onAccepted: root.copy(root.current)
        onRemoveRequested: {
          if (root.current)
            Clipboard.remove(root.current);
        }
      }

      IconButton {
        icon: "delete_sweep"
        color: Colors.error
        onClicked: Clipboard.wipe()
      }
    }

    RowLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: 12

      ListView {
        id: list
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        clip: true
        spacing: 2
        model: root.results
        boundsBehavior: Flickable.StopAtBounds
        QQC.ScrollBar.vertical: MenuScrollBar {}
        highlightMoveDuration: 0

        delegate: ListRow {
          required property var modelData
          required property int index

          width: ListView.view.width - Sizes.menu.scrollGap
          selected: ListView.isCurrentItem
          title: modelData.isImage ? "Image" : modelData.text
          subtitle: modelData.isImage ? modelData.text.replace(/^\[\[ binary data /, "").replace(/ \]\]$/, "") : ""
          symbol: modelData.isImage ? "image" : "notes"
          symbolColor: Colors.on_surface_variant
          onClicked: list.currentIndex = index
          onDoubleClicked: root.copy(modelData)
        }

        Text {
          anchors.centerIn: parent
          visible: list.count === 0
          text: "Clipboard is empty"
          color: Colors.outline
          font.family: Fonts.mono
          font.pointSize: Fonts.size.medium
        }
      }

      // preview of the selected entry
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredWidth: 1
        radius: Sizes.radius
        color: Colors.surface_container_lowest
        border.width: Sizes.border
        border.color: Colors.outline_variant
        clip: true

        Text {
          anchors {
            fill: parent
            margins: Sizes.popup.padding
          }
          visible: root.current !== null && !root.current.isImage
          text: root.current?.text ?? ""
          color: Colors.on_surface
          font.family: Fonts.mono
          font.pointSize: Fonts.size.small
          textFormat: Text.PlainText
          wrapMode: Text.WrapAnywhere
          elide: Text.ElideRight
        }

        Image {
          anchors {
            fill: parent
            margins: Sizes.popup.padding
          }
          visible: root.current?.isImage ?? false
          source: root.previewSource
          fillMode: Image.PreserveAspectFit
          asynchronous: true
          cache: false
        }

        Row {
          anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 8
          }
          visible: root.current !== null
          spacing: 4

          IconButton {
            icon: "content_copy"
            onClicked: root.copy(root.current)
          }
          IconButton {
            icon: "delete"
            color: Colors.error
            onClicked: Clipboard.remove(root.current)
          }
        }
      }
    }
  }
}
