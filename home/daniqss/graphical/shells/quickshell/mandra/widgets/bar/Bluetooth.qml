import Quickshell.Io
import Quickshell.Bluetooth as BT
import QtQuick

BarIndicator {
  readonly property BT.BluetoothAdapter adapter: BT.Bluetooth.defaultAdapter
  readonly property var connectedDevices: BT.Bluetooth.devices.values.filter(d => d.connected)

  visible: adapter !== null
  label: connectedDevices.map(d => d.name).join(", ")
  verticalLabel: true
  icon: {
    if (!adapter?.enabled)
      return "bluetooth_disabled";
    return connectedDevices.length > 0 ? "bluetooth_connected" : "bluetooth";
  }

  onClicked: {
    if (!bluetoothProcess.running)
      bluetoothProcess.running = true;
  }

  Process {
    id: bluetoothProcess
    command: ["vicinae", "vicinae://launch/@Gelei/vicinae-extension-bluetooth-0/devices"]
  }
}
