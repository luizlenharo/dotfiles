import QtQuick
import Quickshell
import Quickshell.Io
import "../components"
import ".."

Popover {
    id: root
    popoverWidth: 240
    popoverHeight: 8 + 108 + 13 + 72 + 8   // padding + 3 items + divider + 2 items 
    anchorMode: "top"
    topGap: -38

    function _exec(cmd) {
        // Spawn detached: Process gets garbage-collected when running goes false.
        const p = procComp.createObject(root, { command: cmd });
        p.running = true;
        root.open = false;
    }

    Component {
        id: procComp
        Process { onExited: this.destroy() }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8

        PowerItem {
            width: parent.width
            label: "Lock"
            glyph: "lock"
            onActivated: root._exec(["loginctl", "lock-session"])
        }
        PowerItem {
            width: parent.width
            label: "Sleep"
            glyph: "sleep"
            onActivated: root._exec(["systemctl", "suspend"])
        }
        PowerItem {
            width: parent.width
            label: "Restart"
            glyph: "restart"
            onActivated: root._exec(["systemctl", "reboot"])
        }

        Item {
            width: parent.width
            height: 13
            Rectangle {
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 8
                anchors.rightMargin: 8
                anchors.verticalCenter: parent.verticalCenter
                height: 1
                color: Config.hairline
            }
        }

        PowerItem {
            width: parent.width
            label: "Log Out"
            glyph: "logOut"
            onActivated: root._exec(["hyprctl", "dispatch", "exit"])
        }
        PowerItem {
            width: parent.width
            label: "Shut Down"
            glyph: "power"
            destructive: true
            onActivated: root._exec(["systemctl", "poweroff"])
        }
    }
}
