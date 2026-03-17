import AstalBattery from "gi://AstalBattery"
import { createBinding, createComputed } from "gnim"

const batt = AstalBattery.get_default()
const percent = createBinding(batt, "percentage")
const charging = createBinding(batt, "charging")
const timeToEmpty = createBinding(batt, "time_to_empty")
const timeToFull = createBinding(batt, "time_to_full")

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60)
  const h = Math.floor(mins / 60)
  const m = mins % 60
  return `${h}h ${m}m`
}

const iconName = createComputed(() => {
  const p = Math.floor(percent() * 100)
  const level = Math.floor(p / 10) * 10
  if (charging()) {
    return p === 100
      ? "battery-level-100-charged-symbolic"
      : `battery-level-${level}-charging-symbolic`
  }
  return `battery-level-${level}-symbolic`
})

const statusLabel = createComputed(() => {
  const pct = Math.floor(percent() * 100)
  if (charging()) {
    const t = timeToFull()
    return t > 0 ? `Charging — ${pct}% (${formatTime(t)} to full)` : `Charging — ${pct}%`
  }
  const t = timeToEmpty()
  return t > 0 ? `Battery — ${pct}% (${formatTime(t)} remaining)` : `Battery — ${pct}%`
})

export const BatteryInfo = (): JSX.Element => {
  return (
    <box cssClasses={["cc-battery"]} spacing={8}>
      <image iconName={iconName} />
      <label label={statusLabel} />
    </box>
  )
}
