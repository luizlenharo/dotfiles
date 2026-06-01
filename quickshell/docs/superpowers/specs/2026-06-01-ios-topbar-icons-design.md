# iOS-style Topbar Icons — Design

Date: 2026-06-01

## Problem

Topbar WiFi and battery icons don't read as iOS icons, and the battery icon
never changes with charge level (the level-fill code was commented out). Target
look: filled iOS-style glyphs as in the reference (solid WiFi fan, rounded
battery body with a level fill).

## Scope

- `components/Icons.qml` — reshape `wifi` glyph; add `bolt` glyph.
- `components/BatteryGlyph.qml` — new dedicated battery component.
- `bar/BatteryItem.qml` — use `BatteryGlyph`; derive charging state.
- `bar/WifiItem.qml` — thicker stroke for the filled-fan look.

No behavior change beyond the icons themselves. No new assets — everything is
drawn with `QtQuick.Shapes`, matching the existing `Icons.qml` convention.

## Decisions

- **WiFi**: solid iOS fan = two thick stroked arcs + filled dot. Full opacity
  when `WifiService.connected`, dimmed to 40% when off. No strength tiering.
- **Battery**: inner level fill scaling with percentage; fill turns red
  (`Config.destructive`) at `pct <= 20` when not charging; charging shows a
  `bolt` glyph overlay.
- **Build**: from scratch with `QtQuick.Shapes`; battery level fill via an
  inner `Rectangle` (a static `PathSvg` glyph can't scale its width).

## Components

### `Icons.qml` changes

- `wifi` `_strokePath`: two arcs (inner + outer) on the 24×24 viewbox, sized to
  match the reference fan. Dot stays in `_fillPath` (`wifiDot`-style filled
  circle near bottom-center).
- The arcs render at whatever `strokeWidth` the caller passes; `WifiItem` passes
  a thicker value (~2.8) so the fan reads as filled.
- Add `bolt` glyph: filled lightning path in `_fillPath` for the charging
  overlay.

### `BatteryGlyph.qml` (new)

A small self-contained `Item`. Inputs:

- `pct: int` (0–100) — fill width.
- `charging: bool` — show bolt overlay.
- `color: color` — body outline + normal fill (default `Config.onDark`).
- `lowColor: color` — fill when low (default `Config.destructive`).

Render:

- Body: rounded-rect outline via `Shape` stroke + a small terminal nub on the
  right.
- Fill: inner `Rectangle`, inset ~1.5px from the body, `width` proportional to
  `pct` (clamped to a small minimum so 0–1% still shows a sliver), rounded
  corners. Color = `lowColor` when `pct <= 20 && !charging`, else `color`.
- Bolt: `Icons { glyph: "bolt" }` centered over the body, visible only when
  `charging`, in a color that contrasts the fill.

Aspect: roughly 24×12 internal proportions, matching the reference's wide
battery. The component exposes `implicitWidth`/`implicitHeight` so the bar item
sizes correctly.

### `BatteryItem.qml` changes

- Add `readonly property bool charging` derived from `dev.state` (UPower
  charging / pending-charge / fully-charged states). The exact enum value name
  is verified against Quickshell's `UPowerDeviceState` during implementation.
- Short form: replace the `Icons{glyph:"battery"}` + dead commented Rectangle
  with `BatteryGlyph { pct: root.pct; charging: root.charging }`.
- Long form: same swap; keep the `"<pct>% · <mode>"` text.

### `WifiItem.qml` changes

- Pass `strokeWidth: 2.8` (or similar) to the `wifi` `Icons` in both forms so
  the arcs read as a filled fan. Keep the `opacity` dim-when-disconnected
  binding.

## Verification (visual + functional)

`qs reload`, then observe the bar:

- WiFi reads as a solid iOS fan; dims when WiFi is off.
- Battery fill width tracks the real percentage (compare with `upower -d` or the
  long-form `%` text).
- Fill turns red at low charge; bolt appears while charging (test by plugging /
  unplugging, or temporarily forcing `charging`/`pct` for a visual check).
