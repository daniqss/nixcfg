pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Singleton {
  id: root

  // model of currently tracked notifications, usable directly as a Repeater model
  readonly property alias model: server.trackedNotifications

  NotificationServer {
    id: server

    bodySupported: true
    actionsSupported: true
    imageSupported: true
    persistenceSupported: true
    keepOnReload: false

    onNotification: notification => {
      notification.tracked = true;
    }
  }
}
