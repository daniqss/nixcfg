pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Pipewire

import qs.config
import qs.data
import qs.widgets.common

// default output / input pickers with their volumes, and a mixer for every app
// playing audio where each stream can be routed to a different output.
// keyboard: j/k or arrows move, h/l or arrows change the volume, enter picks
// a device (or mutes a volume, or opens an app's output list), m mutes
FocusScope {
  id: root

  readonly property list<PwNode> nodes: Pipewire.nodes.values.filter(n => n.audio !== null)
  readonly property list<PwNode> sinks: nodes.filter(n => n.type === PwNodeType.AudioSink)
  readonly property list<PwNode> sources: nodes.filter(n => n.type === PwNodeType.AudioSource)
  readonly property list<PwNode> streams: nodes.filter(n => n.type === PwNodeType.AudioOutStream)

  // stream whose output list is open, -1 for none
  property int pickingId: -1

  // everything the keyboard can land on, top to bottom. keyed so the
  // selection survives devices and streams coming and going
  readonly property var entries: {
    const list = [
      {
        key: "volume:sink",
        kind: "volume",
        node: Audio.sink
      }
    ];
    for (const n of sinks)
      list.push({
        key: `sink:${n.id}`,
        kind: "sink",
        node: n
      });
    list.push({
      key: "volume:source",
      kind: "volume",
      node: Audio.source
    });
    for (const n of sources)
      list.push({
        key: `source:${n.id}`,
        kind: "source",
        node: n
      });
    for (const s of streams) {
      list.push({
        key: `app:${s.id}`,
        kind: "app",
        node: s
      });
      if (s.id === pickingId)
        for (const n of sinks)
          list.push({
            key: `route:${s.id}:${n.id}`,
            kind: "route",
            stream: s,
            node: n
          });
    }
    return list;
  }

  property string focusKey: "volume:sink"
  readonly property var focused: entries.find(e => e.key === focusKey) ?? null

  function activate(): void {
    focusKey = "volume:sink";
    pickingId = -1;
    flick.contentY = 0;
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

  function move(step: int): void {
    const i = Math.max(0, entries.findIndex(e => e.key === focusKey));
    focusKey = entries[Math.max(0, Math.min(entries.length - 1, i + step))]?.key ?? focusKey;
  }

  function nudgeVolume(step: real): void {
    const audio = focused?.kind === "volume" || focused?.kind === "app" ? focused.node?.audio : null;
    if (audio)
      audio.volume = Math.max(0, Math.min(1, audio.volume + step));
  }

  function toggleMute(): void {
    const audio = focused?.node?.audio;
    if (audio && focused.kind !== "route")
      audio.muted = !audio.muted;
  }

  function accept(): void {
    const e = focused;
    if (!e)
      return;
    switch (e.kind) {
    case "volume":
      toggleMute();
      break;
    case "sink":
      Pipewire.preferredDefaultAudioSink = e.node;
      break;
    case "source":
      Pipewire.preferredDefaultAudioSource = e.node;
      break;
    case "app":
      pickingId = pickingId === e.node.id ? -1 : e.node.id;
      break;
    case "route":
      route(e.stream, e.node);
      pickingId = -1;
      focusKey = `app:${e.stream.id}`;
      break;
    }
  }

  // scrolls just enough to show a focused item
  function reveal(item: Item): void {
    const y = item.mapToItem(column, 0, 0).y;
    if (y < flick.contentY)
      flick.contentY = y;
    else if (y + item.height > flick.contentY + flick.height)
      flick.contentY = y + item.height - flick.height;
  }

  Keys.onUpPressed: move(-1)
  Keys.onDownPressed: move(1)
  Keys.onLeftPressed: nudgeVolume(-0.05)
  Keys.onRightPressed: nudgeVolume(0.05)
  Keys.onReturnPressed: accept()
  Keys.onEnterPressed: accept()
  Keys.onSpacePressed: accept()
  Keys.onPressed: event => {
    const action = {
      [Qt.Key_J]: () => move(1),
      [Qt.Key_K]: () => move(-1),
      [Qt.Key_H]: () => nudgeVolume(-0.05),
      [Qt.Key_L]: () => nudgeVolume(0.05),
      [Qt.Key_M]: () => toggleMute()
    }[event.key];
    if (action && event.modifiers === Qt.NoModifier) {
      action();
      event.accepted = true;
    }
  }

  PwObjectTracker {
    objects: root.nodes
  }

  // highlight around whatever the keyboard is on
  component Frame: Rectangle {
    id: frame
    required property string key
    default property alias content: inner.data
    readonly property bool focused: root.focusKey === key

    Layout.fillWidth: true
    implicitHeight: (inner.children[0]?.implicitHeight ?? 0) + 12
    radius: Sizes.radius
    color: focused ? Colors.surface_container_highest : "transparent"
    onFocusedChanged: {
      if (focused)
        root.reveal(frame);
    }

    Item {
      id: inner
      anchors {
        fill: parent
        margins: 6
        leftMargin: 10
        rightMargin: 10
      }
    }
  }

  component DeviceRow: ListRow {
    id: device
    required property PwNode modelData
    required property string key
    property bool isDefault: false

    Layout.fillWidth: true
    implicitHeight: 40
    selected: root.focusKey === key
    title: root.nodeName(modelData)
    onSelectedChanged: {
      if (selected)
        root.reveal(device);
    }
    // pressed, not clicked: the users of the row handle clicked themselves
    onPressed: root.focusKey = key

    MaterialSymbol {
      visible: device.isDefault
      color: Colors.primary
      font.pixelSize: Fonts.icon.normal
      fill: 1
      icon: "check_circle"
    }
  }

  Flickable {
    id: flick
    anchors.fill: parent
    contentHeight: column.implicitHeight
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    QQC.ScrollBar.vertical: MenuScrollBar {}

    Behavior on contentY {
      NumberAnimation {
        duration: Sizes.animDuration
        easing.type: Easing.OutCubic
      }
    }

    ColumnLayout {
      id: column
      width: parent.width - Sizes.menu.scrollGap
      spacing: 4

      SectionHeader {
        text: "Output"
      }

      Frame {
        key: "volume:sink"

        NodeVolume {
          anchors.left: parent.left
          anchors.right: parent.right
          node: Audio.sink
          icon: Audio.soundIcon
        }
      }

      Repeater {
        model: root.sinks

        delegate: DeviceRow {
          key: `sink:${modelData.id}`
          symbol: "speaker"
          isDefault: modelData === Pipewire.defaultAudioSink
          onClicked: Pipewire.preferredDefaultAudioSink = modelData
        }
      }

      SectionHeader {
        Layout.topMargin: 12
        text: "Input"
      }

      Frame {
        key: "volume:source"

        NodeVolume {
          anchors.left: parent.left
          anchors.right: parent.right
          node: Audio.source
          icon: Audio.sourceIcon
        }
      }

      Repeater {
        model: root.sources

        delegate: DeviceRow {
          key: `source:${modelData.id}`
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
          readonly property bool picking: root.pickingId === modelData.id

          Layout.fillWidth: true
          spacing: 4

          Frame {
            key: `app:${app.modelData.id}`

            ColumnLayout {
              anchors.left: parent.left
              anchors.right: parent.right
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

                // current output of the stream, click (or enter) to send it somewhere else
                MouseArea {
                  implicitWidth: chip.implicitWidth + 20
                  implicitHeight: 26
                  cursorShape: Qt.PointingHandCursor
                  hoverEnabled: true
                  onClicked: {
                    root.focusKey = `app:${app.modelData.id}`;
                    root.pickingId = app.picking ? -1 : app.modelData.id;
                  }

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
            }
          }

          Repeater {
            model: app.picking ? root.sinks : []

            delegate: DeviceRow {
              Layout.leftMargin: 32
              key: `route:${app.modelData.id}:${modelData.id}`
              symbol: "subdirectory_arrow_right"
              isDefault: modelData === app.target
              onClicked: {
                root.route(app.modelData, modelData);
                root.pickingId = -1;
              }
            }
          }
        }
      }
    }
  }
}
