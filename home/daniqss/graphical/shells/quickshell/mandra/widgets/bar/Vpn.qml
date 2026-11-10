import QtQuick

import qs.data

BarIndicator {
  visible: Vpn.active !== ""
  icon: "vpn_lock"
  label: Vpn.active
  verticalLabel: true
  cursorShape: Qt.ArrowCursor
}
