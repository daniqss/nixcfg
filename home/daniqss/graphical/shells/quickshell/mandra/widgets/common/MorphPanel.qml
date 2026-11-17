import QtQuick

import qs.config

// two page MorphStack switching between a compact and a full layout with `expanded`.
// `morph` is where the panel sits between both (0 compact, 1 full), handy to move things along with the morph
MorphStack {
  id: root

  property bool expanded: false
  property Item compact
  property Item full

  readonly property real morph: fromIndex === toIndex ? toIndex : toIndex === 1 ? progress : 1 - progress
  readonly property size compactSize: pageSize(0)
  readonly property size fullSize: pageSize(1)

  currentIndex: expanded ? 1 : 0
  pages: [compact, full]
}
