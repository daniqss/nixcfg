import QtQuick

import qs.config
import qs.data

BarIndicator {
  icon: "power_settings_new"
  iconWeight: 600
  color: Colors.error

  onClicked: MenuState.toggle("power")
}
