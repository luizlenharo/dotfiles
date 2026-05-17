import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"
import "../services"
import ".."

PanelWindow {
    id: root
    color: "transparent"
    visible: card.opacity > 0.01

    anchors { left: true; right: true; bottom: true }
    margins.bottom: 80
    exclusiveZone: 0
    exclusionMode: ExclusionMode.Ignore
    focusable: false
    aboveWindows: true
    implicitHeight: 96

    WlrLayershell.namespace: "quickshell:osd"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    GlassSurface {
        id: card
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        radius: Config.rPill
        implicitWidth: 280
        implicitHeight: 38
        opacity: OsdService.show ? 1 : 0
        anchors.bottomMargin: OsdService.show ? 0 : -8
        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on anchors.bottomMargin { NumberAnimation { duration: Config.easeSlow; easing.type: Easing.OutCubic } }

        Row {
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            spacing: 14

            Icons {
                anchors.verticalCenter: parent.verticalCenter
                width: 18; height: 18
                glyph: OsdService.kind === "bri" ? "sun"
                       : (AudioService.muted ? "speakerMute" : "speaker")
                color: Config.onDark
            }

            Item {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width - 18 - 14 - 18 - 14 - 36
                height: 3
                Rectangle {
                    anchors.fill: parent
                    radius: Config.rPill
                    color: Qt.rgba(1, 1, 1, 0.18)
                }
                Rectangle {
                    height: parent.height
                    width: parent.width * Math.max(0, Math.min(100, OsdService.level)) / 100
                    radius: Config.rPill
                    color: Config.onDark
                    Behavior on width { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                }
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: OsdService.level + "%"
                color: Qt.rgba(1, 1, 1, 0.85)
                font.family: Config.fontText
                font.pixelSize: 12
                font.features: { "tnum": 1 }
                horizontalAlignment: Text.AlignRight
                width: 36
            }
        }
    }
}
