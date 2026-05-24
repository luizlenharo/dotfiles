# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Quickshell-based Hyprland desktop shell written in QML. Replaces an earlier AGS setup (still present at `dotfiles/ags/`). Visual target is an Apple/Big-Sur-styled glass shell defined by the prototype at `Hyprland Desktop-handoff/hyprland-desktop/project/Hyprland Desktop.html` and the design notes in `uploads/DESIGN-apple.md`.

`/home/llenharo/.config/quickshell` mirrors this directory — edit files here; Quickshell hot-reloads on save.

## Run / reload

- Launch (Hyprland already does this via `exec-once = qs &`): `qs -p ~/dotfiles/quickshell`
- Force reload: `qs reload`
- IPC: `qs ipc call <target> <fn>` — handlers live in `shell.qml` (`launcher`, `bar`)
- Triggered by Hyprland keybinds: `Super+Space` → `qs ipc call launcher toggle`; `Super+B` → `qs ipc call bar toggle`

No build, lint, or test tooling. Verification is visual + functional (see "Verification" in `~/.claude/plans/read-the-attached-hyprland-desktop-zip-tidy-karp.md`).

## Architecture

**Entry / lifetime.** `shell.qml` is a single `ShellRoot` instantiated once. It owns global singleton surfaces (`Launcher`, `NotificationStack`, `Osd`, `CalendarPopover`, `PowerPopover`) and one `TopBar` per monitor via `Variants { model: Quickshell.screens }`. State that must be shared across monitors (e.g. `barExpanded`) lives on `ShellRoot` and is propagated down as a property on each `TopBar`. `IpcHandler { target: ... }` blocks expose CLI-callable functions on global state.

**Design tokens.** `Config.qml` is a `pragma Singleton` (registered via root `qmldir`) holding every color/radius/easing/font constant. Always reference `Config.xxx` rather than hardcoding — the palette is fixed Apple-ish (not Matugen-driven in this pass).

**Services.** `services/` holds singleton wrappers around system state (Pipewire audio, brightnessctl, Hyprland keyboard layout, nmcli wifi poll, OSD debouncer, DesktopEntries+fuzzy). Registered in `services/qmldir`. UI components read from services; they do not poll directly.

**Layer-shell namespacing.** Each `PanelWindow` sets `WlrLayershell.namespace: "quickshell:<surface>"`. Hyprland's `layerrule = blur, quickshell:<surface>` (in `dotfiles/hypr/hyprland.conf`) provides the backdrop blur — QML has no native `backdrop-filter`. New top-level surfaces require both: setting the namespace **and** adding the matching `layerrule`. `ignorezero` is also applied so the blur honors transparency.

**Bar morph pattern (`components/TbItem.qml`).** Each bar item has a `shortForm` and `longForm` Component. The `stack.implicitWidth` is bound to *the visible form only* (`showLong ? long.implicitWidth : short.implicitWidth`) — never `Math.max(short, long)`, which leaves items at long-width when collapsed. **Animation is single-sourced at `stack.implicitWidth`**; outer widths (`TbItem.implicitWidth = stack + 20`, `pill.implicitWidth = barLayout + 24`) bind reactively. Stacking `Behavior on implicitWidth` at multiple levels in this chain creates cascading delay — keep the inner-only Behavior.

**Glass recipe.** `components/GlassSurface.qml` renders the `Config.glassFill` (`rgba(28,28,30,0.72)`) with the inset top hairline (`Config.hairlineStrong`). The Hyprland blur layerrule supplies the actual backdrop blur — the surface itself just paints fill + hairline.

**Icons.** `components/Icons.qml` draws glyphs via `QtQuick.Shapes` (`PathSvg` on a 24×24 viewbox, scaled anisotropically to the parent's width/height). Strokes therefore distort if the container's aspect ratio diverges from 1:1 — this is accepted (a prior attempt to fix it was reverted at the user's request).

**Hyprland integration points.** Workspaces (`Hyprland.workspaces` / `.focusedWorkspace`), toplevels (`Hyprland.toplevels` filtered by workspace id), keyboard layout (`activelayout` event), dispatchers (`Hyprland.dispatch("workspace N")`). App icons resolve via `DesktopEntries.heuristicLookup(appId)` → `image://icon/<name>`.

**Launcher coverage.** Full-screen overlay surfaces (`Launcher`) anchor `top/left/right/bottom: true` and set `exclusiveZone: -1` so the scrim draws over the bar's reserved strip. `exclusiveZone: 0` + `ExclusionMode.Ignore` is not sufficient.

## Conventions

- Per-item hover expansion in the bar is intentionally disabled (see comment in `TbItem.qml`); only the global `barExpanded` toggle drives long form. Don't re-enable without asking.
- Components consume `parentExpanded` (passed from `TopBar`) rather than reading shell state directly.
- Module sibling imports use `import ".."` to reach `Config` and `import "../components"` for shared widgets.

## Out of scope (Pass 2, deferred)

Lock screen via `WlSessionLock` + `PamContext`. Until shipped, `Super+L` keeps invoking `hyprlock`. Don't touch lock work without explicit ask — bugs lock the user out.
