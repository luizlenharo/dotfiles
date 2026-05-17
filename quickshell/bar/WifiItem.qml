import QtQuick
import "../components"
import "../services"
import ".."

TbItem {
    id: root
    readonly property string ssid: WifiService.connected ? WifiService.ssid : "Off"

    shortForm: Component {
        Item {
            implicitWidth: 17
            implicitHeight: 20
            Icons {
                anchors.fill: parent
                glyph: "wifi"
                color: Config.onDark
                opacity: WifiService.connected ? 1 : 0.5
            }
        }
    }
    longForm: Component {
        Row {
            spacing: 8
            Icons {
                width: 17; height: 17
                anchors.verticalCenter: parent.verticalCenter
                glyph: "wifi"
                color: Config.onDark
                opacity: WifiService.connected ? 1 : 0.5
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.ssid
                color: Config.onDark
                font.family: Config.fontText
                font.pixelSize: 15
                font.letterSpacing: -0.224
            }
        }
    }
}
