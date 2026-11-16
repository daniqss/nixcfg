pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects

import qs.config
import qs.data

// square cover of the current spotify track, click to play / pause
Item {
  id: root

  property int size: Sizes.osd.cover

  implicitWidth: size
  implicitHeight: size

  Rectangle {
    id: coverMask
    anchors.fill: parent
    radius: Sizes.radiusTile
    color: Colors.surface_container_high
    layer.enabled: true
  }

  Image {
    anchors.fill: parent
    source: Player.artUrl
    // decoded at the size it is drawn, not the cover's native 600+ px
    sourceSize.width: root.size * 2
    sourceSize.height: root.size * 2
    fillMode: Image.PreserveAspectCrop
    visible: status === Image.Ready
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: coverMask
    }
  }

  MaterialSymbol {
    anchors.centerIn: parent
    visible: Player.artUrl === ""
    color: Colors.primary
    font.pixelSize: Fonts.icon.normal
    icon: "music_note"
  }

  MouseArea {
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    onClicked: Player.player?.togglePlaying()
  }
}
