import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import qs.config
import qs.data

ColumnLayout {
  Layout.alignment: Qt.AlignHCenter
  spacing: Sizes.bar.groupSpacing

  Process {
    id: soundProcess
    command: ["pwvucontrol"]
  }

  BarIndicator {
    icon: Audio.soundIcon
    iconWeight: 600
    label: Audio.soundLevel + "%"

    onClicked: event => {
      if (event.button === Qt.LeftButton)
        Audio.toggleMute(Audio.sink);
      else if (event.button === Qt.RightButton && !soundProcess.running)
        soundProcess.running = true;
    }
    onWheel: event => Audio.wheelAction(event, Audio.sink)
  }

  BarIndicator {
    icon: Audio.sourceIcon
    iconWeight: 600
    label: Math.round((Audio.sourceVolume ?? 0) * 100) + "%"

    onClicked: event => {
      if (event.button === Qt.LeftButton)
        Audio.toggleMute(Audio.source);
      else if (event.button === Qt.RightButton && !soundProcess.running)
        soundProcess.running = true;
    }
    onWheel: event => Audio.wheelAction(event, Audio.source)
  }
}
