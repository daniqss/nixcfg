pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.config
import qs.widgets.common
import qs.data

PanelWindow {
  id: root

  anchors {
    top: true
    right: true
  }
  exclusiveZone: 0

  implicitWidth: 400
  implicitHeight: Math.max(1, column.implicitHeight + 40)
  color: "transparent"

  // sit above other windows but never steal focus
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  // only the cards should block clicks, the rest of the window is passthrough
  mask: Region {
    item: column
  }

  visible: NotificationService.model.values.length > 0 || (root.showMedia && Player.available)

  // "now playing" popup, rebuilt from spotify's MPRIS metadata
  property bool showMedia: false

  Connections {
    target: Player
    function onTrackChanged() {
      root.showMedia = true;
      mediaTimer.restart();
    }
  }

  Timer {
    id: mediaTimer
    interval: 10000
    running: root.showMedia && !mediaMouse.containsMouse
    onTriggered: root.showMedia = false
  }

  ColumnLayout {
    id: column
    anchors {
      top: parent.top
      right: parent.right
      topMargin: 20
      rightMargin: 20
    }
    spacing: 10

    Rectangle {
      id: mediaCard
      visible: root.showMedia && Player.available

      Layout.preferredWidth: 360
      implicitHeight: mediaLayout.implicitHeight + 16

      radius: 10
      color: Colors.background
      border.width: 1
      border.color: Colors.outline_variant

      MouseArea {
        id: mediaMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showMedia = false
      }

      RowLayout {
        id: mediaLayout
        anchors {
          fill: parent
          margins: 8
        }
        spacing: 14

        Item {
          id: mediaArt
          readonly property string icon: Player.artUrl !== "" ? Player.artUrl : Quickshell.iconPath("spotify", true)

          visible: icon !== ""
          Layout.preferredWidth: 48
          Layout.preferredHeight: 48
          Layout.alignment: Qt.AlignVCenter

          Rectangle {
            id: mediaArtMask
            anchors.fill: parent
            radius: 8
            visible: false
            layer.enabled: true
          }

          Image {
            anchors.fill: parent
            source: parent.icon
            fillMode: Image.PreserveAspectCrop
            layer.enabled: true
            layer.effect: MultiEffect {
              maskEnabled: true
              maskSource: mediaArtMask
            }
          }
        }

        // song info, tight hierarchy: song -> group -> disco
        ColumnLayout {
          Layout.fillWidth: true
          Layout.alignment: Qt.AlignVCenter
          spacing: 0

          Text {
            Layout.fillWidth: true
            text: Player.title
            color: Colors.on_surface
            font.family: "CaskaydiaCove Nerd Font"
            font.pointSize: 12
            font.weight: 700
            elide: Text.ElideRight
          }

          Text {
            Layout.fillWidth: true
            visible: text !== ""
            text: Player.artist
            color: Colors.on_surface_variant
            font.family: "CaskaydiaCove Nerd Font"
            font.pointSize: 11
            font.weight: 600
            textFormat: Text.PlainText
            elide: Text.ElideRight
          }

          Text {
            Layout.fillWidth: true
            visible: text !== ""
            text: Player.album
            color: Colors.outline
            font.family: "CaskaydiaCove Nerd Font"
            font.pointSize: 10
            textFormat: Text.PlainText
            elide: Text.ElideRight
          }
        }
      }
    }

    Repeater {
      model: NotificationService.model

      delegate: Rectangle {
        id: card
        required property var modelData

        Layout.preferredWidth: 320
        implicitHeight: layout.implicitHeight + 24

        radius: 10
        color: Colors.background
        border.width: 1
        border.color: Colors.outline_variant

        // auto dismiss, honouring the notification's own timeout when given.
        // paused while hovered so it can be read
        Timer {
          running: !cardMouse.containsMouse
          interval: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout : 5000
          onTriggered: card.modelData.expire()
        }

        MouseArea {
          id: cardMouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onClicked: card.modelData.dismiss()
        }

        RowLayout {
          id: layout
          anchors {
            fill: parent
            margins: 12
          }
          spacing: 12

          Item {
            readonly property string icon: {
              if (card.modelData.image)
                return card.modelData.image;
              if (card.modelData.appIcon)
                return Quickshell.iconPath(card.modelData.appIcon, true);
              return "";
            }

            visible: icon !== ""
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            Layout.alignment: Qt.AlignTop

            Rectangle {
              id: artMask
              anchors.fill: parent
              radius: 8
              visible: false
              layer.enabled: true
            }

            Image {
              anchors.fill: parent
              source: parent.icon
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
            spacing: 2

            Text {
              Layout.fillWidth: true
              text: card.modelData.summary
              color: Colors.on_surface
              font.family: "CaskaydiaCove Nerd Font"
              font.pointSize: 11
              font.weight: 600
              elide: Text.ElideRight
            }

            Text {
              Layout.fillWidth: true
              visible: text !== ""
              text: card.modelData.body
              color: Colors.on_surface_variant
              font.family: "CaskaydiaCove Nerd Font"
              font.pointSize: 10
              textFormat: Text.PlainText
              wrapMode: Text.WordWrap
            }
          }
        }
      }
    }
  }
}
