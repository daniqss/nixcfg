import QtQuick
import QtQuick.Layouts

import qs.config
import qs.widgets.common

MouseArea {
  id: root

  required property string icon
  property string label: ""
  property bool showLabel: containsMouse
  property bool verticalLabel: false
  property color color: Colors.on_background
  property int iconWeight: 400

  Layout.alignment: Qt.AlignHCenter
  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight
  acceptedButtons: Qt.LeftButton | Qt.RightButton
  cursorShape: Qt.PointingHandCursor
  hoverEnabled: true

  ColumnLayout {
    id: column

    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 0

    MaterialSymbol {
      Layout.alignment: Qt.AlignHCenter
      color: root.color
      font.pixelSize: Fonts.icon.normal
      font.weight: root.iconWeight
      icon: root.icon
    }

    RevealText {
      text: root.label
      color: root.color
      shown: root.showLabel
      vertical: root.verticalLabel
    }
  }
}
