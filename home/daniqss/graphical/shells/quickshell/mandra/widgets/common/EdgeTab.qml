import QtQuick
import QtQuick.Shapes

import qs.config

// a panel growing out of a screen edge, joined to it by two concave corners
// like the bar is joined to the top and bottom edges. the side touching the
// edge is pushed off screen so only the other borders show.
// the body spans the item minus `flare` at both ends along the edge.
// the path is drawn for the bottom edge and rotated into place for the others
Item {
  id: root

  property int edge: Qt.BottomEdge
  property real flare: Sizes.window.rounding
  property real rounding: Sizes.window.rounding

  readonly property bool sideways: edge === Qt.LeftEdge || edge === Qt.RightEdge

  Shape {
    id: shape

    anchors.centerIn: parent
    width: root.sideways ? root.height : root.width
    height: root.sideways ? root.width : root.height
    rotation: root.edge === Qt.RightEdge ? -90 : root.edge === Qt.LeftEdge ? 90 : root.edge === Qt.TopEdge ? 180 : 0
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      id: outline

      readonly property real w: shape.width
      readonly property real h: shape.height
      readonly property real f: root.flare
      readonly property real r: root.rounding
      readonly property real half: Sizes.border / 2
      readonly property real out: Sizes.border

      fillColor: Colors.background
      strokeColor: Colors.surface_bright
      strokeWidth: Sizes.border

      startX: 0
      startY: outline.h + outline.out

      PathLine {
        x: 0
        y: outline.h
      }
      PathArc {
        x: outline.f + outline.half
        y: outline.h - outline.f
        radiusX: outline.f
        radiusY: outline.f
        direction: PathArc.Counterclockwise
      }
      PathLine {
        x: outline.f + outline.half
        y: outline.r + outline.half
      }
      PathArc {
        x: outline.f + outline.r + outline.half
        y: outline.half
        radiusX: outline.r
        radiusY: outline.r
      }
      PathLine {
        x: outline.w - outline.f - outline.r - outline.half
        y: outline.half
      }
      PathArc {
        x: outline.w - outline.f - outline.half
        y: outline.r + outline.half
        radiusX: outline.r
        radiusY: outline.r
      }
      PathLine {
        x: outline.w - outline.f - outline.half
        y: outline.h - outline.f
      }
      PathArc {
        x: outline.w
        y: outline.h
        radiusX: outline.f
        radiusY: outline.f
        direction: PathArc.Counterclockwise
      }
      PathLine {
        x: outline.w
        y: outline.h + outline.out
      }
      PathLine {
        x: 0
        y: outline.h + outline.out
      }
    }
  }
}
