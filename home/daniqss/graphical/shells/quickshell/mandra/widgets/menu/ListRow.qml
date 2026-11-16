import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs.config
import qs.widgets.common

// one selectable entry of a menu list: an app icon or a material symbol,
// a title with an optional subtitle, and room for trailing items
MouseArea {
  id: root

  property bool selected: false
  property string title
  property string subtitle: ""
  // a freedesktop icon path, wins over `symbol` when set
  property string iconSource: ""
  property string symbol: ""
  property color symbolColor: Colors.on_surface
  default property alias trailing: trailingRow.data

  // the leading icon shrinks with rows made shorter than the default
  readonly property int iconSize: Math.min(Sizes.menu.rowIcon, height - 12)

  implicitHeight: Sizes.menu.rowHeight
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor

  Rectangle {
    anchors.fill: parent
    radius: Sizes.radius
    color: root.selected ? Colors.surface_container_highest : root.containsMouse ? Colors.surface_container_high : "transparent"
    border.width: root.selected ? Sizes.border : 0
    border.color: Colors.outline_variant
  }

  RowLayout {
    anchors {
      fill: parent
      leftMargin: 10
      rightMargin: 10
    }
    spacing: 14

    IconImage {
      visible: root.iconSource !== ""
      Layout.preferredWidth: root.iconSize
      Layout.preferredHeight: root.iconSize
      source: root.iconSource
    }

    // symbols sit in a round badge so they weigh the same as app icons
    Rectangle {
      visible: root.iconSource === "" && root.symbol !== ""
      Layout.preferredWidth: root.iconSize
      Layout.preferredHeight: root.iconSize
      radius: width / 2
      color: root.selected ? Colors.surface_bright : Colors.surface_container_high

      MaterialSymbol {
        anchors.centerIn: parent
        color: root.symbolColor
        font.pixelSize: Math.round(root.iconSize * 0.55)
        icon: root.symbol
      }
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: 0

      Text {
        Layout.fillWidth: true
        text: root.title
        color: Colors.on_surface
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
        font.weight: root.selected ? 700 : 400
        textFormat: Text.PlainText
        elide: Text.ElideRight
        maximumLineCount: 1
      }

      Text {
        Layout.fillWidth: true
        visible: text !== ""
        text: root.subtitle
        color: Colors.on_surface_variant
        font.family: Fonts.mono
        font.pointSize: Fonts.size.small
        textFormat: Text.PlainText
        elide: Text.ElideRight
        maximumLineCount: 1
      }
    }

    RowLayout {
      id: trailingRow
      spacing: 8
    }
  }
}
