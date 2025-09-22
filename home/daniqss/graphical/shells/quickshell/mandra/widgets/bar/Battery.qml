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

  visible: batteryDevice.isLaptopBattery

  function batteryIcon() {
    if (fullyCharged | percentage >= 90)
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
      return "battery_alert";
  }

  Process {
    id: batteryProcess
    command: ["ghostty", "-e", "btm"]
  }

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 20
    icon: battery.batteryIcon()

    MouseArea {
      anchors.fill: parent
      onClicked: event => {
        if (!batteryProcess.running)
          batteryProcess.running = true;
      }
    }
  }
}
