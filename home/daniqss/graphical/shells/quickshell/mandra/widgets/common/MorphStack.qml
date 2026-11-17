import QtQuick

import qs.config

Item {
  id: root

  property int currentIndex: 0
  property int duration: Sizes.morph.duration
  // fraction of the morph each page spends fading
  property real fade: Sizes.morph.fade
  property size defaultPageSize: Qt.size(0, 0)

  // room between the stack edge and the pages, per side
  property real padding: Sizes.popup.padding
  property real topInset: padding
  property real bottomInset: padding
  property real leftInset: padding
  property real rightInset: padding

  default property alias background: backgroundHolder.data
  property alias pages: pageHolder.data

  // the page morphed from and to; equal once nothing is switching. plain values
  // set from onCurrentIndexChanged, a binding would update them before it runs
  property int fromIndex: 0
  property int toIndex: 0
  property real progress: 1
  readonly property bool morphing: anim.running

  readonly property real fadeOut: Math.max(0, 1 - progress / fade)
  readonly property real fadeIn: Math.max(0, (progress - (1 - fade)) / fade)

  function contentSize(index: int): size {
    const page = pageHolder.children[index];
    const w = page?.implicitWidth || defaultPageSize.width;
    const h = page?.implicitHeight || defaultPageSize.height;
    return Qt.size(w, h);
  }

  // stack size (page plus insets) for a page
  function pageSize(index: int): size {
    const content = contentSize(index);
    return Qt.size(content.width + leftInset + rightInset, content.height + topInset + bottomInset);
  }

  function opacityOf(index: int): real {
    if (index === toIndex)
      return fromIndex === toIndex ? 1 : fadeIn;
    return index === fromIndex ? fadeOut : 0;
  }

  // reading `progress` ties the size to the animation, the sizes to the pages
  readonly property size fromSize: pageSize(fromIndex)
  readonly property size toSize: pageSize(toIndex)

  implicitWidth: fromSize.width + (toSize.width - fromSize.width) * progress
  implicitHeight: fromSize.height + (toSize.height - fromSize.height) * progress

  onCurrentIndexChanged: {
    if (currentIndex === toIndex)
      return;
    // switching again mid morph starts from whatever is on screen right now
    fromIndex = progress < 0.5 && fromIndex !== toIndex ? fromIndex : toIndex;
    toIndex = currentIndex;
    anim.restart();
  }

  Component.onCompleted: {
    fromIndex = currentIndex;
    toIndex = currentIndex;
  }

  // jumps to the end of a running morph, for switches nobody was there to see
  function finish(): void {
    anim.complete();
  }

  NumberAnimation {
    id: anim
    target: root
    property: "progress"
    from: 0
    to: 1
    duration: root.duration
    easing.type: Easing.InOutCubic
    onFinished: root.fromIndex = root.toIndex
  }

  Item {
    id: backgroundHolder
    anchors.fill: parent
  }

  Item {
    id: pageHolder
    anchors {
      fill: parent
      topMargin: root.topInset
      bottomMargin: root.bottomInset
      leftMargin: root.leftInset
      rightMargin: root.rightInset
    }
    clip: root.morphing

    // each page keeps its own size and stays centered while the stack morphs
    Component.onCompleted: {
      for (let i = 0; i < children.length; i++) {
        const page = children[i];
        const index = i;
        page.width = Qt.binding(() => root.contentSize(index).width);
        page.height = Qt.binding(() => root.contentSize(index).height);
        page.x = Qt.binding(() => Math.round((pageHolder.width - page.width) / 2));
        page.y = Qt.binding(() => Math.round((pageHolder.height - page.height) / 2));
        page.opacity = Qt.binding(() => root.opacityOf(index));
        // the target page stays visible while still transparent so it can take focus
        page.visible = Qt.binding(() => index === root.toIndex || page.opacity > 0);
      }
    }
  }
}
