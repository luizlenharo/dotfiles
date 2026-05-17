import QtQuick
import Quickshell
import Quickshell.Widgets
import "../components"
import ".."

Item {
    id: root

    property var source: null   // qs::Notification
    signal dismiss()

    height: 92
    opacity: 0
    x: 24

    Component.onCompleted: {
        x = 0;
        opacity = 1;
    }
    Behavior on opacity { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
    Behavior on x { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }

    GlassSurface {
        anchors.fill: parent
        radius: Config.rLg

        Column {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 4

            // Head: app icon + name + time
            Row {
                width: parent.width
                spacing: 8

                Rectangle {
                    width: 22; height: 22
                    radius: 6
                    color: Qt.rgba(1, 1, 1, 0.10)
                    IconImage {
                        anchors.fill: parent
                        anchors.margins: 4
                        source: root.source ? "image://icon/" + (root.source.appIcon || "") : ""
                    }
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.source ? (root.source.appName || "") : ""
                    color: Config.onDark
                    font.family: Config.fontText
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    font.letterSpacing: -0.374
                    width: parent.width - 22 - 8 - 40
                    elide: Text.ElideRight
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "now"
                    color: Qt.rgba(1, 1, 1, 0.55)
                    font.family: Config.fontText
                    font.pixelSize: 12
                    font.letterSpacing: -0.12
                }
            }

            // Title
            Text {
                width: parent.width
                text: root.source ? (root.source.summary || "") : ""
                color: Config.onDark
                font.family: Config.fontText
                font.pixelSize: 15
                font.weight: Font.DemiBold
                font.letterSpacing: -0.374
                elide: Text.ElideRight
            }

            // Body
            Text {
                width: parent.width
                text: root.source ? (root.source.body || "") : ""
                color: Qt.rgba(1, 1, 1, 0.78)
                font.family: Config.fontText
                font.pixelSize: 14
                font.letterSpacing: -0.224
                lineHeight: 1.4
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                textFormat: Text.PlainText
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.dismiss()
    }
}
