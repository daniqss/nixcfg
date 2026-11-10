import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

import qs.config

BarIndicator {
  id: battery

  readonly property var batteryDevice: UPower.displayDevice
  readonly property int percentage: Math.round(batteryDevice.percentage * 100)
  readonly property bool fullyCharged: batteryDevice.state === UPowerDeviceState.FullyCharged
  readonly property bool charging: batteryDevice.state === UPowerDeviceState.Charging
  readonly property bool low: percentage < 20 && !charging

  property int lastPercentage: percentage
  property int lastNotifiedLevel: 100

  visible: batteryDevice.isLaptopBattery
  color: low ? Colors.error : Colors.on_background
  label: percentage + "%"
  showLabel: containsMouse || low
  icon: {
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

  Process {
    id: batteryNotifier
  }

  Process {
    id: batteryProcess
    command: ["ghostty", "-e", "btm"]
  }
}
