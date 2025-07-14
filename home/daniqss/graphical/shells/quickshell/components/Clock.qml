// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import "../data"


ColumnLayout {
  Text {
      id: clock
      font.pointSize: 13
      color: "#ffffff"
      font.family: "CaskaydiaCove Nerd Font"

      // color: Settings.colors.foreground
      Layout.alignment: Qt.AlignCenter

      text: Time.time
  }
}