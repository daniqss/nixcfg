import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.widgets.common
import qs.data

RowLayout {
  id: sound
  spacing: 1

  Process {
    id: soundProcess
    command: ["pwvucontrol"]
  }

  Item {
    implicitWidth: sinkRow.implicitWidth
    implicitHeight: sinkRow.implicitHeight
    Layout.fillHeight: true

    RowLayout {
      id: sinkRow
      anchors.fill: parent
      spacing: 1

      MaterialSymbol {
        color: Colors.on_background
        font.pixelSize: 20
        font.weight: 600
        icon: Audio.soundIcon
      }

      Text {
        clip: true
        color: Colors.on_background
        font.family: "CaskaydiaCove Nerd Font"
        font.pointSize: 11
        text: Audio.soundLevel + "%"

        opacity: sinkMouse.containsMouse ? 1 : 0
        Layout.preferredWidth: sinkMouse.containsMouse ? implicitWidth : 0

        Behavior on opacity {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
        Behavior on Layout.preferredWidth {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
      }
    }

    MouseArea {
      id: sinkMouse
      anchors.fill: parent
      hoverEnabled: true

      onClicked: event => {
        if (event.button === Qt.LeftButton)
          Audio.toggleMute(Audio.sink);
        else if (event.button === Qt.RightButton && !soundProcess.running)
          soundProcess.running = true;
      }
      onWheel: event => Audio.wheelAction(event, Audio.sink)
    }
  }

  Item {
    implicitWidth: sourceRow.implicitWidth
    implicitHeight: sourceRow.implicitHeight
    Layout.fillHeight: true

    RowLayout {
      id: sourceRow
      anchors.fill: parent
      spacing: 1

      MaterialSymbol {
        color: Colors.on_background
        font.pixelSize: 20
        font.weight: 600
        icon: Audio.sourceIcon
      }

      Text {
        clip: true
        color: Colors.on_background
        font.family: "CaskaydiaCove Nerd Font"
        font.pointSize: 11
        text: Math.round((Audio.sourceVolume ?? 0) * 100) + "%"

        opacity: sourceMouse.containsMouse ? 1 : 0
        Layout.preferredWidth: sourceMouse.containsMouse ? implicitWidth : 0

        Behavior on opacity {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
        Behavior on Layout.preferredWidth {
          NumberAnimation {
            duration: 150
            easing.type: Easing.OutCubic
          }
        }
      }
    }

    MouseArea {
      id: sourceMouse
      anchors.fill: parent
      hoverEnabled: true

      onClicked: event => {
        if (event.button === Qt.LeftButton)
          Audio.toggleMute(Audio.source);
        else if (event.button === Qt.RightButton && !soundProcess.running)
          soundProcess.running = true;
      }
      onWheel: event => Audio.wheelAction(event, Audio.source)
    }
  }
}
