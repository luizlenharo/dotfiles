# Workspace Urgent Blink — Design

Date: 2026-09-10

## Problem

Previous waybar setup blinked the workspace/app icon when a window needed
attention (e.g. a PDF finished opening, a dialog demanded focus). Quickshell
topbar has no equivalent — urgent windows raise no visual signal.

## Scope

- `bar/WorkspacesItem.qml` — detect urgent state per workspace, blink pill.
- `Config.qml` — one new color token for the urgent blink.

No new services, no raw Hyprland IPC parsing: `Quickshell.Hyprland` already
exposes a reactive `urgent: bool` property on `HyprlandWorkspace` (and on
`HyprlandToplevel`), aggregated natively by Hyprland itself.

## Decisions

- **Workspace pill blinks, not app icon.** App icons only render when the bar
  is expanded (`topbarExpanded && hasApps`); they're invisible half the time
  and useless as an attention cue. The pill is always visible.
- **Source of truth**: match `Hyprland.workspaces.values` by `wsId` to get the
  `HyprlandWorkspace`, read its `urgent` property directly (reactive via
  `urgentChanged`) instead of scanning the manually-built `clients` list.
- **Stop condition**: blink clears the instant the workspace is switched to
  (`isActive` becomes true), not only when the specific urgent window is
  clicked. Matches waybar's default behavior and is simplest.
  `isUrgent := workspace.urgent && !isActive`.
- **Visual**: pill background alternates between a new urgent-red token and
  transparent via `SequentialAnimation` (`ColorAnimation`, `loops: Infinite`),
  `running` bound to `isUrgent` so it starts/stops for free. ~600ms per leg.
- **Color priority**: pill color ternary gets urgent as the top-priority
  branch, above active/hasApps/transparent, since urgent should visually
  dominate.

## Components

### `Config.qml`

- Add `wsUrgent: "#FF453A"` (Apple system-red, matching existing palette
  style) — used as the "on" phase of the blink.

### `bar/WorkspacesItem.qml`

- Inside the `Repeater` delegate (`Item { id: ws }`):
  - `readonly property var hyprWs: { const list = Hyprland.workspaces ? Hyprland.workspaces.values : []; for (const w of list) if (w.id === wsId) return w; return null; }`
  - `readonly property bool isUrgent: hyprWs ? hyprWs.urgent && !isActive : false`
- On `pill` (`Rectangle`):
  - `color` ternary: `ws.isUrgent ? blink.current : (ws.isActive ? Config.wsActive : ws.hasApps ? Config.wsHasApps : "transparent")`
  - Add a small blink driver — either a local `color` property animated by a
    `SequentialAnimation on <prop>` gated by `running: ws.isUrgent`, alternating
    `Config.wsUrgent` and `"transparent"`, feeding into the ternary above.
  - Keep existing `Behavior on color` for the non-blink transitions; the
    infinite `SequentialAnimation` takes over color ownership only while
    `isUrgent` is true (Behavior and explicit animation don't fight because
    only one drives `color` at a time based on `running`).

## Out of scope

- No sound/notification-center integration — purely the bar visual.
- No config toggle to disable the blink — single fixed behavior, per existing
  project convention of hardcoded tokens over settings.
