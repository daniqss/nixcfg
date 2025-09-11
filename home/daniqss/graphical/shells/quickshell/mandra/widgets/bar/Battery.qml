import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.config as Config
import qs.widgets.common as Common

RowLayout {
  readonly property var battery: UPower.displayDevice
  readonly property int percentage: Math.round(battery.percentage * 100)
  property bool fullyCharged: battery.state === UPowerDeviceState.FullyCharged
  property bool charging: battery.state === UPowerDeviceState.Charging

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

  visible: battery.isLaptopBattery

  Text {
    Layout.alignment: Qt.AlignHCenter
    color: Config.Colors.on_background
    font.family: "CaskaydiaCove Nerd Font"
    font.pointSize: 13
    text: parent.percentage
  }

  Common.MaterialSymbol {
    color: Config.Colors.on_background
    font.pixelSize: 20
    icon: parent.batteryIcon()
  }
}
