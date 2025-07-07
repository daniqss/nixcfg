// Bar.qml
import Quickshell

Scope {
  // no more time object

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        bottom: true
        left: true
      }

      implicitWidth: 35
      color: "#90382734"

      ClockWidget {
        anchors.centerIn: parent

        // no more time binding
      }
    }
  }
}