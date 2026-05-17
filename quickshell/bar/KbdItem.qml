import QtQuick
import "../components"
import "../services"
import ".."

TbItem {
    id: root
    readonly property string code: KeyboardService.shortCode || "??"

    shortForm: Component {
        Text {
            text: root.code
            color: Config.onDark
            font.family: Config.fontText
            font.pixelSize: 15
            font.weight: Font.Normal
            font.letterSpacing: -0.224
        }
    }
    longForm: Component {
        Text {
            text: root.code
            color: Config.onDark
            font.family: Config.fontText
            font.pixelSize: 15
            font.weight: Font.Normal
            font.letterSpacing: -0.224
        }
    }
}
