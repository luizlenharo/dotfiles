import QtQuick
import ".."

// A bar item with a "short" form (compact) and "long" form (label visible).
// Hover swaps to long; when parentExpanded is true, all items show long form
// and per-item hover is suppressed (matches HTML lines 882–888).
Item {
    id: root

    property bool parentExpanded: false
    property bool clickable: false
    property alias hovered: hover.containsMouse
    // Per-item hover expansion disabled — only the global bar-expand toggles long form.
    // To restore: change the line below back to `hovered && !parentExpanded`.
    property bool itemExpanded: false /* hovered && !parentExpanded */
    readonly property bool showLong: parentExpanded || itemExpanded

    default property alias _data: container.data
    property Component shortForm: null
    property Component longForm: null

    signal clicked()

    implicitHeight: 34
    implicitWidth: stack.implicitWidth + 20

    Rectangle {
        id: bg
        anchors.fill: parent
        radius: Config.rPill
        color: root.itemExpanded ? Config.tbItemHover : "transparent"
        Behavior on color { ColorAnimation { duration: Config.easeMed } }
    }

    Item {
        id: stack
        anchors.centerIn: parent
        implicitWidth: root.showLong
            ? (longLoader.item ? longLoader.item.implicitWidth : 0)
            : (shortLoader.item ? shortLoader.item.implicitWidth : 0)
        implicitHeight: 34
        Behavior on implicitWidth { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }

        Loader {
            id: shortLoader
            anchors.centerIn: parent
            sourceComponent: root.shortForm
            opacity: root.showLong ? 0 : 1
            scale: root.showLong ? 0.96 : 1
            Behavior on opacity { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }
        }

        Loader {
            id: longLoader
            anchors.centerIn: parent
            sourceComponent: root.longForm
            opacity: root.showLong ? 1 : 0
            scale: root.showLong ? 1 : 0.96
            Behavior on opacity { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }
            Behavior on scale { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: root.clickable ? Qt.LeftButton : Qt.NoButton
        onClicked: root.clicked()
    }

    Item { id: container; anchors.fill: parent; visible: false }
}
