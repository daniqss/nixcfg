import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.config
import qs.widgets.common

MouseArea {
  id: battery

  readonly property var batteryDevice: UPower.displayDevice
  readonly property int percentage: Math.round(batteryDevice.percentage * 100)
  readonly property bool charging: batteryDevice.state === UPowerDeviceState.Charging
  readonly property bool low: percentage < 20 && !charging
  readonly property color color: low ? Colors.error : Colors.on_background

  property int lastPercentage: percentage
  property int lastNotifiedLevel: 100

  Layout.alignment: Qt.AlignHCenter
  implicitWidth: column.implicitWidth
  implicitHeight: column.implicitHeight
  visible: batteryDevice.isLaptopBattery
  cursorShape: Qt.PointingHandCursor

  onClicked: {
    if (!batteryProcess.running)
      batteryProcess.running = true;
  }

  function notify(title, body, icon) {
    batteryNotifier.command = ["notify-send", "-u", "critical", "-i", icon, title, body];
    batteryNotifier.running = true;
  }

  onPercentageChanged: {
    if (charging) {
      lastNotifiedLevel = 100;
      lastPercentage = percentage;
      return;
    }

    if (percentage >= lastPercentage) {
      lastPercentage = percentage;
      return;
    }

    if (percentage === 20 && lastNotifiedLevel > 20) {
      notify("Battery Low", "Battery level is at 20%", "battery-alert");
      lastNotifiedLevel = 20;
    } else if (percentage === 15 && lastNotifiedLevel > 15) {
      notify("Battery Very Low", "Battery level is at 15%", "battery-alert");
      lastNotifiedLevel = 15;
    } else if (percentage <= 12 && percentage < lastNotifiedLevel) {
      notify("Battery Critical", "Battery level is at " + percentage + "%", "battery-alert");
      lastNotifiedLevel = percentage;
    }

    lastPercentage = percentage;
  }

  ColumnLayout {
    id: column

    anchors.horizontalCenter: parent.horizontalCenter
    spacing: Sizes.bar.groupSpacing

    RowLayout {
      Layout.alignment: Qt.AlignHCenter
      spacing: 0

      Rectangle {
        implicitWidth: Sizes.battery.width
        implicitHeight: Sizes.battery.height
        radius: height / 2
        color: "transparent"
        border.width: Sizes.battery.border
        border.color: battery.color

        Rectangle {
          readonly property real maxWidth: parent.width - 2 * Sizes.battery.inset

          anchors.left: parent.left
          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.margins: Sizes.battery.inset
          width: Math.max(height, maxWidth * battery.percentage / 100)
          radius: height / 2
          color: battery.low ? Colors.error : Colors.primary
        }

        MaterialSymbol {
          anchors.centerIn: parent
          visible: battery.charging
          color: Colors.on_background
          font.pixelSize: Sizes.battery.height
          font.weight: 600
          icon: "bolt"
        }
      }

      Rectangle {
        implicitWidth: Sizes.battery.tipWidth
        implicitHeight: Sizes.battery.tipHeight
        radius: width / 2
        color: battery.color
      }
    }

    Text {
      Layout.alignment: Qt.AlignHCenter
      color: battery.color
      font.family: Fonts.mono
      font.pointSize: Fonts.size.small
      text: battery.percentage + "%"
    }
  }

  Process {
    id: batteryNotifier
  }

  Process {
    id: batteryProcess
    command: ["ghostty", "-e", "btm"]
  }
}
