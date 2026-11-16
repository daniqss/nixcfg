pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Bluetooth as BT

import qs.config
import qs.widgets.common

// adapter power and scanning, plus every known device: connected ones first,
// then paired, then whatever the scan found. enter / click (dis)connects
FocusScope {
  id: root

  readonly property BT.BluetoothAdapter adapter: BT.Bluetooth.defaultAdapter

  readonly property var devices: {
    const rank = d => d.connected ? 0 : d.paired ? 1 : 2;
    return (adapter?.devices.values ?? []).slice().sort((a, b) => rank(a) - rank(b) || a.name.localeCompare(b.name));
  }

  function activate(): void {
    list.currentIndex = 0;
    root.forceActiveFocus();
  }

  function stateText(d: var): string {
    switch (d.state) {
    case BT.BluetoothDeviceState.Connecting:
      return "Connecting…";
    case BT.BluetoothDeviceState.Disconnecting:
      return "Disconnecting…";
    }
    if (d.pairing)
      return "Pairing…";
    if (d.connected)
      return "Connected";
    return d.paired ? "Paired" : d.address;
  }

  function symbolFor(icon: string): string {
    if (icon.includes("headset") || icon.includes("headphone"))
      return "headphones";
    if (icon.includes("audio"))
      return "speaker";
    if (icon.includes("phone"))
      return "smartphone";
    if (icon.includes("mouse"))
      return "mouse";
    if (icon.includes("keyboard"))
      return "keyboard";
    if (icon.includes("gaming") || icon.includes("joystick"))
      return "sports_esports";
    if (icon.includes("computer"))
      return "computer";
    return "bluetooth";
  }

  // a new device gets paired and trusted first so it reconnects by itself later
  function activateDevice(d: var): void {
    if (!d)
      return;
    if (d.connected) {
      d.disconnect();
    } else if (d.paired) {
      d.connect();
    } else {
      d.trusted = true;
      d.pair();
    }
  }

  function move(step: int): void {
    list.currentIndex = Math.max(0, Math.min(list.count - 1, list.currentIndex + step));
  }

  Keys.onUpPressed: move(-1)
  Keys.onDownPressed: move(1)
  Keys.onReturnPressed: activateDevice(devices[list.currentIndex])
  Keys.onEnterPressed: activateDevice(devices[list.currentIndex])
  Keys.onPressed: event => {
    if (event.key === Qt.Key_J) {
      root.move(1);
      event.accepted = true;
    } else if (event.key === Qt.Key_K) {
      root.move(-1);
      event.accepted = true;
    } else if (event.key === Qt.Key_S) {
      if (root.adapter)
        root.adapter.discovering = !root.adapter.discovering;
      event.accepted = true;
    } else if (event.key === Qt.Key_Delete) {
      root.devices[list.currentIndex]?.forget();
      event.accepted = true;
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: 12

    // adapter header
    Rectangle {
      Layout.fillWidth: true
      implicitHeight: 52
      radius: Sizes.radius
      color: Colors.surface_container
      border.width: Sizes.border
      border.color: Colors.outline_variant

      RowLayout {
        anchors {
          fill: parent
          leftMargin: 14
          rightMargin: 10
        }
        spacing: 10

        MaterialSymbol {
          color: root.adapter?.enabled ? Colors.primary : Colors.outline
          font.pixelSize: Fonts.icon.large
          font.weight: 600
          icon: root.adapter?.enabled ? "bluetooth" : "bluetooth_disabled"
        }

        ColumnLayout {
          Layout.fillWidth: true
          spacing: 0

          Text {
            Layout.fillWidth: true
            text: root.adapter?.name ?? "No adapter"
            color: Colors.on_surface
            font.family: Fonts.mono
            font.pointSize: Fonts.size.medium
            font.weight: 700
          }

          Text {
            Layout.fillWidth: true
            text: {
              if (!root.adapter)
                return "bluetooth is unavailable";
              if (!root.adapter.enabled)
                return "off";
              return root.adapter.discovering ? "scanning for devices…" : `${root.devices.filter(d => d.connected).length} connected`;
            }
            color: Colors.on_surface_variant
            font.family: Fonts.mono
            font.pointSize: Fonts.size.small
          }
        }

        IconButton {
          icon: "radar"
          enabled: root.adapter?.enabled ?? false
          active: root.adapter?.discovering ?? false
          onClicked: root.adapter.discovering = !root.adapter.discovering

          RotationAnimation on rotation {
            running: root.adapter?.discovering ?? false
            from: 0
            to: 360
            duration: 2000
            loops: Animation.Infinite
            alwaysRunToEnd: true
          }
        }

        IconButton {
          icon: "power_settings_new"
          active: root.adapter?.enabled ?? false
          enabled: root.adapter !== null
          onClicked: root.adapter.enabled = !root.adapter.enabled
        }
      }
    }

    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: 2
      model: root.adapter?.enabled ? root.devices : []
      boundsBehavior: Flickable.StopAtBounds
      QQC.ScrollBar.vertical: MenuScrollBar {}
      highlightMoveDuration: 0

      delegate: ListRow {
        id: row
        required property var modelData
        required property int index

        width: ListView.view.width - Sizes.menu.scrollGap
        selected: ListView.isCurrentItem
        title: modelData.name || modelData.deviceName || modelData.address
        subtitle: root.stateText(modelData)
        symbol: root.symbolFor(modelData.icon ?? "")
        symbolColor: modelData.connected ? Colors.primary : Colors.on_surface
        onClicked: {
          list.currentIndex = index;
          root.activateDevice(modelData);
        }

        Text {
          visible: row.modelData.batteryAvailable
          text: Math.round(row.modelData.battery * 100) + "%"
          color: Colors.on_surface_variant
          font.family: Fonts.mono
          font.pointSize: Fonts.size.small
        }

        IconButton {
          visible: row.modelData.paired
          icon: "link_off"
          color: Colors.error
          size: 28
          onClicked: row.modelData.forget()
        }
      }

      Text {
        anchors.centerIn: parent
        visible: list.count === 0
        text: root.adapter?.enabled ? "No devices, press S to scan" : "Bluetooth is off"
        color: Colors.outline
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
      }
    }
  }
}
