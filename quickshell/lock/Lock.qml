import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

// Session lock: ext-session-lock-v1 + PAM auth. One instance lives on the
// ShellRoot. `lock.locked = true` engages the lock; PAM completion clears it.
//
// Safety: while iterating, keep the working `Super+L → hyprlock` bind. Test
// this implementation via the dedicated `Super+Shift+L` bind and only
// retire hyprlock after several successful unlock cycles.
Item {
    id: root

    // Public state mirrors WlSessionLock.locked so other components (e.g.
    // power popover) can call `lock.activate()` instead of poking the inner.
    readonly property bool locked: sessionLock.locked
    readonly property bool secure: sessionLock.secure

    // Stage the surface should display: 0 = clock only, 1 = password prompt.
    // Lifted here so every per-monitor surface stays in sync.
    property int stage: 0

    // PAM state surfaced for the surface to render.
    property string password: ""
    property string pamMessage: ""
    property bool pamError: false
    property bool authBusy: false

    signal activated()

    // Preload the wallpaper into Qt's texture cache at shell startup so the
    // first lock activation paints the wallpaper immediately, with no JPEG
    // decode delay. The actual lock surface then loads the same source from
    // cache instantly.
    Image {
        source: Config.lockWallpaper
        sourceSize.width: 2560
        sourceSize.height: 1440
        cache: true
        asynchronous: true
        visible: false
        width: 0; height: 0
    }

    function activate() {
        if (sessionLock.locked) return;
        stage = 0;
        password = "";
        pamMessage = "";
        pamError = false;
        sessionLock.locked = true;
        activated();
    }

    function toStage2() {
        if (!sessionLock.locked) return;
        if (stage !== 1) {
            stage = 1;
            // PAM conversation starts only when the user reveals the prompt;
            // this avoids burning a try the moment the screen locks.
            if (!pam.active) pam.start();
        }
    }

    function backToStage1() {
        if (!sessionLock.locked) return;
        if (stage === 1) {
            stage = 0;
            password = "";
            pamMessage = "";
            pamError = false;
            if (pam.active) pam.abort();
        }
    }

    function submit() {
        if (!sessionLock.locked || stage !== 1 || authBusy) return;
        if (password.length === 0) return;
        if (!pam.active) {
            if (!pam.start()) {
                pamMessage = "PAM start failed";
                pamError = true;
                return;
            }
        }
        authBusy = true;
        pam.respond(password);
    }

    WlSessionLock {
        id: sessionLock

        // Wrap in Component explicitly: `surface` is QQmlComponent and the
        // Component captures the lexical scope so children can reach `root`.
        surface: Component {
            LockSurface { controller: root }
        }

        onLockStateChanged: {
            if (!locked && pam.active) pam.abort();
        }
    }

    PamContext {
        id: pam
        config: "hyprlock"   // reuse existing service (auth include login)
        user: Quickshell.env("USER")

        onCompleted: result => {
            root.authBusy = false;
            if (result === PamResult.Success) {
                root.password = "";
                root.pamMessage = "";
                root.pamError = false;
                // `locked = false` is the unlock setter; WlSessionLock has
                // no Q_INVOKABLE unlock() method exposed to QML.
                sessionLock.locked = false;
            } else {
                root.password = "";
                root.pamError = true;
                root.pamMessage = result === PamResult.MaxTries
                    ? "Too many attempts"
                    : "Incorrect password";
            }
        }

        onError: err => {
            root.authBusy = false;
            root.password = "";
            root.pamError = true;
            root.pamMessage = PamError.toString(err);
        }

        onPamMessage: {
            // Informational PAM message; only show if not in mid-auth so we
            // don't clobber the "Incorrect password" string.
            if (!root.authBusy && message.length > 0) {
                root.pamMessage = message;
                root.pamError = messageIsError;
            }
        }
    }

    IpcHandler {
        target: "lock"
        function activate() { root.activate() }
        function status() { return sessionLock.locked ? "locked" : "unlocked" }
    }
}
