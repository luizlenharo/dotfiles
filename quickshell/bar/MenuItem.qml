import QtQuick
import "../components"
import ".."

TbItem {
    id: root
    clickable: true

    shortForm: Component {
        Item {
            implicitWidth: 17
            implicitHeight: 17
            Icons { anchors.fill: parent; glyph: "power"; color: Config.onDark }
        }
    }
    longForm: Component {
        Item {
            implicitWidth: 17
            implicitHeight: 17
            Icons { anchors.fill: parent; glyph: "power"; color: Config.onDark }
        }
    }
}
