pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell

import qs.config
import qs.data
import qs.widgets.common

// emoji picker in the spirit of whatsapp's: recently used first, then every
// category in unicode order, a bar to jump between categories and a search
// over the names. picking one copies it to the clipboard
FocusScope {
  id: root

  readonly property string query: search.text.trim()
  readonly property int columns: Math.max(1, Math.floor((list.width - Sizes.menu.scrollGap) / Sizes.menu.emojiCell))

  readonly property var categoryIcons: ({
      "Recent": "schedule",
      "Smileys & Emotion": "mood",
      "People & Body": "emoji_people",
      "Animals & Nature": "pets",
      "Food & Drink": "restaurant",
      "Travel & Places": "flight",
      "Activities": "sports_soccer",
      "Objects": "lightbulb",
      "Symbols": "emoji_symbols",
      "Flags": "flag"
    })

  // what is on screen, as sections of emojis
  readonly property var sections: {
    if (query !== "")
      return [
        {
          name: "Results",
          emojis: Emojis.search(query)
        }
      ];
    const recent = Emojis.recent.length > 0 ? [
      {
        name: "Recent",
        emojis: Emojis.recent
      }
    ] : [];
    return recent.concat(Emojis.groups);
  }

  // the sections flattened into list rows (a header, then rows of `columns`
  // emojis) so the list only instantiates what is visible. `start` is the
  // index of the row's first emoji in `flat`, which keyboard selection walks
  readonly property var model: {
    const rows = [];
    let start = 0;
    for (const section of sections) {
      rows.push({
        header: true,
        section: section.name
      });
      for (let i = 0; i < section.emojis.length; i += columns) {
        rows.push({
          header: false,
          section: section.name,
          start: start + i,
          emojis: section.emojis.slice(i, i + columns)
        });
      }
      start += section.emojis.length;
    }
    return rows;
  }
  readonly property var flat: sections.reduce((acc, s) => acc.concat(s.emojis), [])

  property int selected: 0
  readonly property var current: flat[selected] ?? null

  // the section whose rows are at the top of the list, lit up in the category bar
  readonly property string visibleSection: model[Math.max(0, list.indexAt(0, list.contentY + 1))]?.section ?? ""

  function activate(): void {
    search.clear();
    selected = 0;
    list.positionViewAtBeginning();
    search.focusInput();
  }

  function pick(emoji: var): void {
    if (!emoji)
      return;
    Emojis.use(emoji);
    Quickshell.execDetached(["wl-copy", emoji.char]);
    MenuState.close();
  }

  function move(step: int): void {
    selected = Math.max(0, Math.min(flat.length - 1, selected + step));
    const row = model.findIndex(r => !r.header && selected >= r.start && selected < r.start + r.emojis.length);
    if (row >= 0)
      list.positionViewAtIndex(row, ListView.Contain);
  }

  function jumpTo(section: string): void {
    const row = model.findIndex(r => r.header && r.section === section);
    if (row >= 0)
      list.positionViewAtIndex(row, ListView.Beginning);
  }

  onQueryChanged: {
    selected = 0;
    list.positionViewAtBeginning();
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: 10

    SearchField {
      id: search
      placeholder: "Search emojis"
      icon: "mood"
      gridKeys: true
      onMoved: step => root.move(step * root.columns)
      onMovedSideways: step => root.move(step)
      onAccepted: root.pick(root.current)
    }

    // category bar, hidden while searching
    RowLayout {
      Layout.fillWidth: true
      visible: root.query === ""
      spacing: 0

      Repeater {
        model: root.sections

        delegate: Item {
          id: category
          required property var modelData

          Layout.fillWidth: true
          implicitHeight: 34

          IconButton {
            anchors.centerIn: parent
            size: 30
            icon: root.categoryIcons[category.modelData.name] ?? "category"
            color: root.visibleSection === category.modelData.name ? Colors.primary : Colors.on_surface_variant
            onClicked: root.jumpTo(category.modelData.name)
          }

          Rectangle {
            anchors {
              bottom: parent.bottom
              horizontalCenter: parent.horizontalCenter
            }
            width: 18
            height: 2
            radius: 1
            color: Colors.primary
            visible: root.visibleSection === category.modelData.name
          }
        }
      }
    }

    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      model: root.model
      boundsBehavior: Flickable.StopAtBounds
      QQC.ScrollBar.vertical: MenuScrollBar {}
      // keep plenty of rows around so scrolling through a category stays smooth
      cacheBuffer: 600

      delegate: Loader {
        id: row
        required property var modelData

        width: ListView.view.width - Sizes.menu.scrollGap
        sourceComponent: modelData.header ? headerRow : emojiRow

        Component {
          id: headerRow

          SectionHeader {
            topPadding: 8
            bottomPadding: 4
            text: row.modelData.section
          }
        }

        Component {
          id: emojiRow

          Row {
            Repeater {
              model: row.modelData.emojis

              delegate: MouseArea {
                id: cell
                required property var modelData
                required property int index
                readonly property bool selected: row.modelData.start + index === root.selected

                width: Sizes.menu.emojiCell
                height: Sizes.menu.emojiCell
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onEntered: root.selected = row.modelData.start + index
                onClicked: root.pick(modelData)

                Rectangle {
                  anchors.fill: parent
                  anchors.margins: 2
                  radius: Sizes.radiusSmall
                  color: cell.selected ? Colors.surface_container_highest : "transparent"
                }

                Text {
                  anchors.centerIn: parent
                  text: cell.modelData.char
                  font.family: Fonts.emoji
                  font.pixelSize: Fonts.icon.huge
                }
              }
            }
          }
        }
      }

      Text {
        anchors.centerIn: parent
        visible: list.count <= 1 && (root.query !== "" || Emojis.groups.length === 0)
        text: Emojis.groups.length === 0 ? "No emoji data, is QS_EMOJI_DATA set?" : "No emojis match"
        color: Colors.outline
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
      }
    }

    // the selected emoji with its name
    RowLayout {
      Layout.fillWidth: true
      spacing: 10
      visible: root.current !== null

      Text {
        text: root.current?.char ?? ""
        font.family: Fonts.emoji
        font.pixelSize: Fonts.icon.large
      }

      Text {
        Layout.fillWidth: true
        text: root.current?.name ?? ""
        color: Colors.on_surface_variant
        font.family: Fonts.mono
        font.pointSize: Fonts.size.small
        elide: Text.ElideRight
      }
    }
  }
}
