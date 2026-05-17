import QtQuick
import Quickshell
import Quickshell.Wayland
import ".."

// Full-screen layer-shell overlay that hosts a glass card positioned under
// an anchor item. Uses its own wlr-layer namespace ("quickshell:popover")
// so Hyprland can blur it independently from the bar.
PanelWindow {
    id: root

    default property alias popContent: contentArea.data

    property Item anchorItem: null
    property int popoverWidth: 320
    property int popoverHeight: 360
    property int topGap: 14
    property string anchorMode: "center" // "center" | "right"
    property bool open: false

    property int posX: 0
    property int posY: 0

    visible: open || surface.opacity > 0.01
    color: "transparent"

    anchors { top: true; left: true; right: true; bottom: true }
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    aboveWindows: true

    WlrLayershell.namespace: "quickshell:popover"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    function reposition() {
        if (!anchorItem) return;
        const g = anchorItem.mapToGlobal(0, 0);
        if (!g) return;
        const sx = root.screen ? root.screen.x : 0;
        const sy = root.screen ? root.screen.y : 0;
        const ax = g.x - sx;
        const ay = g.y - sy;
        posY = Math.round(ay + anchorItem.height + topGap);
        if (anchorMode === "right") {
            posX = Math.round(ax + anchorItem.width - popoverWidth);
        } else {
            posX = Math.round(ax + anchorItem.width / 2 - popoverWidth / 2);
        }
        const sw = root.screen ? root.screen.width : 1920;
        if (posX < 12) posX = 12;
        if (posX + popoverWidth > sw - 12) posX = sw - popoverWidth - 12;
    }

    onOpenChanged: if (open) reposition()
    onAnchorItemChanged: if (open) reposition()

    MouseArea {
        anchors.fill: parent
        enabled: root.open
        onClicked: root.open = false
    }

    GlassSurface {
        id: surface
        x: root.posX
        y: root.posY
        width: root.popoverWidth
        height: root.popoverHeight
        radius: Config.rLg
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.98
        transformOrigin: Item.Top
        Behavior on opacity { NumberAnimation { duration: Config.easeMed } }
        Behavior on scale { NumberAnimation { duration: Config.easeSlow } }

        Item {
            id: contentArea
            anchors.fill: parent
            // children injected here via default alias
        }
    }
}
