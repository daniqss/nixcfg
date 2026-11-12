//@ pragma UseQApplication
//@ pragma IconTheme MoreWaita
//@ pragma DataDir $BASE/quickshell/mandra

import Quickshell
import QtQuick
import qs.widgets.bar
import qs.widgets

ShellRoot {
  Bar {}
  Osd {}
  Notifications {}
}
