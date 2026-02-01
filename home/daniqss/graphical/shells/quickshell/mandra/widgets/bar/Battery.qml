import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.config
import qs.widgets.common

RowLayout {
  id: battery
  spacing: 0

  readonly property var batteryDevice: UPower.displayDevice
  readonly property int percentage: Math.round(batteryDevice.percentage * 100)
  property bool fullyCharged: batteryDevice.state === UPowerDeviceState.FullyCharged
  property bool charging: batteryDevice.state === UPowerDeviceState.Charging

  property int lastPercentage: percentage
  property int lastNotifiedLevel: 100

  visible: batteryDevice.isLaptopBattery

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

  function batteryIcon() {
    if (!batteryDevice.isLaptopBattery)
      return;

    if (fullyCharged || percentage >= 90)
      return "battery_full";
    else if (percentage >= 80)
      return !charging ? "battery_6_bar" : "battery_charging_90";
    else if (percentage >= 70)
      return !charging ? "battery_5_bar" : "battery_charging_80";
    else if (percentage >= 60)
      return !charging ? "battery_4_bar" : "battery_charging_80";
    else if (percentage >= 50)
      return !charging ? "battery_3_bar" : "battery_charging_30";
    else if (percentage >= 40)
      return !charging ? "battery_2_bar" : "battery_charging_30";
    else if (percentage >= 30)
      return !charging ? "battery_1_bar" : "battery_charging_20";
    else if (percentage >= 20)
      return !charging ? "battery_0_bar" : "battery_charging_full";
    else
      return !charging ? "battery_alert" : "battery_charging_full";
  }

  Process {
    id: batteryNotifier
  }

  Process {
    id: batteryProcess
    command: ["ghostty", "-e", "btm"]
  }

  MaterialSymbol {
    color: (battery.percentage < 20 && !battery.charging) ? Colors.on_error : Colors.on_background

    font.pixelSize: 20
    icon: battery.batteryIcon()

    MouseArea {
      anchors.fill: parent
      onClicked: {
        if (!batteryProcess.running)
          batteryProcess.running = true;
      }
    }
  }
}
