pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.widgets.bar
import qs.config
import qs.widgets.common

Scope {
  // slides the bar in and out of the left edge
  Reveal {
    id: barReveal
    shown: true
  }

  CommunicationHandler {
    target: "bar"
    commands: [
      {
        name: "toggle",
        description: "slide the bar in or out",
        run: () => barReveal.shown = !barReveal.shown
      },
      {
        name: "show",
        description: "slide the bar in",
        shortcut: false,
        run: () => barReveal.shown = true
      },
      {
        name: "hide",
        description: "slide the bar out",
        shortcut: false,
        run: () => barReveal.shown = false
      }
    ]
  }

  Variants {
    model: Quickshell.screens

    BarCorners {
      reveal: barReveal
    }
  }

  Variants {
    model: Quickshell.screens

    PanelWindow {
      id: panel

      required property ShellScreen modelData

      color: "transparent"
      // extra room on the right for the inverted corners, which must not reserve space
      implicitWidth: Sizes.bar.width + Sizes.window.rounding
      // follows the slide so the windows reflow along with the bar
      exclusiveZone: Math.round(Sizes.bar.width * barReveal.progress)
      screen: modelData
      visible: barReveal.active

      WlrLayershell.layer: WlrLayer.Bottom

      // flush against the left edge, spanning the whole screen height
      anchors {
        left: true
        top: true
        bottom: true
      }

      // the corners are only decoration, clicks there go to the windows below
      mask: Region {
        // explicit geometry so the input region follows the slide, see Osd.qml
        x: barSlide.holder.x + barArea.x
        y: barSlide.holder.y + barArea.y
        width: barArea.width
        height: barArea.height
      }

      // the bar plus two concave corners joining it to the top and bottom screen edges,
      // the left, top and bottom sides are pushed off screen so only the inner border shows
      EdgeSlide {
        id: barSlide
        anchors.fill: parent
        reveal: barReveal
        edge: Qt.LeftEdge

        Shape {
          anchors.fill: parent
          preferredRendererType: Shape.CurveRenderer

          ShapePath {
            id: outline

            readonly property real edge: Sizes.bar.width - Sizes.border / 2
            readonly property real r: Sizes.window.rounding
            readonly property real out: Sizes.border
            readonly property real h: panel.height

            fillColor: Colors.background
            strokeColor: Colors.surface_bright
            strokeWidth: Sizes.border

            startX: -outline.out
            startY: -outline.out

            PathLine {
              x: outline.edge + outline.r
              y: -outline.out
            }
            PathLine {
              x: outline.edge + outline.r
              y: 0
            }
            PathArc {
              x: outline.edge
              y: outline.r
              radiusX: outline.r
              radiusY: outline.r
              direction: PathArc.Counterclockwise
            }
            PathLine {
              x: outline.edge
              y: outline.h - outline.r
            }
            PathArc {
              x: outline.edge + outline.r
              y: outline.h
              radiusX: outline.r
              radiusY: outline.r
              direction: PathArc.Counterclockwise
            }
            PathLine {
              x: outline.edge + outline.r
              y: outline.h + outline.out
            }
            PathLine {
              x: -outline.out
              y: outline.h + outline.out
            }
            PathLine {
              x: -outline.out
              y: -outline.out
            }
          }
        }

        Item {
          id: barArea

          anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
          }
          width: Sizes.bar.width

          ColumnLayout {
            id: content

            anchors {
              top: parent.top
              bottom: parent.bottom
              horizontalCenter: parent.horizontalCenter
              // keep the content centered in the area left of the border
              horizontalCenterOffset: -Sizes.border / 2
              topMargin: Sizes.bar.padding
              bottomMargin: Sizes.bar.padding
            }
            spacing: Sizes.bar.spacing

            OsIcon {}
            Workspaces {
              screen: panel.screen
              wsCount: 9
            }

            // pushes the status widgets to the bottom of the bar
            Item {
              Layout.fillHeight: true
            }

            Systray {
              id: systray
            }
            Separator {
              visible: systray.visible
            }
            ColumnLayout {
              Layout.alignment: Qt.AlignHCenter
              spacing: Sizes.bar.groupSpacing

              Sound {}
              Network {}
              Bluetooth {}
              Vpn {}
            }
            Separator {}
            Battery {
              id: battery
            }
            Separator {
              visible: battery.visible
            }
            Clock {}
            Separator {}
            Power {}
          }
        }
      }
    }
  }
}
