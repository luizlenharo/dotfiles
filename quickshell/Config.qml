pragma Singleton

import QtQuick

QtObject {
    readonly property color primary: "#0066cc"
    readonly property color primaryOnDark: "#2997ff"
    readonly property color ink: "#1d1d1f"
    readonly property color onDark: "#ffffff"
    readonly property color bodyMuted: "#cccccc"
    readonly property color destructive: Qt.rgba(255/255, 69/255, 58/255, 0.95)

    readonly property color glassFill: Qt.rgba(28/255, 28/255, 30/255, 0.72)
    readonly property color hairline: Qt.rgba(1, 1, 1, 0.08)
    readonly property color hairlineStrong: Qt.rgba(1, 1, 1, 0.14)
    readonly property color scrim: Qt.rgba(0, 0, 0, 0.18)

    readonly property color tbItemHover: Qt.rgba(1, 1, 1, 0.06)
    readonly property color wsHasApps: Qt.rgba(1, 1, 1, 0.06)
    readonly property color wsActive: Qt.rgba(1, 1, 1, 0.16)
    readonly property color rowSelected: Qt.rgba(0, 102/255, 204/255, 0.22)
    readonly property color powerHover: Qt.rgba(1, 1, 1, 0.08)

    readonly property real rSm: 8
    readonly property real rMd: 11
    readonly property real rLg: 18
    readonly property real rPill: 9999

    readonly property int easeFast: 160
    readonly property int easeMed: 200
    readonly property int easeSlow: 280
    readonly property var easeCurve: [0.32, 0.72, 0, 1, 1, 1]

    readonly property string fontDisplay: "Inter Display, Inter, SF Pro Display, system-ui, sans-serif"
    readonly property string fontText: "Inter, SF Pro Text, system-ui, sans-serif"
    readonly property string fontMono: "JetBrainsMono Nerd Font, monospace"
}
