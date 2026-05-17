import QtQuick
import Quickshell.Services.UPower
import "../components"
import ".."

TbItem {
    id: root
    readonly property var dev: UPower.displayDevice
    readonly property bool ready: dev !== null && dev !== undefined && dev.isLaptopBattery
    readonly property int pct: ready ? Math.round(dev.percentage * 100) : 0
    readonly property string mode: {
        const p = PowerProfiles.profile;
        if (p === PowerProfile.PowerSaver)   return "Eco";
        if (p === PowerProfile.Performance)  return "Power";
        if (p === PowerProfile.Balanced)     return "Normal";
        return "";
    }

    shortForm: Component {
        Item {
            implicitWidth: 22
            implicitHeight: 25
            Icons {
                anchors.fill: parent
                glyph: "battery"
                color: Config.onDark
            }
            // fill bar inside the battery rect
            // Rectangle {
            //     x: 2
            //     y: 4
            //     width: Math.max(2, (parent.width - 5) * Math.max(0, root.pct) / 100)
            //     height: parent.height - 4
            //     color: Config.onDark
            //     radius: 1
            // }
        }
    }
    longForm: Component {
        Row {
            spacing: 8
            Item {
                width: 22; height: 25
                anchors.verticalCenter: parent.verticalCenter
                Icons { anchors.fill: parent; glyph: "battery"; color: Config.onDark }
                // Rectangle {
                //     x: 2; y: 4
                //     width: Math.max(2, (parent.width - 5) * Math.max(0, root.pct) / 100)
                //     height: parent.height - 4
                //     color: Config.onDark; radius: 1
                // }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: root.ready ? (root.pct + "% · " + root.mode) : "—"
                color: Config.onDark
                font.family: Config.fontText
                font.pixelSize: 15
                font.letterSpacing: -0.224
            }
        }
    }
}
