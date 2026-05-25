import QtQuick
import Quickshell
import Quickshell.Io
import "bar"
import "popovers"
import "osd"
import "launcher"
import "lock"
import "notifications"

ShellRoot {
    id: shell

    // Global, single-instance surfaces. The launcher and notification stack
    // are scoped to the focused monitor by Hyprland itself when they map.
    Launcher  { id: launcher }
    NotificationStack { id: notifs }
    Osd { id: osd }
    CalendarPopover { id: calPop }
    PowerPopover { id: powerPop }
    Lock { id: lock }

    // Bars across all monitors share this expansion state.
    property bool barExpanded: true

    // Per-monitor bar
    Variants {
        model: Quickshell.screens
        delegate: Component {
            TopBar {
                required property var modelData
                screen: modelData
                barExpanded: shell.barExpanded
                onTimeClicked: {
                    powerPop.open = false;
                    calPop.anchorItem = timeAnchor;
                    calPop.screen = modelData;
                    calPop.open = !calPop.open;
                }
                onMenuClicked: {
                    calPop.open = false;
                    powerPop.anchorItem = menuAnchor;
                    powerPop.screen = modelData;
                    powerPop.open = !powerPop.open;
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function open()   { launcher.show() }
        function close()  { launcher.hide() }
        function toggle() { launcher.open ? launcher.hide() : launcher.show() }
    }

    IpcHandler {
        target: "bar"
        function expand()   { shell.barExpanded = true }
        function collapse() { shell.barExpanded = false }
        function toggle()   { shell.barExpanded = !shell.barExpanded }
    }
}
