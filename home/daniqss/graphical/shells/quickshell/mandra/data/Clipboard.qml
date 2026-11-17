pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

// cliphist history; each entry keeps the raw `id<TAB>preview` line since that is
// what cliphist decode/delete read back from stdin
Singleton {
  id: root

  property list<var> entries: []

  function refresh(): void {
    listProc.running = true;
  }

  function copy(entry: var): void {
    Quickshell.execDetached(["sh", "-c", "printf '%s' \"$1\" | cliphist decode | wl-copy", "sh", entry.line]);
  }

  function remove(entry: var): void {
    root.entries = root.entries.filter(e => e.id !== entry.id);
    Quickshell.execDetached(["sh", "-c", "printf '%s' \"$1\" | cliphist delete", "sh", entry.line]);
  }

  function wipe(): void {
    root.entries = [];
    Quickshell.execDetached(["cliphist", "wipe"]);
  }

  // where an image entry gets decoded to for its preview
  function imagePath(entry: var): string {
    return Quickshell.cachePath("clipboard/" + entry.id + ".png");
  }

  // command that decodes an image entry to imagePath(), skipped when already cached
  function decodeCommand(entry: var): list<string> {
    return ["sh", "-c", "mkdir -p \"$(dirname \"$2\")\" && [ -s \"$2\" ] || printf '%s' \"$1\" | cliphist decode > \"$2\"", "sh", entry.line, imagePath(entry)];
  }

  Process {
    id: listProc
    command: ["cliphist", "list"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.entries = this.text.split("\n").filter(l => l.includes("\t")).map(line => {
          const tab = line.indexOf("\t");
          const preview = line.slice(tab + 1);
          return {
            line: line,
            id: line.slice(0, tab),
            text: preview,
            isImage: /^\[\[ binary data .* (png|jpe?g|webp|gif|bmp) /.test(preview)
          };
        });
      }
    }
  }
}
