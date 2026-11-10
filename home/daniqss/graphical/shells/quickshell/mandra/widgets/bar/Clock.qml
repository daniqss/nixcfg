import QtQuick
import QtQuick.Layouts

import qs.data
import qs.config
import qs.widgets.common

MouseArea {
  id: root

  Layout.alignment: Qt.AlignHCenter
  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight
  hoverEnabled: true

  component ClockText: Text {
    Layout.alignment: Qt.AlignHCenter
    color: Colors.on_background
    font.family: Fonts.mono
    font.pointSize: Fonts.size.large
  }

  ColumnLayout {
    id: column

    anchors.horizontalCenter: parent.horizontalCenter
    spacing: 0

    ClockText {
      text: Time.hours
    }

    ClockText {
      text: Time.minutes
    }

    RevealText {
      color: Colors.on_background
      shown: root.containsMouse
      vertical: true
      text: Time.dayMonth
    }
  }
}
