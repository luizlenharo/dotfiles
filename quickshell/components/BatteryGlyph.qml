import QtQuick
import ".."

// iOS-style battery: rounded body + terminal nub + inner level fill.
// The fill width tracks `pct`; it turns red when low (and not charging),
// and a bolt overlays the body while charging.
Item {
    id: root

    property int pct: 0
    property bool charging: false
    property color color: Config.onDark
    property color lowColor: Config.destructive
    property color chargingColor: Config.positive

    implicitWidth: 27
    implicitHeight: 13

    // Body outline. A rounded Rectangle is the cleanest way to draw the
    // rounded-rect body and scale the inner fill; the glyph-Shapes convention
    // is for path icons, not a box that needs a width-scaled child.
    Rectangle {
        id: body
        width: parent.width - 3   // leave room for the terminal nub
        height: parent.height
        radius: 4
        color: "transparent"
        border.color: root.color
        border.width: 1.5
        opacity: 0.9
    }

    // Terminal nub on the right.
    Rectangle {
        anchors.left: body.right
        anchors.leftMargin: 1
        anchors.verticalCenter: body.verticalCenter
        width: 2
        height: parent.height * 0.42
        radius: 1
        color: root.color
        opacity: 0.9
    }

    // Level fill, inset inside the body.
    Rectangle {
        readonly property real inset: 2.5
        x: body.x + inset
        y: body.y + inset
        height: body.height - inset * 2
        width: Math.max(2, (body.width - inset * 2)
                           * Math.max(0, Math.min(100, root.pct)) / 100)
        radius: 1.5
        // color: (root.pct <= 20 && !root.charging) ? root.lowColor : root.color
        color: root.charging ? root.chargingColor : (root.pct <= 20 ? root.lowColor : root.color)
    }

    // Charging bolt, dark so it reads against the light fill.
    Icons {
        visible: root.charging
        anchors.centerIn: body
        width: 11
        height: 11
        glyph: "bolt"
        color: Config.onDark
    }
}
