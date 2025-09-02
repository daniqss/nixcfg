pragma Singleton

import QtQuick
import Quickshell

Singleton {
  id: timeSingleton

  SystemClock {
    id: clock
    precision: SystemClock.Seconds
  }

  readonly property string _formatted: Qt.formatDateTime(clock.date, "hh:mm:ss-dd:MM")

  readonly property string hours: _formatted.split("-")[0].split(":")[0]
  readonly property string minutes: _formatted.split("-")[0].split(":")[1]
  readonly property string seconds: _formatted.split("-")[0].split(":")[2]
  readonly property string day: _formatted.split("-")[1].split(":")[0]
  readonly property string month: _formatted.split("-")[1].split(":")[1]

  readonly property string time: hours + ":" + minutes
  readonly property string date: day + "/" + month
}
