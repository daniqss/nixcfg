// ClockWidget.qml
import QtQuick
import QtQuick.Layouts
import qs.data


ColumnLayout {
  spacing: -6

  Text {
      id: hours
      font.pointSize: 13
      color: "#ffffff"
      font.family: "CaskaydiaCove Nerd Font"
      Layout.alignment: Qt.AlignHCenter

      text: Time.hours
  }

  Item {
    width: 8
    height: 20
    rotation: 90
    Layout.alignment: Qt.AlignHCenter

    Rectangle {
      width: 3
      height: 3
      radius: 2
      color: Time.seconds % 2 === 0 ? "#ffffff" : "transparent"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: 4
    }

    Rectangle {
      width: 3
      height: 3
      radius: 2
      color: Time.seconds % 2 === 0 ? "#ffffff" : "transparent"
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 4
    }
  }

  Text {
    id: minutes
    font.pointSize: 13
    color: "#ffffff"
    font.family: "CaskaydiaCove Nerd Font"
    Layout.alignment: Qt.AlignHCenter

    text: Time.minutes
  }
}