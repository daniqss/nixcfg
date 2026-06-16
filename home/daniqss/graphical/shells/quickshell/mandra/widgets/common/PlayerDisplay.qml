pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Mpris

import qs.config
import qs.data

RowLayout {
  id: root
  spacing: 14

  readonly property MprisPlayer player: Player.player

  component Control: MaterialSymbol {
    font.pixelSize: 24
    font.weight: 600
    color: enabled ? Colors.on_surface : Colors.outline_variant

    signal activated

    MouseArea {
      anchors.fill: parent
      cursorShape: Qt.PointingHandCursor
      onClicked: parent.activated()
    }
  }

  Item {
    id: art
    readonly property string icon: Player.artUrl !== "" ? Player.artUrl : Quickshell.iconPath("spotify", true)

    visible: icon !== ""

    Layout.fillHeight: true
    Layout.preferredWidth: height

    Rectangle {
      id: artMask
      anchors.fill: parent
      radius: 8
      visible: false
      layer.enabled: true
    }

    Image {
      anchors.fill: parent
      source: art.icon
      fillMode: Image.PreserveAspectCrop
      layer.enabled: true
      layer.effect: MultiEffect {
        maskEnabled: true
        maskSource: artMask
      }
    }
  }

  ColumnLayout {
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    spacing: 0

    Text {
      Layout.fillWidth: true
      text: Player.title
      color: Colors.on_surface
      font.family: "CaskaydiaCove Nerd Font"
      font.pointSize: 11
      font.weight: 700
      elide: Text.ElideRight
    }

    Text {
      Layout.fillWidth: true
      visible: text !== ""
      text: Player.album
      color: Colors.on_surface_variant
      font.family: "CaskaydiaCove Nerd Font"
      font.pointSize: 10
      font.italic: true
      textFormat: Text.PlainText
      elide: Text.ElideRight
    }

    Text {
      Layout.fillWidth: true
      visible: text !== ""
      text: Player.artist
      color: Colors.outline
      font.family: "CaskaydiaCove Nerd Font"
      font.pointSize: 10
      textFormat: Text.PlainText
      elide: Text.ElideRight
    }

    RowLayout {
      Layout.topMargin: 6
      spacing: 14

      Control {
        icon: "skip_previous"
        enabled: root.player?.canGoPrevious ?? false
        onActivated: root.player?.previous()
      }

      Control {
        icon: root.player?.playbackState === MprisPlaybackState.Playing ? "pause" : "play_arrow"
        enabled: root.player?.canTogglePlaying ?? false
        onActivated: root.player?.togglePlaying()
      }

      Control {
        icon: "skip_next"
        enabled: root.player?.canGoNext ?? false
        onActivated: root.player?.next()
      }
    }
  }
}
