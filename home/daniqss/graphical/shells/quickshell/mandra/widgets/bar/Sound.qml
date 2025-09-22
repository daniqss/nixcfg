import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.widgets.common
import qs.data

RowLayout {
  id: sound
  spacing: 1

  property real soundLevel: Math.round(Audio.sinkVolume * 100)

  readonly property string soundIcon: {
    if (Audio.muted)
      return "volume_off";
    else if (soundLevel < 30)
      return "volume_mute";
    else if (soundLevel < 70)
      return "volume_down";
    else
      return "volume_up";
  }

  readonly property string sourceIcon: {
    if (Audio.sourceMuted)
      return "mic_off";

    return "mic";
  }

  Process {
    id: soundProcess
    command: ["pwvucontrol"]
  }

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 20
    font.weight: 600
    icon: sound.soundIcon

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
    icon: sound.sourceIcon

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
