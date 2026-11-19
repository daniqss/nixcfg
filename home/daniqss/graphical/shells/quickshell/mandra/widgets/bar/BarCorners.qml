pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes

import qs.config
import qs.widgets.common

PanelWindow {
  id: panel

  required property ShellScreen modelData
  required property Reveal reveal

  component Corner: Shape {
    id: corner

    readonly property real edge: Sizes.bar.width - Sizes.border / 2
    readonly property real r: Sizes.window.rounding

    width: Sizes.bar.width + Sizes.window.rounding
    height: Sizes.window.rounding
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      fillColor: Colors.background
      strokeColor: "transparent"

      startX: corner.edge
      startY: 0

      PathLine {
        x: corner.edge + corner.r
        y: 0
      }
      PathArc {
        x: corner.edge
        y: corner.r
        radiusX: corner.r
        radiusY: corner.r
        direction: PathArc.Counterclockwise
      }
      PathLine {
        x: corner.edge
        y: 0
      }
    }

    ShapePath {
      fillColor: "transparent"
      strokeColor: Colors.surface_bright
      strokeWidth: Sizes.border

      startX: corner.edge + corner.r
      startY: -Sizes.border

      PathLine {
        x: corner.edge + corner.r
        y: 0
      }
      PathArc {
        x: corner.edge
        y: corner.r
        radiusX: corner.r
        radiusY: corner.r
        direction: PathArc.Counterclockwise
      }
    }
  }

  color: "transparent"
  implicitWidth: Sizes.bar.width + Sizes.window.rounding
  exclusionMode: ExclusionMode.Ignore
  screen: modelData
  visible: reveal.active

  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "quickshell:bar-corners"

  anchors {
    left: true
    top: true
    bottom: true
  }

  // purely decorative, every click goes to whatever is below
  mask: Region {}

  EdgeSlide {
    anchors.fill: parent
    reveal: panel.reveal
    edge: Qt.LeftEdge

    Corner {
      anchors.top: parent.top
    }

    Corner {
      anchors.bottom: parent.bottom
      transform: Scale {
        origin.y: Sizes.window.rounding / 2
        yScale: -1
      }
    }
  }
}
