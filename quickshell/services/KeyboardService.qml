pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

QtObject {
    id: root

    property string layout: ""        // human readable, e.g. "Portuguese (Brazil)"
    property string shortCode: ""     // 2-char code, e.g. "BR"

    function refresh() { _refreshProc.running = true }

    property Process _refreshProc: Process {
        command: ["sh", "-c",
            "hyprctl -j devices 2>/dev/null | " +
            "jq -r '.keyboards | map(select(.main)) | .[0].active_keymap // empty' 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text.trim();
                if (!t) return;
                root.layout = t;
                root.shortCode = root._shortFromLayout(t);
            }
        }
    }

    // Convert "Portuguese (Brazil)" → "BR", "English (US)" → "US",
    // fallback to first 2 chars uppercased.
    function _shortFromLayout(name) {
        const m = /\(([^)]+)\)/.exec(name);
        if (m) {
            const inner = m[1].trim();
            const last = inner.split(/\s+/).pop();
            if (/^[A-Za-z]+$/.test(last)) return last.slice(0, 2).toUpperCase();
        }
        return name.slice(0, 2).toUpperCase();
    }

    property Connections _hypr: Connections {
        target: Hyprland
        function onRawEvent(event) {
            if (event.name === "activelayout") root.refresh();
        }
    }

    Component.onCompleted: refresh()
}
