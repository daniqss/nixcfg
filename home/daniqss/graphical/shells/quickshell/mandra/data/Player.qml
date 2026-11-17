pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Mpris

// thin wrapper over the spotify MPRIS player, exposing the current track and
// emitting trackChanged() whenever the song actually changes (spotify broke
// their own desktop notifications, so we rebuild them from MPRIS metadata)
Singleton {
  id: root

  readonly property MprisPlayer player: Mpris.players.values.find(p => `${p.identity}${p.dbusName}`.toLowerCase().includes("spotify")) ?? null

  readonly property bool available: player !== null
  readonly property string title: player?.trackTitle ?? ""
  readonly property string album: player?.trackAlbum ?? ""
  readonly property string artUrl: player?.trackArtUrl ?? ""
  // trackArtists (plural) is deprecated and now returns a plain string, so use
  // trackArtist; fall back to the album artist when no track artist is given
  readonly property string artist: player?.trackArtist || (player?.trackAlbumArtist ?? "")

  readonly property bool playing: player?.isPlaying ?? false

  signal trackChanged

  // key that changes once per song; skip the very first value so we don't pop
  // a notification for whatever is already playing when the shell starts
  readonly property string trackKey: title + "\u0000" + artUrl
  property bool primed: false
  onTrackKeyChanged: {
    if (!primed) {
      primed = true;
      return;
    }
    if (title !== "")
      root.trackChanged();
  }
}
