import { createPoll } from "ags/time"
import { execAsync, exec } from "ags/process"

function getBrightness(): number {
  try {
    const current = Number(exec("brightnessctl g"))
    const max = Number(exec("brightnessctl m"))
    return max > 0 ? current / max : 0
  } catch {
    return -1
  }
}

const initial = getBrightness()
const available = initial >= 0

const brightness = available
  ? createPoll(initial, 1000, () => getBrightness())
  : null

export const BrightnessSlider = (): JSX.Element => {
  if (!available || !brightness) return <box /> as JSX.Element

  return (
    <box cssClasses={["cc-slider-row"]} spacing={8}>
      <image iconName={"display-brightness-symbolic"} cssClasses={["cc-slider-icon"]} />
      <slider
        hexpand
        value={brightness}
        onChangeValue={(self) => {
          execAsync(`brightnessctl s ${Math.round(self.get_value() * 100)}%`)
        }}
        cssClasses={["cc-slider"]}
      />
    </box>
  )
}
