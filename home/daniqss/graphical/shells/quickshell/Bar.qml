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
        left: true
        right: true
      }

      implicitHeight: 20
    color: "#90382734"

      ClockWidget {
        anchors.centerIn: parent

        // no more time binding
      }
    }
  }
}