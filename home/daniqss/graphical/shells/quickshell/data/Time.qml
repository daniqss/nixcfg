pragma Singleton

import Quickshell
import QtQuick

Singleton {
  id: root

  readonly property string time: {

    Qt.formatDateTime(clock.date, "hh\nmm")
  }
  readonly property string date: {
    Qt.formatDateTime(clock.date, "dd/MM")
  }

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }
}