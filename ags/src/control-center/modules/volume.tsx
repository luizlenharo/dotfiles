import Wp from "gi://AstalWp"
import { Gtk } from "ags/gtk4"
import { createBinding, createComputed } from "gnim"

const speaker = Wp.get_default().audio.default_speaker
const vol = createBinding(speaker, "volume")
const muted = createBinding(speaker, "mute")

const iconName = createComputed(() => {
  if (muted()) return "audio-volume-muted-symbolic"
  const v = vol() * 100
  if (v > 66) return "audio-volume-high-symbolic"
  if (v > 33) return "audio-volume-medium-symbolic"
  if (v > 0) return "audio-volume-low-symbolic"
  return "audio-volume-muted-symbolic"
})

export const VolumeSlider = (): JSX.Element => {
  return (
    <box cssClasses={["cc-slider-row"]} spacing={8}>
      <button
        cssClasses={["cc-slider-icon"]}
        onClicked={() => speaker.set_mute(!speaker.mute)}
      >
        <image iconName={iconName} />
      </button>
      <slider
        hexpand
        value={vol}
        onChangeValue={(self) => speaker.set_volume(self.get_value())}
        cssClasses={["cc-slider"]}
        adjustment={
          new Gtk.Adjustment({
            lower: 0,
            upper: 1.5,
            stepIncrement: 0.01,
            pageIncrement: 0.05,
          })
        }
      />
    </box>
  )
}
