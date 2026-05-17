import QtQuick
import "../components"
import ".."

Item {
    id: root
    property string label: ""
    property string glyph: ""
    property bool destructive: false

    signal activated()

    height: 36

    Rectangle {
        anchors.fill: parent
        radius: Config.rMd
        color: hover.containsMouse ? Config.powerHover : "transparent"
        Behavior on color { ColorAnimation { duration: Config.easeFast } }
    }

    Row {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        spacing: 12
        Item {
            width: 14; height: 14
            anchors.verticalCenter: parent.verticalCenter
            Icons {
                anchors.fill: parent
                glyph: root.glyph
                color: root.destructive ? Config.destructive : Qt.rgba(1, 1, 1, 0.85)
            }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            color: root.destructive ? Config.destructive : Config.onDark
            font.family: Config.fontText
            font.pixelSize: 15
            font.letterSpacing: -0.374
        }
    }

    MouseArea {
        id: hover
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.activated()
    }

    scale: hover.pressed ? 0.98 : 1
    Behavior on scale { NumberAnimation { duration: Config.easeFast } }
}
