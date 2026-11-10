import QtQuick
import QtQuick.Layouts

import qs.config

// text that unfolds below its owner, rotated to read bottom to top when vertical
Item {
  id: root

  property alias text: label.text
  property alias color: label.color
  property alias font: label.font
  property bool shown: false
  property bool vertical: false

  readonly property bool expanded: shown && text !== ""

  Layout.alignment: Qt.AlignHCenter
  Layout.preferredHeight: expanded ? implicitHeight : 0
  implicitWidth: vertical ? label.implicitHeight : label.implicitWidth
  implicitHeight: vertical ? label.implicitWidth : label.implicitHeight
  clip: true
  opacity: expanded ? 1 : 0

  Text {
    id: label

    anchors.centerIn: parent
    rotation: root.vertical ? -90 : 0
    font.family: Fonts.mono
    font.pointSize: root.vertical ? Fonts.size.medium : Fonts.size.small
  }

  Behavior on opacity {
    NumberAnimation {
      duration: Sizes.animDuration
      easing.type: Easing.OutCubic
    }
  }

  Behavior on Layout.preferredHeight {
    NumberAnimation {
      duration: Sizes.animDuration
      easing.type: Easing.OutCubic
    }
  }
}
