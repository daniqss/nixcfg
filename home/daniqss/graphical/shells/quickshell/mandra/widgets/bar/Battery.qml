import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

import qs.config as Config
import qs.widgets.common as Common

RowLayout {
  readonly property var battery: UPower.displayDevice
  readonly property int percentage: Math.round(battery.percentage * 100)

  function batteryIcon() {
    if (battery.state === UPowerDeviceState.Charging)
      return "battery_charging_full";
    else if (battery.state === UPowerDeviceState.FullyCharged || percentage >= 90)
      return "battery_full";
    else if (percentage >= 80)
      return "battery_6_bar";
    else if (percentage >= 70)
      return "battery_5_bar";
    else if (percentage >= 60)
      return "battery_4_bar";
    else if (percentage >= 50)
      return "battery_3_bar";
    else if (percentage >= 40)
      return "battery_2_bar";
    else if (percentage >= 30)
      return "battery_1_bar";
    else if (percentage >= 20)
      return "battery_0_bar";
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
