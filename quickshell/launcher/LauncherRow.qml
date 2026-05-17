import QtQuick
import Quickshell
import Quickshell.Widgets
import "../components"
import "../services"
import ".."

Item {
    id: root

    property var entry: null
    property bool selected: false

    signal activated()

    Rectangle {
        anchors.fill: parent
        radius: Config.rSm
        color: root.selected ? Config.rowSelected
              : hover.containsMouse ? Qt.rgba(1, 1, 1, 0.04) : "transparent"
        Behavior on color { ColorAnimation { duration: Config.easeFast } }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 14
        anchors.rightMargin: 14
        spacing: 14

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 32; height: 32
            radius: 7
            color: Qt.rgba(1, 1, 1, 0.06)
            IconImage {
                anchors.fill: parent
                anchors.margins: 6
                source: root.entry ? "image://icon/" + (root.entry.icon || "") : ""
                asynchronous: true
            }
        }

        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 2
            Text {
                text: root.entry ? (root.entry.name || "") : ""
                color: Config.onDark
                font.family: Config.fontText
                font.pixelSize: 17
                font.weight: Font.DemiBold
                font.letterSpacing: -0.374
            }
            Text {
                text: AppsService.metaFor(root.entry)
                color: Qt.rgba(1, 1, 1, 0.55)
                font.family: Config.fontText
                font.pixelSize: 14
                font.letterSpacing: -0.224
                elide: Text.ElideRight
                width: root.width - 14 - 32 - 14 - 14
            }
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }
}
