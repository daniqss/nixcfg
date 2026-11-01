import QtQuick
import QtQuick.Effects

Item {
  id: root

  property alias text: label.text
  property alias font: label.font
  property alias color: label.color
  property bool gradientEnabled: true

  implicitWidth: label.implicitWidth
  implicitHeight: label.implicitHeight

  Text {
    id: label

    // rounded so the glyph lands on the same pixel whatever width the parent gives us
    x: Math.round((root.width - width) / 2)
    y: Math.round((root.height - height) / 2)
    visible: !root.gradientEnabled
    layer.enabled: true
  }

  Rectangle {
    anchors.fill: label
    visible: root.gradientEnabled
    gradient: AccentGradient {}
    layer.enabled: true
    layer.effect: MultiEffect {
      maskEnabled: true
      maskSource: label
      maskThresholdMin: 0.5
      maskSpreadAtMin: 1.0
    }
  }
}
