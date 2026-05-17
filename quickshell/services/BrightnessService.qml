pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property int percent: 0

    function refresh() { _refreshProc.running = true }

    property Process _refreshProc: Process {
        command: ["sh", "-c", "p=$(brightnessctl get 2>/dev/null) m=$(brightnessctl max 2>/dev/null); [ -z \"$p\" ] || echo $((100*p/m))"]
        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseInt(text.trim(), 10);
                if (!isNaN(v)) root.percent = v;
            }
        }
    }

    // Poll every 600ms while idle. The XF86MonBrightness keys are bound in
    // Hyprland and brightnessctl writes to sysfs synchronously, so a short
    // poll catches changes within one tick of releasing the key.
    property Timer _poll: Timer {
        interval: 600
        repeat: true
        running: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
