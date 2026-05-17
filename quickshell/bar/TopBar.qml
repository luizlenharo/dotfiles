import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"
import ".."

PanelWindow {
    id: root

    property bool barExpanded: false
    property alias timeAnchor: tbTime
    property alias menuAnchor: tbMenu

    signal menuClicked()
    signal timeClicked()

    color: "transparent"
    anchors { top: true; left: true; right: true }
    margins.top: 14
    exclusiveZone: 56    // pill (42px) + 14px top margin
    focusable: false
    aboveWindows: false

    WlrLayershell.namespace: "quickshell:bar"
    WlrLayershell.layer: WlrLayer.Top

    implicitHeight: 56

    Item {
        id: barRow
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: 42
        width: pill.width

        GlassSurface {
            id: pill
            anchors.centerIn: parent
            radius: Config.rPill
            implicitWidth: barLayout.implicitWidth + 24
            implicitHeight: 42

            Row {
                id: barLayout
                anchors.centerIn: parent
                spacing: 4
                height: 34

                TimeItem {
                    id: tbTime
                    anchors.verticalCenter: parent.verticalCenter
                    parentExpanded: root.barExpanded
                    onClicked: root.timeClicked()
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1; height: 14
                    color: Qt.rgba(1, 1, 1, 0.10)
                }

                WorkspacesItem {
                    anchors.verticalCenter: parent.verticalCenter
                    topbarExpanded: root.barExpanded
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1; height: 14
                    color: Qt.rgba(1, 1, 1, 0.10)
                }

                KbdItem { anchors.verticalCenter: parent.verticalCenter; parentExpanded: root.barExpanded }
                AudioItem { anchors.verticalCenter: parent.verticalCenter; parentExpanded: root.barExpanded }
                WifiItem { anchors.verticalCenter: parent.verticalCenter; parentExpanded: root.barExpanded }
                BatteryItem { anchors.verticalCenter: parent.verticalCenter; parentExpanded: root.barExpanded }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 1; height: 14
                    color: Qt.rgba(1, 1, 1, 0.10)
                }

                MenuItem {
                    id: tbMenu
                    anchors.verticalCenter: parent.verticalCenter
                    parentExpanded: root.barExpanded
                    onClicked: root.menuClicked()
                }
            }
        }
    }
}
