import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland
import ".."
import "../components"

// Per-monitor lock surface. Stage 0 shows just the clock; clicking or
// pressing a key reveals stage 1 (password). All stage state lives on the
// controller (Lock.qml) so multi-monitor stays in sync.
WlSessionLockSurface {
    id: surface

    required property var controller

    readonly property int stage: controller ? controller.stage : 0
    readonly property bool authBusy: controller && controller.authBusy

    // Wallpaper. ext-session-lock-v1 hides desktop content, so we render
    // the wallpaper ourselves; the dark scrim above sets the lock vibe.
    // The image is rendered into a layer so MultiEffect can apply blur in
    // stage 2 without disturbing layout.
    Image {
        id: wallpaper
        anchors.fill: parent
        source: Config.lockWallpaper
        fillMode: Image.PreserveAspectCrop
        // Sync load so the lock never flashes a black frame before the
        // wallpaper appears. Cached after first lock so subsequent unlocks
        // are instant. sourceSize is fixed (not bound to parent.width which
        // is 0 at construction) so the texture is ready before paint.
        asynchronous: false
        cache: true
        sourceSize.width: 2560
        sourceSize.height: 1440
        visible: false   // MultiEffect renders it
        layer.enabled: true
    }

    MultiEffect {
        anchors.fill: parent
        source: wallpaper
        blurEnabled: true
        blurMax: 48
        // 0 in stage 0, ramps to ~0.7 in stage 2.
        blur: surface.stage === 0 ? 0 : 0.7
        Behavior on blur { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }
    }

    // Dark scrim on top of the wallpaper. Less opaque in stage 0 so the
    // wallpaper reads through; stage 2 darkens for focus on the prompt.
    Rectangle {
        id: backdrop
        anchors.fill: parent
        color: "#000000"
        opacity: surface.stage === 0 ? 0.30 : 0.7
        Behavior on opacity { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }
    }

    // Content column, mirrors `.lock-content` (padding-top morphs).
    Item {
        id: content
        anchors.fill: parent
        anchors.topMargin: parent.height * (surface.stage === 0 ? 0.16 : 0.11)
        Behavior on anchors.topMargin { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 14

            // ───── Clock ─────
            Text {
                id: clock
                anchors.horizontalCenter: parent.horizontalCenter
                text: surface._timeText
                color: Config.onDark
                font.family: Config.fontDisplay
                font.pixelSize: surface.stage === 0 ? 112 : 96
                font.weight: Font.DemiBold
                font.letterSpacing: -3
                font.features: { "tnum": 1 }
                Behavior on font.pixelSize { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }
            }

            // ───── Date ─────
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: surface._dateText
                color: Qt.rgba(1, 1, 1, 0.85)
                font.family: Config.fontDisplay
                font.pixelSize: 28
                font.weight: Font.Normal
                font.letterSpacing: 0.196
            }

            // ───── Stage-2 cluster (avatar + name + password) ─────
            Column {
                id: stage2
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 42
                spacing: 18
                opacity: surface.stage === 1 ? 1 : 0
                enabled: surface.stage === 1
                Behavior on opacity { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }

                // Avatar (initials).
                Rectangle {
                    id: avatar
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 96; height: 96
                    radius: 48
                    gradient: Gradient {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.0; color: "#5b6b8a" }
                        GradientStop { position: 1.0; color: "#2f3a52" }
                    }
                    border.color: Qt.rgba(1, 1, 1, 0.18)
                    border.width: 1
                    Text {
                        anchors.centerIn: parent
                        text: "LL"
                        color: Config.onDark
                        font.family: Config.fontDisplay
                        font.pixelSize: 38
                        font.weight: Font.DemiBold
                        font.letterSpacing: -1
                    }
                }

                // Name.
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Luiz Lenharo"
                    color: Config.onDark
                    font.family: Config.fontText
                    font.pixelSize: 34
                    font.weight: Font.DemiBold
                    font.letterSpacing: -0.374
                }

                // Password pill.
                Rectangle {
                    id: pwdPill
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 280; height: 44
                    radius: Config.rPill
                    color: Qt.rgba(1, 1, 1, 0.10)
                    border.color: Qt.rgba(1, 1, 1, 0.06)
                    border.width: 1

                    // Shake when auth fails. Animating Translate avoids
                    // fighting the parent Column's anchor management.
                    transform: Translate { id: shakeXform; x: 0 }
                    SequentialAnimation {
                        id: shake
                        loops: 1
                        NumberAnimation { target: shakeXform; property: "x"; to: -8; duration: 60 }
                        NumberAnimation { target: shakeXform; property: "x"; to:  8; duration: 60 }
                        NumberAnimation { target: shakeXform; property: "x"; to: -5; duration: 60 }
                        NumberAnimation { target: shakeXform; property: "x"; to:  0; duration: 60 }
                    }

                    Item {
                        anchors.fill: parent
                        anchors.leftMargin: 18
                        anchors.rightMargin: 6

                        TextInput {
                            id: pwdInput
                            anchors.left: parent.left
                            anchors.right: submitBtn.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: 8
                            echoMode: TextInput.Password
                            passwordCharacter: "•"
                            color: Config.onDark
                            selectionColor: Config.primaryOnDark
                            font.family: Config.fontText
                            font.pixelSize: 17
                            font.letterSpacing: 4
                            clip: true
                            enabled: !surface.authBusy
                            text: surface.controller ? surface.controller.password : ""
                            onTextChanged: if (surface.controller) surface.controller.password = text
                            onAccepted: if (surface.controller) surface.controller.submit()

                            Text {
                                anchors.left: parent.left
                                anchors.verticalCenter: parent.verticalCenter
                                visible: pwdInput.text.length === 0
                                text: surface.controller && surface.controller.pamMessage.length > 0
                                      ? surface.controller.pamMessage
                                      : "Enter Password"
                                color: surface.controller && surface.controller.pamError
                                       ? Qt.rgba(1, 0.42, 0.40, 0.95)
                                       : Qt.rgba(1, 1, 1, 0.55)
                                font.family: Config.fontText
                                font.pixelSize: 17
                                font.letterSpacing: -0.374
                            }
                        }

                        // Submit button (chevron).
                        Rectangle {
                            id: submitBtn
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            width: 32; height: 32
                            radius: 16
                            color: Qt.rgba(1, 1, 1, 0.18)
                            opacity: pwdInput.text.length > 0 ? 1 : 0
                            scale: pwdInput.text.length > 0 ? 1 : 0.9
                            Behavior on opacity { NumberAnimation { duration: Config.easeMed; easing.bezierCurve: Config.easeCurve } }
                            Behavior on scale { NumberAnimation { duration: Config.easeMed; easing.bezierCurve: Config.easeCurve } }

                            Icons {
                                anchors.centerIn: parent
                                width: 14; height: 14
                                glyph: "chevronRight"
                                color: Config.onDark
                            }

                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: if (surface.controller) surface.controller.submit()
                            }
                        }
                    }
                }
            }
        }
    }

    // Esc hint, bottom-centered. Only visible in stage 2.
    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 32
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 4
        opacity: surface.stage === 1 ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 320; easing.bezierCurve: Config.easeCurve } }

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            color: Qt.rgba(1, 1, 1, 0.10)
            radius: 5
            implicitWidth: kbdLabel.implicitWidth + 14
            implicitHeight: kbdLabel.implicitHeight + 4
            Text {
                id: kbdLabel
                anchors.centerIn: parent
                text: "Esc"
                color: Qt.rgba(1, 1, 1, 0.85)
                font.family: Config.fontText
                font.pixelSize: 12
            }
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "to go back"
            color: Qt.rgba(1, 1, 1, 0.60)
            font.family: Config.fontText
            font.pixelSize: 14
            font.letterSpacing: -0.224
        }
    }

    // Click anywhere in stage 0 → reveal password.
    MouseArea {
        anchors.fill: parent
        enabled: surface.stage === 0
        onClicked: if (surface.controller) surface.controller.toStage2()
    }

    // Keyboard handling. Item gets focus when the surface becomes visible.
    Item {
        id: keys
        anchors.fill: parent
        // Avoid binding to `surface.visible`: that reads QWindow::isVisible()
        // and crashes when evaluated during the surface's initial finalize
        // (the platform window isn't backed yet). The surface only exists
        // while the lock is engaged, so unconditional focus is fine.
        focus: true
        Keys.onEscapePressed: {
            if (surface.controller) surface.controller.backToStage1();
        }
        Keys.onPressed: e => {
            if (surface.stage === 0) {
                // Any non-modifier key reveals the prompt.
                if (e.key !== Qt.Key_Escape && e.key !== Qt.Key_Shift
                    && e.key !== Qt.Key_Control && e.key !== Qt.Key_Alt
                    && e.key !== Qt.Key_Meta) {
                    if (surface.controller) surface.controller.toStage2();
                }
                e.accepted = true;
            }
        }
    }

    // When the controller flips into stage 1, hand keyboard focus to the
    // password field so typing goes straight into it.
    Connections {
        target: surface.controller
        function onStageChanged() {
            if (surface.controller.stage === 1) {
                pwdInput.forceActiveFocus();
            }
        }
        function onPamErrorChanged() {
            if (surface.controller.pamError) shake.start();
        }
    }

    // ─── Time/date formatting ───
    property string _timeText: "00:00"
    property string _dateText: ""

    function _updateTime() {
        const d = new Date();
        const hh = d.getHours().toString().padStart(2, "0");
        const mm = d.getMinutes().toString().padStart(2, "0");
        _timeText = hh + ":" + mm;
        _dateText = Qt.formatDate(d, "dddd, d MMMM");
    }

    Timer {
        interval: 1000
        // See focus note above: don't bind to surface.visible (QWindow crash).
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: surface._updateTime()
    }

    Component.onCompleted: _updateTime()
}
