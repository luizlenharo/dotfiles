import QtQuick
import Quickshell
import "../components"
import ".."

Popover {
    id: root
    popoverWidth: 320
    popoverHeight: 360
    anchorMode: "center"
    topGap: -38

    // Calendar state — start at today's month
    readonly property var _now: new Date()
    property int viewYear: _now.getFullYear()
    property int viewMonth: _now.getMonth()  // 0-based

    function _daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate();
    }
    function _firstWeekday(y, m) {
        return new Date(y, m, 1).getDay();   // 0..6 (Sun..Sat)
    }
    function _monthName(y, m) {
        const names = ["January","February","March","April","May","June",
                       "July","August","September","October","November","December"];
        return names[m] + " " + y;
    }
    function _step(delta) {
        let y = viewYear, m = viewMonth + delta;
        while (m < 0) { m += 12; y -= 1; }
        while (m > 11) { m -= 12; y += 1; }
        viewYear = y; viewMonth = m;
    }

    Item {
        anchors.fill: parent
        anchors.margins: 22
        anchors.topMargin: 20

        Column {
            anchors.fill: parent
            spacing: 12

            // Header
            Item {
                width: parent.width
                height: 26
                Text {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    text: root._monthName(root.viewYear, root.viewMonth)
                    color: Config.onDark
                    font.family: Config.fontText
                    font.pixelSize: 22
                    font.weight: Font.DemiBold
                    font.letterSpacing: -0.374
                }
                Row {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2
                    Item {
                        width: 26; height: 26
                        Rectangle {
                            anchors.fill: parent
                            radius: 13
                            color: navPrev.containsMouse ? Qt.rgba(1,1,1,0.08) : "transparent"
                            Behavior on color { ColorAnimation { duration: Config.easeFast } }
                        }
                        Icons {
                            anchors.centerIn: parent
                            width: 12; height: 12
                            glyph: "chevronLeft"
                            color: Qt.rgba(1, 1, 1, 0.78)
                        }
                        MouseArea {
                            id: navPrev
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root._step(-1)
                        }
                    }
                    Item {
                        width: 26; height: 26
                        Rectangle {
                            anchors.fill: parent
                            radius: 13
                            color: navNext.containsMouse ? Qt.rgba(1,1,1,0.08) : "transparent"
                            Behavior on color { ColorAnimation { duration: Config.easeFast } }
                        }
                        Icons {
                            anchors.centerIn: parent
                            width: 12; height: 12
                            glyph: "chevronRight"
                            color: Qt.rgba(1, 1, 1, 0.78)
                        }
                        MouseArea {
                            id: navNext
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root._step(1)
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width + 2
                x: -1
                height: 1
                color: Config.hairline
            }

            // Weekday header
            Grid {
                width: parent.width
                columns: 7
                rowSpacing: 0
                columnSpacing: 0
                Repeater {
                    model: ["S","M","T","W","T","F","S"]
                    delegate: Item {
                        required property string modelData
                        width: parent.width / 7
                        height: 22
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: Qt.rgba(1, 1, 1, 0.55)
                            font.family: Config.fontText
                            font.pixelSize: 12
                            font.weight: Font.DemiBold
                            font.letterSpacing: -0.224
                        }
                    }
                }
            }

            // Day grid (always 6 rows × 7 cols = 42 cells)
            Grid {
                width: parent.width
                columns: 7
                rowSpacing: 2
                columnSpacing: 2
                Repeater {
                    model: 42
                    delegate: Item {
                        id: cell
                        required property int index
                        readonly property int firstWd: root._firstWeekday(root.viewYear, root.viewMonth)
                        readonly property int dim: root._daysInMonth(root.viewYear, root.viewMonth)
                        readonly property int prevDim: root._daysInMonth(
                            root.viewMonth === 0 ? root.viewYear - 1 : root.viewYear,
                            root.viewMonth === 0 ? 11 : root.viewMonth - 1)
                        readonly property int slot: index - firstWd  // 0..dim-1 in current month
                        readonly property bool inMonth: slot >= 0 && slot < dim
                        readonly property int dayNum: inMonth ? slot + 1
                                : slot < 0 ? prevDim + slot + 1
                                : slot - dim + 1
                        readonly property bool isToday: inMonth
                            && root._now.getFullYear() === root.viewYear
                            && root._now.getMonth() === root.viewMonth
                            && root._now.getDate() === dayNum

                        width: (parent.width - 12) / 7
                        height: width

                        Rectangle {
                            anchors.fill: parent
                            radius: width / 2
                            color: cell.isToday ? Config.primary : "transparent"
                        }
                        Text {
                            anchors.centerIn: parent
                            text: cell.dayNum
                            color: cell.isToday ? Config.onDark
                                  : cell.inMonth ? Qt.rgba(1, 1, 1, 0.92)
                                  :                Qt.rgba(1, 1, 1, 0.32)
                            font.family: Config.fontText
                            font.pixelSize: 14
                            font.weight: cell.isToday ? Font.DemiBold : Font.Normal
                        }
                    }
                }
            }
        }
    }
}
