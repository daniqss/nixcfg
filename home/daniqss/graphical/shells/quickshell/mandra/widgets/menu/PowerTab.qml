pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Services.UPower

import qs.config
import qs.data
import qs.widgets.common

// session actions on top, and every battery upower knows about below
// (the laptop's own plus bluetooth headphones, mice, controllers...)
FocusScope {
  id: root

  readonly property var actions: [
    {
      name: "Power off",
      icon: "power_settings_new",
      command: ["systemctl", "poweroff"]
    },
    {
      name: "Reboot",
      icon: "restart_alt",
      command: ["systemctl", "reboot"]
    },
    {
      name: "Log out",
      icon: "logout",
      command: ["hyprctl", "dispatch", "hl.dsp.exit()"]
    },
    {
      name: "Lock",
      icon: "lock",
      command: ["loginctl", "lock-session"]
    },
    {
      name: "Suspend",
      icon: "bedtime",
      command: ["systemctl", "suspend"]
    }
  ]

  property int current: 0

  readonly property var batteries: UPower.devices.values.filter(d => d.isPresent && d.type !== UPowerDeviceType.LinePower && d.type !== UPowerDeviceType.Unknown).sort((a, b) => b.isLaptopBattery - a.isLaptopBattery)

  function activate(): void {
    current = 0;
    root.forceActiveFocus();
  }

  function run(action: var): void {
    MenuState.close();
    Quickshell.execDetached(action.command);
  }

  function batteryName(d: var): string {
    if (d.isLaptopBattery)
      return "Laptop";
    return d.model || UPowerDeviceType.toString(d.type);
  }

  function batterySymbol(d: var): string {
    switch (d.type) {
    case UPowerDeviceType.Headset:
    case UPowerDeviceType.Headphones:
      return "headphones";
    case UPowerDeviceType.Mouse:
      return "mouse";
    case UPowerDeviceType.Keyboard:
      return "keyboard";
    case UPowerDeviceType.GamingInput:
      return "sports_esports";
    case UPowerDeviceType.Phone:
      return "smartphone";
    case UPowerDeviceType.Speakers:
      return "speaker";
    }
    return d.state === UPowerDeviceState.Charging ? "battery_charging_full" : "battery_full";
  }

  function batteryState(d: var): string {
    const mins = s => `${Math.floor(s / 3600)}h ${Math.round(s % 3600 / 60)}m`;
    switch (d.state) {
    case UPowerDeviceState.Charging:
      return d.timeToFull > 0 ? `charging, full in ${mins(d.timeToFull)}` : "charging";
    case UPowerDeviceState.Discharging:
      return d.timeToEmpty > 0 ? `${mins(d.timeToEmpty)} left` : "discharging";
    case UPowerDeviceState.FullyCharged:
      return "fully charged";
    }
    return "";
  }

  function move(step: int): void {
    current = (current + step + actions.length) % actions.length;
  }

  Keys.onLeftPressed: move(-1)
  Keys.onRightPressed: move(1)
  Keys.onPressed: event => {
    if (event.key === Qt.Key_H) {
      move(-1);
      event.accepted = true;
    } else if (event.key === Qt.Key_L) {
      move(1);
      event.accepted = true;
    }
  }
  Keys.onReturnPressed: run(actions[current])
  Keys.onEnterPressed: run(actions[current])

  // only as tall as its content, the menu shrinks to it when switching here
  implicitHeight: Math.min(content.implicitHeight, Sizes.menu.pageHeight - 2 * (Sizes.popup.padding + 4))

  ColumnLayout {
    id: content
    anchors.fill: parent
    spacing: 14

    RowLayout {
      Layout.fillWidth: true
      spacing: 10

      Repeater {
        model: root.actions

        delegate: MouseArea {
          id: action
          required property var modelData
          required property int index
          readonly property bool selected: root.current === index

          Layout.fillWidth: true
          implicitHeight: 104
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor
          onEntered: root.current = index
          onClicked: root.run(modelData)

          Rectangle {
            anchors.fill: parent
            radius: Sizes.radius
            color: action.selected ? (action.index === 0 ? Colors.error : Colors.primary) : Colors.surface_container
            border.width: Sizes.border
            border.color: action.selected ? "transparent" : Colors.outline_variant

            Behavior on color {
              ColorAnimation {
                duration: Sizes.animDuration
              }
            }
          }

          ColumnLayout {
            anchors.centerIn: parent
            spacing: 8

            MaterialSymbol {
              Layout.alignment: Qt.AlignHCenter
              color: action.selected ? (action.index === 0 ? Colors.on_error : Colors.on_primary) : Colors.on_surface
              font.pixelSize: 32
              font.weight: 600
              fill: action.selected ? 1 : 0
              icon: action.modelData.icon
            }

            Text {
              Layout.alignment: Qt.AlignHCenter
              text: action.modelData.name
              color: action.selected ? (action.index === 0 ? Colors.on_error : Colors.on_primary) : Colors.on_surface_variant
              font.family: Fonts.mono
              font.pointSize: Fonts.size.small
              font.weight: 600
            }
          }
        }
      }
    }

    SectionHeader {
      Layout.topMargin: 8
      text: "Batteries"
    }

    Text {
      visible: root.batteries.length === 0
      text: "No batteries reported by upower"
      color: Colors.outline
      font.family: Fonts.mono
      font.pointSize: Fonts.size.medium
    }

    Flickable {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.preferredHeight: batteryColumn.implicitHeight
      contentHeight: batteryColumn.implicitHeight
      clip: true
      boundsBehavior: Flickable.StopAtBounds
      QQC.ScrollBar.vertical: MenuScrollBar {}

      ColumnLayout {
        id: batteryColumn
        width: parent.width - Sizes.menu.scrollGap
        spacing: 10

        Repeater {
          model: root.batteries

          delegate: RowLayout {
            id: battery
            required property var modelData
            readonly property real level: modelData.percentage

            Layout.fillWidth: true
            spacing: 12

            MaterialSymbol {
              Layout.preferredWidth: 28
              horizontalAlignment: Text.AlignHCenter
              color: battery.level < 0.2 ? Colors.error : Colors.on_surface
              font.pixelSize: Fonts.icon.large
              icon: root.batterySymbol(battery.modelData)
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 4

              RowLayout {
                Layout.fillWidth: true

                Text {
                  Layout.fillWidth: true
                  text: root.batteryName(battery.modelData)
                  color: Colors.on_surface
                  font.family: Fonts.mono
                  font.pointSize: Fonts.size.medium
                  elide: Text.ElideRight
                }

                Text {
                  text: root.batteryState(battery.modelData)
                  color: Colors.on_surface_variant
                  font.family: Fonts.mono
                  font.pointSize: Fonts.size.small
                }
              }

              VolumeSlider {
                Layout.fillWidth: true
                implicitHeight: 8
                enabled: false
                value: battery.level
                fillColor: battery.level < 0.2 ? Colors.error : Colors.primary
              }
            }

            Text {
              Layout.preferredWidth: 40
              horizontalAlignment: Text.AlignRight
              text: Math.round(battery.level * 100) + "%"
              color: Colors.on_surface_variant
              font.family: Fonts.mono
              font.pointSize: Fonts.size.medium
            }
          }
        }
      }
    }
  }
}
