import QtQuick
import Quickshell.Services.UPower
import "../components"
import ".."

TbItem {
    id: root
    readonly property var dev: UPower.displayDevice
    readonly property bool ready: dev !== null && dev !== undefined && dev.isLaptopBattery
    readonly property int pct: ready ? Math.round(dev.percentage * 100) : 0
    readonly property bool charging: ready && (dev.state === UPowerDeviceState.Charging
        || dev.state === UPowerDeviceState.PendingCharge
        || dev.state === UPowerDeviceState.FullyCharged)
    readonly property string mode: {
        const p = PowerProfiles.profile;
        if (p === PowerProfile.PowerSaver)   return "Eco";
        if (p === PowerProfile.Performance)  return "Power";
        if (p === PowerProfile.Balanced)     return "Normal";
        return "";
    }

    shortForm: Component {
        Item {
            implicitWidth: 27
            implicitHeight: 25
            BatteryGlyph {
                anchors.centerIn: parent
                pct: root.pct
                charging: root.charging
            }
        }
    }
    longForm: Component {
        Row {
            spacing: 8
            Item {
                width: 27; height: 25
                anchors.verticalCenter: parent.verticalCenter
                BatteryGlyph {
                    anchors.centerIn: parent
                    pct: root.pct
                    charging: root.charging
                }
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
