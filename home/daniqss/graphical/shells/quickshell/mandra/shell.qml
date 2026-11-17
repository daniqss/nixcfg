//@ pragma UseQApplication
//@ pragma IconTheme MoreWaita
//@ pragma DataDir $BASE/quickshell/mandra

import Quickshell
import QtQuick
import qs.widgets.bar
import qs.widgets
import qs.widgets.menu

ShellRoot {
  Bar {}
  Osd {}
  Notifications {}
  Menu {}
}
