import QtQuick
import "../components"
import "../services"
import ".."

TbItem {
    id: root
    readonly property bool muted: AudioService.muted || AudioService.volume <= 0.001
    readonly property string sinkName: AudioService.sinkName

    shortForm: Component {
        Item {
            implicitWidth: 17
            implicitHeight: 17
            Icons {
                anchors.fill: parent
                glyph: root.muted ? "speakerMute" : "speaker"
                color: Config.onDark
            }
        }
    }
    longForm: Component {
        Row {
            spacing: 8
            Icons {
                width: 17; height: 17
                anchors.verticalCenter: parent.verticalCenter
                glyph: root.muted ? "speakerMute" : "speaker"
                color: Config.onDark
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.sinkName
                color: Config.onDark
                font.family: Config.fontText
                font.pixelSize: 15
                font.letterSpacing: -0.224
            }
        }
    }
}
