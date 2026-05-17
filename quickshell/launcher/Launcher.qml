import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "../components"
import "../services"
import ".."

PanelWindow {
    id: root

    property bool open: false
    property string query: ""
    property int selectedIndex: 0
    property var results: AppsService.search(query, 8)

    color: "transparent"
    visible: open || card.opacity > 0.01

    anchors { top: true; left: true; right: true; bottom: true }
    // -1 tells wlr-layer-shell to draw across other layers' exclusion zones,
    // so the scrim covers the strip reserved by the bar.
    exclusiveZone: -1
    exclusionMode: ExclusionMode.Normal
    focusable: open
    aboveWindows: true

    WlrLayershell.namespace: "quickshell:launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    function show() {
        query = "";
        selectedIndex = 0;
        open = true;
        Qt.callLater(() => input.forceActiveFocus());
    }
    function hide() {
        open = false;
        query = "";
    }
    function launch(index) {
        const e = results[index];
        if (!e) return;
        e.execute();
        hide();
    }

    onQueryChanged: selectedIndex = 0

    // Scrim — closes on outside click
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.18)
        opacity: root.open ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        MouseArea { anchors.fill: parent; onClicked: root.hide() }
    }

    GlassSurface {
        id: card
        width: 640
        radius: Config.rLg
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height * 0.30 + (root.open ? 0 : -8)
        height: header.height + (resultsList.count > 0 ? Math.min(360, resultsList.count * 56 + 16) : 56)
        opacity: root.open ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on y { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }

        Column {
            anchors.fill: parent

            Item {
                id: header
                width: parent.width
                height: 64
                Row {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 22
                    spacing: 14
                    Icons {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 22; height: 22
                        glyph: "search"
                        color: Qt.rgba(1, 1, 1, 0.55)
                    }
                    TextInput {
                        id: input
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width - 22 - 14
                        text: root.query
                        onTextChanged: root.query = text
                        color: Config.onDark
                        selectByMouse: true
                        font.family: Config.fontDisplay
                        font.pixelSize: 28
                        font.letterSpacing: 0.196
                        clip: true

                        Text {
                            visible: input.text.length === 0
                            text: "Search"
                            color: Qt.rgba(1, 1, 1, 0.42)
                            font: input.font
                        }

                        Keys.onPressed: function(e) {
                            if (e.key === Qt.Key_Escape) { root.hide(); e.accepted = true; }
                            else if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                                root.launch(root.selectedIndex); e.accepted = true;
                            }
                            else if (e.key === Qt.Key_Down) {
                                if (resultsList.count > 0)
                                    root.selectedIndex = (root.selectedIndex + 1) % resultsList.count;
                                e.accepted = true;
                            }
                            else if (e.key === Qt.Key_Up) {
                                if (resultsList.count > 0)
                                    root.selectedIndex = (root.selectedIndex - 1 + resultsList.count) % resultsList.count;
                                e.accepted = true;
                            }
                        }
                    }
                }
            }

            Rectangle { width: parent.width; height: 1; color: Config.hairline }

            ListView {
                id: resultsList
                width: parent.width
                height: card.height - header.height - 1
                clip: true
                interactive: count > 6
                model: root.results
                spacing: 0
                boundsBehavior: Flickable.StopAtBounds

                delegate: LauncherRow {
                    required property var modelData
                    required property int index
                    width: resultsList.width - 16
                    x: 8
                    height: 56
                    entry: modelData
                    selected: root.selectedIndex === index
                    onActivated: root.launch(index)
                }

                Text {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: 22
                    anchors.topMargin: 18
                    visible: resultsList.count === 0 && root.query.length > 0
                    text: "No results"
                    color: Qt.rgba(1, 1, 1, 0.5)
                    font.family: Config.fontText
                    font.pixelSize: 14
                }
            }
        }
    }
}
