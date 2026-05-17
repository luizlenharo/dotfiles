pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: root

    property string ssid: ""
    property int signal_: 0  // 0..100; underscore avoids Signal-keyword shadow
    property bool connected: false

    function refresh() { _proc.running = true }

    property Process _proc: Process {
        command: ["nmcli", "-t", "-f", "ACTIVE,SSID,SIGNAL", "device", "wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.split("\n");
                let active = null;
                for (let i = 0; i < lines.length; i++) {
                    const parts = lines[i].split(":");
                    if (parts[0] === "yes") { active = parts; break; }
                }
                if (active) {
                    root.ssid = active[1] || "Wi-Fi";
                    root.signal_ = parseInt(active[2] || "0", 10) || 0;
                    root.connected = true;
                } else {
                    root.connected = false;
                    root.ssid = "Off";
                    root.signal_ = 0;
                }
            }
        }
    }

    property Timer _poll: Timer {
        interval: 5000
        repeat: true
        running: true
        onTriggered: root.refresh()
    }

    Component.onCompleted: refresh()
}
