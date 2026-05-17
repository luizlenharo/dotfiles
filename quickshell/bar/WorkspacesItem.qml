import QtQuick
import Quickshell
import Quickshell.Hyprland
import ".."

// 5 workspace pills (1..5). When the parent topbar is expanded, pills with
// running clients widen and show app icons in place of the number.
Row {
    id: root
    spacing: 4
    leftPadding: 4
    rightPadding: 4

    property bool topbarExpanded: false
    readonly property int activeId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 0

    Repeater {
        model: 5
        delegate: Item {
            id: ws
            required property int index
            readonly property int wsId: index + 1
            readonly property bool isActive: wsId === root.activeId
            readonly property var clients: {
                const list = Hyprland.toplevels ? Hyprland.toplevels.values : [];
                const out = [];
                for (let i = 0; i < list.length; i++) {
                    const t = list[i];
                    if (t && t.workspace && t.workspace.id === wsId) out.push(t);
                }
                return out;
            }
            readonly property bool hasApps: clients.length > 0

            implicitHeight: 26
            implicitWidth: pill.implicitWidth
            Behavior on implicitWidth { NumberAnimation { duration: 0; easing.type: Easing.OutCubic } }

            Rectangle {
                id: pill
                anchors.centerIn: parent
                height: 26
                radius: Config.rPill
                implicitWidth: Math.max(26, row.implicitWidth + 14)
                color: ws.isActive ? Config.wsActive
                     : ws.hasApps  ? Config.wsHasApps
                     : "transparent"
                Behavior on color { ColorAnimation { duration: Config.easeMed } }
                Behavior on implicitWidth { NumberAnimation { duration: 0; easing.type: Easing.OutCubic } }

                Row {
                    id: row
                    anchors.centerIn: parent
                    spacing: 5

                    // The number; hidden once expanded + has apps
                    Text {
                        text: ws.wsId
                        color: ws.isActive ? Config.onDark
                             : ws.hasApps  ? Qt.rgba(1,1,1,0.78)
                             :               Qt.rgba(1,1,1,0.42)
                        font.family: Config.fontText
                        font.pixelSize: 15
                        font.weight: Font.DemiBold
                        font.letterSpacing: -0.1
                        font.features: { "tnum": 1 }
                        visible: !(root.topbarExpanded && ws.hasApps)
                    }

                    // App icons; only visible when expanded + has apps
                    Repeater {
                        model: (root.topbarExpanded && ws.hasApps) ? ws.clients : []
                        delegate: Image {
                            required property var modelData
                            width: 16
                            height: 16
                            sourceSize.width: 32
                            sourceSize.height: 32
                            source: root._iconFor(modelData)
                            fillMode: Image.PreserveAspectFit
                            opacity: 0.92
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch("workspace " + ws.wsId)
            }
        }
    }

    function _iconFor(toplevel) {
        if (!toplevel) return "";
        const cls = (toplevel.wayland && toplevel.wayland.appId) || "";
        if (!cls) return "";
        const e = DesktopEntries.heuristicLookup(cls);
        if (e && e.icon) return "image://icon/" + e.icon;
        return "image://icon/" + cls.toLowerCase();
    }
}
