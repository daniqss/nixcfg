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

  // reload feedback is shown as just another card in this stack
  property bool reloadFailed: false
  property string reloadError: ""
  property bool reloadShown: false

  // only the top edge, so the compositor centers it horizontally
  anchors.top: true
  exclusiveZone: 0

  implicitWidth: Sizes.popup.cardWidth
  implicitHeight: Math.max(1, column.implicitHeight + 40)
  color: "transparent"

  // sit above other windows but never steal focus
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

  // only the cards should block clicks, the rest of the window is passthrough
  mask: Region {
    item: column
  }

  visible: NotificationService.model.values.length > 0 || root.reloadShown

  // turn quickshell's own reload popup into a card in our notification stack
  Connections {
    target: Quickshell

    function onReloadCompleted() {
      Quickshell.inhibitReloadPopup();
      root.reloadFailed = false;
      root.reloadError = "";
      root.reloadShown = true;
      reloadAnim.restart();
    }

    function onReloadFailed(error: string) {
      Quickshell.inhibitReloadPopup();
      root.reloadFailed = true;
      root.reloadError = error;
      root.reloadShown = true;
      reloadAnim.restart();
    }
  }

  ColumnLayout {
    id: column

    anchors {
      top: parent.top
      horizontalCenter: parent.horizontalCenter
      topMargin: Sizes.popup.margin
    }
    spacing: 10

    // reload card, kept on top of the stack
    Rectangle {
      id: reloadCard
      visible: root.reloadShown

      property real remaining: 1

      Layout.preferredWidth: Sizes.popup.cardWidth
      implicitHeight: reloadLayout.implicitHeight + 24

      radius: Sizes.radius
      color: Colors.background
      border.width: Sizes.border
      border.color: root.reloadFailed ? Colors.error : Colors.outline_variant

      CountdownBar {
        anchors.fill: parent
        remaining: reloadCard.remaining
        radius: reloadCard.radius
        inset: reloadCard.border.width
        barColor: root.reloadFailed ? Colors.error : Colors.primary
      }

      MouseArea {
        id: reloadMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.reloadShown = false
      }

      RowLayout {
        id: reloadLayout
        anchors {
          fill: parent
          margins: Sizes.popup.padding
        }
        spacing: 12

        MaterialSymbol {
          Layout.alignment: Qt.AlignVCenter
          color: root.reloadFailed ? Colors.error : Colors.primary
          font.pixelSize: Fonts.icon.huge
          font.weight: 600
          icon: root.reloadFailed ? "error" : "check_circle"
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 2

          Text {
            Layout.fillWidth: true
            text: root.reloadFailed ? "Reload failed" : "Reload completed"
            color: Colors.on_surface
            font.family: Fonts.mono
            font.pointSize: Fonts.size.medium
            font.weight: 600
            elide: Text.ElideRight
          }

          Text {
            Layout.fillWidth: true
            visible: text !== ""
            text: root.reloadError
            color: Colors.on_surface_variant
            font.family: Fonts.mono
            font.pointSize: Fonts.size.small
            textFormat: Text.PlainText
            wrapMode: Text.WordWrap
          }
        }
      }

      // a failed reload lingers longer so the error can be read
      NumberAnimation {
        id: reloadAnim
        target: reloadCard
        property: "remaining"
        from: 1
        to: 0
        duration: root.reloadFailed ? 10000 : 2000
        paused: reloadMouse.containsMouse
        onFinished: root.reloadShown = false
      }
    }

    Repeater {
      model: NotificationService.model

      delegate: Rectangle {
        id: card
        required property var modelData

        property real remaining: 1

        Layout.preferredWidth: Sizes.popup.cardWidth
        implicitHeight: layout.implicitHeight + 24

        radius: Sizes.radius
        color: Colors.background
        border.width: Sizes.border
        border.color: Colors.outline_variant

        CountdownBar {
          anchors.fill: parent
          remaining: card.remaining
          radius: card.radius
          inset: card.border.width
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
            margins: Sizes.popup.padding
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
              radius: Sizes.radiusSmall
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
              font.family: Fonts.mono
              font.pointSize: Fonts.size.medium
              font.weight: 600
              elide: Text.ElideRight
            }

            Text {
              Layout.fillWidth: true
              visible: text !== ""
              text: card.modelData.body
              color: Colors.on_surface_variant
              font.family: Fonts.mono
              font.pointSize: Fonts.size.small
              textFormat: Text.PlainText
              wrapMode: Text.WordWrap
            }
          }
        }

        NumberAnimation {
          id: anim
          target: card
          property: "remaining"
          from: 1
          to: 0
          duration: card.modelData.expireTimeout > 0 ? card.modelData.expireTimeout : 5000
          paused: cardMouse.containsMouse
          onFinished: card.modelData.expire()
        }
        Component.onCompleted: anim.start()
      }
    }
  }
}
