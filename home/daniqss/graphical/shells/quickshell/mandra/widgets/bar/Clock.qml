import QtQuick
import QtQuick.Layouts

import qs.data as Data
import qs.config as Config

ColumnLayout {
  spacing: 2

  Text {
    id: hours

    Layout.alignment: Qt.AlignHCenter
    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: Data.Time.hours
  }
  Text {
    id: minutes

    Layout.alignment: Qt.AlignHCenter
    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: Data.Time.minutes
  }

  // Text {
  //   id: date

  //   Layout.alignment: Qt.AlignHCenter
  //   color: Config.Colors.on_background
  //   font.family: "CaskaydiaCove Nerd Font"
  //   font.pointSize: 8
  //   text: Data.Time.date
  // }
}
