import QtQuick
import Quickshell
import "../components"
import ".."

TbItem {
    id: root
    clickable: true

    readonly property var _clk: SystemClock { precision: SystemClock.Minutes }
    readonly property string _short: Qt.formatDateTime(_clk.date, "HH:mm")
    readonly property string _long: Qt.formatDateTime(_clk.date, "ddd, dd MMM · HH:mm")

    shortForm: Component {
        Text {
            text: root._short
            color: Config.onDark
            font.family: Config.fontText
            font.pixelSize: 15
            font.weight: Font.Normal
            font.letterSpacing: -0.224
        }
    }

    longForm: Component {
        Text {
            text: root._long
            color: Config.onDark
            font.family: Config.fontText
            font.pixelSize: 15
            font.weight: Font.Normal
            font.letterSpacing: -0.224
        }
    }
}
