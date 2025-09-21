import qs.data
import qs.widgets.common
import qs.config

MaterialSymbol {
  color: Colors.on_background
  font.pixelSize: 20
  icon: Networking.active ? Networking.active.icon : "signal_wifi_statusbar_not_connected"
}
