// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import qs.data
import qs.config


RowLayout {
  spacing: 10

  Text {
      id: hours
      font.pointSize: 13
      color: Colors.on_background
      font.family: "CaskaydiaCove Nerd Font"
      Layout.alignment: Qt.AlignHCenter

      text: Time.time
  }

  Text {
      id: date
      font.pointSize: 13
      color: Colors.on_background
      font.family: "CaskaydiaCove Nerd Font"
      Layout.alignment: Qt.AlignHCenter

      text: Time.date
  }
}