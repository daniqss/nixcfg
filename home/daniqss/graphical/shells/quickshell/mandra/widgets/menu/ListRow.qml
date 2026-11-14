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

  implicitHeight: 48
  hoverEnabled: true
  cursorShape: Qt.PointingHandCursor

  Rectangle {
    anchors.fill: parent
    radius: Sizes.radius
    color: root.selected ? Colors.surface_container_high : root.containsMouse ? Colors.surface_container : "transparent"
    border.width: root.selected ? Sizes.border : 0
    border.color: Colors.outline_variant
  }

  RowLayout {
    anchors {
      fill: parent
      leftMargin: 10
      rightMargin: 10
    }
    spacing: 12

    IconImage {
      visible: root.iconSource !== ""
      Layout.preferredWidth: 28
      Layout.preferredHeight: 28
      source: root.iconSource
    }

    MaterialSymbol {
      visible: root.iconSource === "" && root.symbol !== ""
      Layout.preferredWidth: 28
      horizontalAlignment: Text.AlignHCenter
      color: root.symbolColor
      font.pixelSize: Fonts.icon.large
      icon: root.symbol
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
