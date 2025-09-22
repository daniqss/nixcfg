// from rexcrazy amazing bar,
// https://github.com/Rexcrazy804/Zaphkiel/blob/master/users/dots/quickshell/kurukurubar/Data/Audio.qml

pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  readonly property var muted: sink?.audio.muted
  readonly property PwNode sink: Pipewire.defaultAudioSink
  readonly property var sinkMuted: sink?.audio.muted
  readonly property var sinkVolume: sink?.audio.volume
  readonly property PwNode source: Pipewire.defaultAudioSource
  readonly property var sourceMuted: source?.audio.muted
  readonly property var sourceVolume: source?.audio.volume
  readonly property var volume: sink?.audio.volume

  function toggleMute(node: PwNode) {
    node.audio.muted = !node.audio.muted;
  }

  function wheelAction(event: WheelEvent, node: PwNode) {
    if (event.angleDelta.y < 0) {
      node.audio.volume -= 0.06;
    } else {
      node.audio.volume += 0.06;
    }

    if (node.audio.volume > 1) {
      node.audio.volume = 1;
    }
    if (root.sink.audio.volume < 0) {
      node.audio.volume = 0.0;
    }
  }

  PwObjectTracker {
    objects: [root.sink, root.source]
  }
}
