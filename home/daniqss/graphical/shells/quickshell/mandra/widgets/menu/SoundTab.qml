pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.config
import qs.data
import qs.widgets.common

// default output / input pickers with their volumes, and a mixer for every app
// playing audio where each stream can be routed to a different output
FocusScope {
  id: root

  readonly property list<PwNode> nodes: Pipewire.nodes.values.filter(n => n.audio !== null)
  readonly property list<PwNode> sinks: nodes.filter(n => n.type === PwNodeType.AudioSink)
  readonly property list<PwNode> sources: nodes.filter(n => n.type === PwNodeType.AudioSource)
  readonly property list<PwNode> streams: nodes.filter(n => n.type === PwNodeType.AudioOutStream)

  function activate(): void {
    root.forceActiveFocus();
  }

  function nodeName(node: PwNode): string {
    return node?.description || node?.nickname || node?.name || "Unknown";
  }

  // wireplumber follows the target.object metadata and relinks the stream
  function route(stream: PwNode, sink: PwNode): void {
    const serial = sink.properties["object.serial"] ?? sink.name;
    Quickshell.execDetached(["pw-metadata", String(stream.id), "target.object", String(serial)]);
  }

  PwObjectTracker {
    objects: root.nodes
  }

  component DeviceRow: ListRow {
    id: device
    required property PwNode modelData
    property bool isDefault: false

    Layout.fillWidth: true
    implicitHeight: 38
    selected: isDefault
    title: root.nodeName(modelData)

    MaterialSymbol {
      visible: device.isDefault
      color: Colors.primary
      font.pixelSize: Fonts.icon.normal
      fill: 1
      icon: "check_circle"
    }
  }

  Flickable {
    anchors.fill: parent
    contentHeight: column.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds

    ColumnLayout {
      id: column
      width: parent.width
      spacing: 6

      SectionHeader {
        text: "Output"
      }

      NodeVolume {
        Layout.fillWidth: true
        Layout.bottomMargin: 4
        node: Audio.sink
        icon: Audio.soundIcon
      }

      Repeater {
        model: root.sinks

        delegate: DeviceRow {
          symbol: "speaker"
          isDefault: modelData === Pipewire.defaultAudioSink
          onClicked: Pipewire.preferredDefaultAudioSink = modelData
        }
      }

      SectionHeader {
        Layout.topMargin: 12
        text: "Input"
      }

      NodeVolume {
        Layout.fillWidth: true
        Layout.bottomMargin: 4
        node: Audio.source
        icon: Audio.sourceIcon
      }

      Repeater {
        model: root.sources

        delegate: DeviceRow {
          symbol: "mic"
          isDefault: modelData === Pipewire.defaultAudioSource
          onClicked: Pipewire.preferredDefaultAudioSource = modelData
        }
      }

      SectionHeader {
        Layout.topMargin: 12
        text: "Applications"
      }

      Text {
        visible: root.streams.length === 0
        text: "Nothing is playing"
        color: Colors.outline
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
      }

      Repeater {
        model: root.streams

        delegate: ColumnLayout {
          id: app
          required property PwNode modelData

          readonly property var props: modelData.properties
          readonly property string appName: props["application.name"] || root.nodeName(modelData)
          readonly property string mediaName: props["media.name"] ?? ""
          readonly property string appIcon: props["application.icon-name"] || props["application.process.binary"] || ""
          readonly property PwNode target: Pipewire.linkGroups.values.find(g => g.source?.id === modelData.id)?.target ?? null
          property bool picking: false

          Layout.fillWidth: true
          Layout.topMargin: 4
          spacing: 6

          RowLayout {
            Layout.fillWidth: true
            spacing: 10

            IconImage {
              Layout.preferredWidth: 22
              Layout.preferredHeight: 22
              source: Quickshell.iconPath(app.appIcon, "audio-x-generic")
            }

            Text {
              Layout.fillWidth: true
              text: app.mediaName !== "" ? `${app.appName} · ${app.mediaName}` : app.appName
              color: Colors.on_surface
              font.family: Fonts.mono
              font.pointSize: Fonts.size.medium
              textFormat: Text.PlainText
              elide: Text.ElideRight
            }

            // current output of the stream, click to send it somewhere else
            MouseArea {
              implicitWidth: chip.implicitWidth + 20
              implicitHeight: 26
              cursorShape: Qt.PointingHandCursor
              hoverEnabled: true
              onClicked: app.picking = !app.picking

              Rectangle {
                anchors.fill: parent
                radius: height / 2
                color: app.picking || parent.containsMouse ? Colors.surface_container_highest : Colors.surface_container
                border.width: Sizes.border
                border.color: Colors.outline_variant
              }

              Row {
                id: chip
                anchors.centerIn: parent
                spacing: 4

                MaterialSymbol {
                  anchors.verticalCenter: parent.verticalCenter
                  color: Colors.primary
                  font.pixelSize: Fonts.icon.small
                  icon: "speaker"
                }

                Text {
                  anchors.verticalCenter: parent.verticalCenter
                  width: Math.min(implicitWidth, 160)
                  text: app.target ? root.nodeName(app.target) : "Default"
                  color: Colors.on_surface_variant
                  font.family: Fonts.mono
                  font.pointSize: Fonts.size.small
                  elide: Text.ElideRight
                }

                MaterialSymbol {
                  anchors.verticalCenter: parent.verticalCenter
                  color: Colors.on_surface_variant
                  font.pixelSize: Fonts.icon.small
                  icon: app.picking ? "expand_less" : "expand_more"
                }
              }
            }
          }

          NodeVolume {
            Layout.fillWidth: true
            node: app.modelData
            icon: app.modelData.audio?.muted ? "music_off" : "music_note"
          }

          Repeater {
            model: app.picking ? root.sinks : []

            delegate: DeviceRow {
              Layout.leftMargin: 32
              symbol: "subdirectory_arrow_right"
              isDefault: modelData === app.target
              onClicked: {
                root.route(app.modelData, modelData);
                app.picking = false;
              }
            }
          }
        }
      }
    }
  }
}
