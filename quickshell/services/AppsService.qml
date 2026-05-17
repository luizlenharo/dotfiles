pragma Singleton

import QtQuick
import Quickshell

// Wraps DesktopEntries with a fuzzy filter. Ranks: exact start > word-start
// > substring > category/keyword match. Filters out NoDisplay entries.
QtObject {
    id: root

    function _all() {
        const out = [];
        const m = DesktopEntries.applications;
        if (!m) return out;
        for (let i = 0; i < m.values.length; i++) {
            const e = m.values[i];
            if (!e || e.noDisplay) continue;
            out.push(e);
        }
        return out;
    }

    function _score(entry, q) {
        if (!q) return 1;
        const name = (entry.name || "").toLowerCase();
        const generic = (entry.genericName || "").toLowerCase();
        const cmd = (entry.execString || "").toLowerCase();
        if (name.startsWith(q)) return 100 - name.length * 0.01;
        const idx = name.indexOf(" " + q);
        if (idx >= 0) return 80 - idx * 0.1;
        if (name.indexOf(q) >= 0) return 60;
        if (generic.indexOf(q) >= 0) return 40;
        if (cmd.indexOf(q) >= 0) return 20;
        return 0;
    }

    function search(query, limit) {
        const q = (query || "").trim().toLowerCase();
        const all = _all();
        if (!q) {
            // No query: alphabetical, capped to limit
            return all.slice().sort((a, b) =>
                (a.name || "").localeCompare(b.name || "")
            ).slice(0, limit || 8);
        }
        const scored = [];
        for (let i = 0; i < all.length; i++) {
            const s = _score(all[i], q);
            if (s > 0) scored.push({ e: all[i], s });
        }
        scored.sort((a, b) => b.s - a.s);
        return scored.slice(0, limit || 6).map(x => x.e);
    }

    function metaFor(entry) {
        if (!entry) return "";
        if (entry.runInTerminal) return "Terminal application";
        return entry.genericName || "Application";
    }
}
