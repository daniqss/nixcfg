import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import qs.config

// icon (click to mute) + draggable slider + percentage for a pipewire node
RowLayout {
  id: root

  required property PwNode node
  property string icon: node?.audio?.muted ? "volume_off" : "volume_up"
  property string label: ""

  readonly property real volume: node?.audio?.volume ?? 0
  readonly property bool muted: node?.audio?.muted ?? false

  spacing: 10

  MaterialSymbol {
    Layout.preferredWidth: Fonts.icon.medium
    color: root.muted ? Colors.outline : Colors.on_surface
    font.pixelSize: Fonts.icon.medium
    font.weight: 600
    icon: root.icon

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: {
        if (root.node?.audio)
          root.node.audio.muted = !root.node.audio.muted;
      }
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: 4

    Text {
      Layout.fillWidth: true
      visible: text !== ""
      text: root.label
      color: Colors.on_surface_variant
      font.family: Fonts.mono
      font.pointSize: Fonts.size.small
      // long device names wrap instead of stretching whatever holds the slider
      wrapMode: Text.Wrap
      maximumLineCount: 2
      elide: Text.ElideRight
    }

    VolumeSlider {
      Layout.fillWidth: true
      value: root.volume
      muted: root.muted
      onMoved: v => {
        if (root.node?.audio)
          root.node.audio.volume = v;
      }
    }
  }

  Text {
    Layout.preferredWidth: 30
    Layout.alignment: Qt.AlignBottom
    horizontalAlignment: Text.AlignRight
    text: Math.round(root.volume * 100)
    color: Colors.on_surface_variant
    font.family: Fonts.mono
    font.pointSize: Fonts.size.medium
  }
}
