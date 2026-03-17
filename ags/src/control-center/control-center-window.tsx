import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createState } from "gnim"
import { WifiTile } from "./modules/wifi"
import { BluetoothTile } from "./modules/bluetooth"
import { BrightnessSlider } from "./modules/brightness"
import { VolumeSlider } from "./modules/volume"
import { BatteryInfo } from "./modules/battery-info"
import { PowerProfile } from "./modules/power-profile"

export const [ccVisible, setCcVisible] = createState(false)

export function toggleCC() {
  setCcVisible((v) => !v)
}

export default function ControlCenterPopup(gdkmonitor: Gdk.Monitor) {
  const { TOP, RIGHT } = Astal.WindowAnchor

  return (
    <window
      name={"control-center"}
      cssClasses={["ControlCenter"]}
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={TOP | RIGHT}
      layer={Astal.Layer.TOP}
      keymode={Astal.Keymode.ON_DEMAND}
      visible={ccVisible}
      application={app}
      $={(self) => {
        const keyController = new Gtk.EventControllerKey()
        keyController.connect("key-pressed", (_ctrl: any, keyval: number) => {
          if (keyval === Gdk.KEY_Escape) {
            setCcVisible(false)
          }
        })
        self.add_controller(keyController)
      }}
    >
      <box cssClasses={["cc-popup"]} orientation={1}>
        <revealer
          revealChild={ccVisible}
          transitionType={Gtk.RevealerTransitionType.SLIDE_DOWN}
          transitionDuration={250}
        >
          <box
            cssClasses={["cc-container"]}
            orientation={1}
            spacing={8}
          >
            <box cssClasses={["cc-row"]} spacing={8} homogeneous>
              {WifiTile()}
              {BluetoothTile()}
            </box>

            <box cssClasses={["cc-section"]} orientation={1} spacing={4}>
              {BrightnessSlider()}
              {VolumeSlider()}
            </box>

            {BatteryInfo()}

            {PowerProfile()}
          </box>
        </revealer>
      </box>
    </window>
  )
}
