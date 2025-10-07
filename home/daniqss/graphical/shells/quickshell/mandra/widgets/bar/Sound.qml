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

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 20
    font.weight: 600
    icon: Audio.soundIcon

    MouseArea {
      anchors.fill: parent

      onClicked: event => {
        if (event.button === Qt.LeftButton)
          Audio.toggleMute(Audio.sink);
        else if (event.button === Qt.RightButton && !soundProcess.running)
          soundProcess.running = true;
      }
      onWheel: event => Audio.wheelAction(event, Audio.sink)
    }
  }

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 20
    font.weight: 600
    icon: Audio.sourceIcon

    MouseArea {
      anchors.fill: parent

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
