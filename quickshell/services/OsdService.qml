pragma Singleton

import QtQuick
import "."

// Triggers the OSD when audio volume/mute or brightness changes. The OSD UI
// observes `kind` and `level` and shows/auto-hides itself.
QtObject {
    id: root

    property string kind: ""      // "vol" | "bri"
    property int level: 0
    property bool show: false

    // Suppress the very first changed events on startup so we don't pop the
    // OSD when the shell loads.
    property bool _audioSeeded: false
    property bool _briSeeded: false

    function trigger(k, lvl) {
        kind = k;
        level = lvl;
        show = true;
        _hideTimer.restart();
    }

    property Timer _hideTimer: Timer {
        interval: 1500
        repeat: false
        onTriggered: root.show = false
    }

    property Connections _audio: Connections {
        target: AudioService
        function onVolumeChanged() {
            if (!root._audioSeeded) { root._audioSeeded = true; return; }
            root.trigger("vol", AudioService.muted ? 0 : AudioService.volumePercent);
        }
        function onMutedChanged() {
            if (!root._audioSeeded) { root._audioSeeded = true; return; }
            root.trigger("vol", AudioService.muted ? 0 : AudioService.volumePercent);
        }
    }

    property Connections _bri: Connections {
        target: BrightnessService
        function onPercentChanged() {
            if (!root._briSeeded) { root._briSeeded = true; return; }
            root.trigger("bri", BrightnessService.percent);
        }
    }
}
