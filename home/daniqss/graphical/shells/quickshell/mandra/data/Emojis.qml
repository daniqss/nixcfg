pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: root

  // [{ name, emojis: [{ char, name }] }] in unicode order
  property list<var> groups: []
  readonly property list<var> all: groups.reduce((acc, g) => acc.concat(g.emojis), [])

  readonly property int maxRecent: 32
  // newest emoji version the installed noto color emoji draws, newer ones would show up as empty boxes
  readonly property real maxVersion: 16.0
  readonly property list<var> recent: {
    const byChar = new Map(all.map(e => [e.char, e]));
    return (recents.used ?? []).map(c => byChar.get(c)).filter(e => e !== undefined);
  }

  function use(emoji: var): void {
    recents.used = [emoji.char, ...(recents.used ?? []).filter(c => c !== emoji.char)].slice(0, maxRecent);
    recentsFile.writeAdapter();
  }

  // every query word has to show up in the name
  function search(query: string): list<var> {
    const words = query.toLowerCase().split(/\s+/).filter(w => w !== "");
    if (words.length === 0)
      return [];
    return all.filter(e => words.every(w => e.name.includes(w)));
  }

  function parse(text: string): void {
    const groups = [];
    let group = null;
    for (const line of text.split("\n")) {
      if (line.startsWith("# group: ")) {
        const name = line.slice(9).trim();
        // skin tones and hair styles on their own, not emojis to pick
        group = name === "Component" ? null : {
          name: name,
          emojis: []
        };
        if (group)
          groups.push(group);
        continue;
      }
      if (!group || !line.includes("; fully-qualified"))
        continue;
      const codes = line.split(";")[0].trim().split(" ");
      if (codes.some(c => /^1F3F[B-F]$/.test(c)))
        continue;
      // "# 😀 E1.0 grinning face"
      const [, version, name] = line.slice(line.indexOf("#") + 1).trim().match(/^\S+\s+E(\d+\.\d+)\s+(.*)$/) ?? [];
      if (!name || Number(version) > root.maxVersion)
        continue;
      group.emojis.push({
        char: String.fromCodePoint(...codes.map(c => parseInt(c, 16))),
        name: name.toLowerCase()
      });
    }
    root.groups = groups;
  }

  FileView {
    path: Quickshell.env("QS_EMOJI_DATA") ?? ""
    onLoaded: root.parse(text())
  }

  JsonAdapter {
    id: recents
    property list<string> used: []
  }

  FileView {
    id: recentsFile
    path: Quickshell.dataPath("emoji.json")
    adapter: recents
    // missing until the first emoji is picked
    printErrors: false
  }
}
