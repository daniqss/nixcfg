import QtQuick.Layouts

import qs.data
import qs.widgets.common
import qs.config

RowLayout {
  spacing: 0

  visible: Networking.active !== null

  MaterialSymbol {
    color: Colors.on_background
    font.pixelSize: 20
    icon: Networking.active ? Networking.active.icon : "signal_wifi_statusbar_not_connected"
  }
}
