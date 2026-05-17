pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

QtObject {
    id: root

    property var sink: Pipewire.defaultAudioSink
    readonly property bool ready: sink !== null && sink !== undefined && sink.audio !== null
    readonly property real volume: ready ? sink.audio.volume : 0
    readonly property bool muted: ready ? sink.audio.muted : false
    readonly property string sinkName: ready ? (sink.description || sink.nickname || sink.name || "Audio") : "Audio"
    readonly property int volumePercent: Math.round(volume * 100)

    // Subscribe to the active sink's audio interface so it pushes updates.
    property PwObjectTracker _tracker: PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }
}
