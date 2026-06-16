pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
  id: root

  readonly property WifiDevice wifiDevice: {
    for (const d of Networking.devices.values)
      if (d.type === DeviceType.Wifi)
        return d;
    return null;
  }
  readonly property WiredDevice wiredDevice: {
    for (const d of Networking.devices.values)
      if (d.type === DeviceType.Wired)
        return d;
    return null;
  }

  property list<AccessPoint> networks: []
  readonly property AccessPoint active: networks.find(n => n.active) ?? null
  readonly property bool wifiEnabled: Networking.wifiEnabled
  readonly property bool ethernet: wiredDevice?.connected ?? false
  readonly property bool scanning: wifiDevice?.scannerEnabled ?? false

  function enableWifi(enabled: bool): void {
    Networking.wifiEnabled = enabled;
  }

  function toggleWifi(): void {
    Networking.wifiEnabled = !Networking.wifiEnabled;
  }

  function rescanWifi(): void {
    if (wifiDevice)
      wifiDevice.scannerEnabled = true;
  }

  function connectToNetwork(ssid: string, password: string): void {
    const ap = networks.find(n => n.ssid === ssid);
    if (!ap)
      return;

    if (password && password.length > 0)
      ap.network.connectWithPsk(password);
    else
      ap.network.connect();
  }

  function disconnectFromNetwork(): void {
    if (active)
      active.network.disconnect();
  }

  // mirror the device's live network list into AccessPoint wrappers
  Instantiator {
    model: root.wifiDevice?.networks ?? null

    delegate: AccessPoint {
      required property var modelData
      network: modelData
    }

    onObjectAdded: (index, object) => root.networks = [...root.networks, object]
    onObjectRemoved: (index, object) => root.networks = root.networks.filter(n => n !== object)
  }

  component AccessPoint: QtObject {
    required property WifiNetwork network
    readonly property string ssid: network.name
    readonly property int frequency: 0
    readonly property int strength: Math.round((network.signalStrength ?? 0) * 100)
    readonly property bool active: network.connected
    readonly property bool isSecure: network.security !== WifiSecurityType.None
    readonly property string security: isSecure ? "secured" : ""
    readonly property string icon: {
      if (!active)
        return "signal_wifi_statusbar_not_connected";
      if (strength >= 75)
        return "signal_wifi_4_bar";
      if (strength >= 50)
        return "network_wifi_3_bar";
      if (strength >= 25)
        return "network_wifi_2_bar";
      return "signal_wifi_statusbar_null";
    }
  }
}
