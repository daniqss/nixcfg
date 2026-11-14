pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

import qs.config
import qs.data

// application launcher: fuzzy-ish search over desktop entries, ranked by how
// well the name matches and then by how often each app was launched from here
FocusScope {
  id: root

  readonly property string query: search.text.trim().toLowerCase()

  readonly property var apps: {
    const seen = new Set();
    return DesktopEntries.applications.values.filter(e => {
      if (e.noDisplay || seen.has(e.id))
        return false;
      seen.add(e.id);
      return true;
    });
  }

  readonly property var results: {
    const counts = launches.counts;
    return apps.map(e => ({
          entry: e,
          score: root.score(e, root.query),
          uses: counts[e.id] ?? 0
        })).filter(r => r.score > 0).sort((a, b) => b.score - a.score || b.uses - a.uses || a.entry.name.localeCompare(b.entry.name)).map(r => r.entry);
  }

  function activate(): void {
    search.clear();
    list.currentIndex = 0;
    search.focusInput();
  }

  function score(entry: var, q: string): int {
    if (q === "")
      return 1;
    const name = (entry.name ?? "").toLowerCase();
    if (name === q)
      return 100;
    if (name.startsWith(q))
      return 80;
    if (name.split(/[\s\-_.]+/).some(w => w.startsWith(q)))
      return 60;
    if (name.includes(q))
      return 40;
    const extra = [entry.genericName, entry.comment, entry.id, ...(entry.keywords ?? [])].join(" ").toLowerCase();
    if (extra.includes(q))
      return 20;
    // every query character appears in order in the name
    let i = 0;
    for (const c of name)
      if (c === q[i])
        i++;
    return i === q.length ? 10 : 0;
  }

  function launch(entry: var): void {
    if (!entry)
      return;
    const counts = Object.assign({}, launches.counts);
    counts[entry.id] = (counts[entry.id] ?? 0) + 1;
    launches.counts = counts;
    launchesFile.writeAdapter();
    entry.execute();
    MenuState.close();
  }

  FileView {
    id: launchesFile
    path: Quickshell.dataPath("launches.json")
    // missing until the first launch
    printErrors: false

    JsonAdapter {
      id: launches
      property var counts: ({})
    }
  }

  ColumnLayout {
    anchors.fill: parent
    spacing: 12

    SearchField {
      id: search
      placeholder: "Search applications"
      onTextChanged: list.currentIndex = 0
      onMoved: step => list.currentIndex = Math.max(0, Math.min(list.count - 1, list.currentIndex + step))
      onAccepted: root.launch(root.results[list.currentIndex])
    }

    ListView {
      id: list
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      spacing: 2
      model: root.results
      boundsBehavior: Flickable.StopAtBounds
      highlightMoveDuration: 0

      delegate: ListRow {
        required property var modelData
        required property int index

        width: ListView.view.width
        selected: ListView.isCurrentItem
        title: modelData.name
        subtitle: modelData.comment || modelData.genericName || ""
        iconSource: Quickshell.iconPath(modelData.icon, "application-x-executable")
        onClicked: root.launch(modelData)
      }

      Text {
        anchors.centerIn: parent
        visible: list.count === 0
        text: "No applications match"
        color: Colors.outline
        font.family: Fonts.mono
        font.pointSize: Fonts.size.medium
      }
    }
  }
}
