pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

// both ipc and global shortcuts abstraction from the same definition
//
// for hyprland keybinds bounded by `hl.dsp.global(...)`:
// - `quickshell:<target>-<command>`
// - `quickshell:<target>-<command>-<arg>` for each allowed argument
//
// for ipc:
// - qs -c mandra ipc call <target> run <command>
// - qs -c mandra ipc call <target> runWith <command> <arg>
// - qs -c mandra ipc call <target> help
//
Scope {
  id: root

  required property string target
  property list<var> commands: []

  readonly property list<var> shortcuts: {
    const list = [];
    for (const c of commands) {
      if (c.shortcut === false)
        continue;
      for (const arg of c.args ?? [""])
        list.push({
          command: c,
          arg: arg,
          name: arg === "" ? `${target}-${c.name}` : `${target}-${c.name}-${arg}`
        });
    }
    return list;
  }

  // returns an error message, or "" when the command ran
  function run(name: string, arg: string): string {
    const command = commands.find(c => c.name === name);
    if (!command)
      return `unknown command "${name}", see \`help\``;
    if (command.args && !command.args.includes(arg))
      return `"${name}" takes one of: ${command.args.join(", ")}`;
    command.run(arg);
    return "";
  }

  IpcHandler {
    target: root.target

    function run(command: string): string {
      return root.run(command, "");
    }

    function runWith(command: string, arg: string): string {
      return root.run(command, arg);
    }

    function help(): string {
      return root.commands.map(c => {
        const args = c.args ? ` <${c.args.join("|")}>` : "";
        return `${c.name}${args}  ${c.description ?? ""}`;
      }).join("\n");
    }
  }

  Instantiator {
    model: root.shortcuts

    delegate: GlobalShortcut {
      required property var modelData

      name: modelData.name
      description: modelData.command.description ?? ""
      onPressed: modelData.command.run(modelData.arg)
    }
  }
}
