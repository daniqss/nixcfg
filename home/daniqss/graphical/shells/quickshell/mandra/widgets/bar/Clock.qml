import QtQuick
import QtQuick.Layouts

import qs.data as Data
import qs.config as Config

RowLayout {
  spacing: 10

  Text {
    id: hours

    Layout.alignment: Qt.AlignHCenter
    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: Data.Time.time
  }

  Text {
    id: date

    Layout.alignment: Qt.AlignHCenter
    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 12
    text: Data.Time.date
  }
}
