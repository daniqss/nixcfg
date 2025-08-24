import QtQuick
import QtQuick.Layouts
import qs.data
import qs.config

RowLayout {
  spacing: 10

  Text {
    id: hours

    Layout.alignment: Qt.AlignHCenter
    color: Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: Time.time
  }

  Text {
    id: date

    Layout.alignment: Qt.AlignHCenter
    color: Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: Time.date
  }
}
