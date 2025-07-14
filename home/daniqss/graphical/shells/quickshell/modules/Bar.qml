import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../components"


Scope {

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      color: "transparent"
      implicitWidth: 32
      id: bar

      anchors {
        top: true
        bottom: true
        left: true
      }

      margins {
        left: 6
        right: 0
        top: 5
        bottom: 5
      }

      Rectangle {
        anchors.fill: parent
        radius: 20
        color: "#000000"

        ColumnLayout {
          anchors {
            left: parent.left
            top: parent.top
            right: parent.right
            topMargin: 8
          }

          spacing: 20

          // Text {
          //   anchors.centerIn: parent
          //   text: "@"
          //   color: "#ffffff"
          //   font.family: "CaskaydiaCove Nerd Font"
          //   font.pointSize: 13
          // }
          Icon{}
        }

        ColumnLayout {
          anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 15
          }

          Clock {
            anchors.centerIn: parent
          }
        }

        // ColumnLayout {
        //   anchors {
        //     left: parent.left
        //     bottom: parent.bottom
        //     right: parent.right
        //     bottomMargin: 15
        //   }

        //   // spacing: 15

        //   Text {
        //     anchors.centerIn: parent
        //     text: "@"
        //     color: "#ffffff"
        //     font.family: "CaskaydiaCove Nerd Font"
        //     font.pointSize: 13
        //   }
        // }
      }
    }
  }
}