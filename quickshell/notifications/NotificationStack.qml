import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../components"
import ".."

PanelWindow {
    id: root
    color: "transparent"
    visible: visibleNotifs.length > 0

    // List of currently-displayed Notification objects (most recent first)
    property var visibleNotifs: []

    function _push(n) {
        const arr = visibleNotifs.slice();
        arr.unshift(n);
        if (arr.length > 5) {
            const dropped = arr.pop();
            if (dropped) dropped.tracked = false;
        }
        visibleNotifs = arr;
        const ms = n.expireTimeout > 0 ? n.expireTimeout : 5000;
        const t = Qt.createQmlObject(
            'import QtQuick; Timer { interval: ' + ms + '; repeat: false; running: true }',
            root);
        t.triggered.connect(() => { _remove(n); t.destroy(); });
    }

    function _remove(n) {
        const arr = visibleNotifs.slice();
        const i = arr.indexOf(n);
        if (i >= 0) {
            arr.splice(i, 1);
            visibleNotifs = arr;
        }
        if (n) n.tracked = false;
    }

    anchors { top: true; right: true }
    margins.top: 70
    margins.right: 24
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    aboveWindows: true
    implicitWidth: 360
    implicitHeight: Math.min(800, Math.max(0, visibleNotifs.length * 104 + 24))

    WlrLayershell.namespace: "quickshell:notification"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    NotificationServer {
        id: server
        keepOnReload: true
        bodySupported: true
        bodyMarkupSupported: true
        actionsSupported: true
        imageSupported: true
        onNotification: function(n) {
            n.tracked = true;
            root._push(n);
        }
    }

    Column {
        anchors.fill: parent
        spacing: 12

        Repeater {
            model: root.visibleNotifs
            delegate: NotificationCard {
                required property var modelData
                width: 360
                source: modelData
                onDismiss: root._remove(modelData)
            }
        }
    }
}
