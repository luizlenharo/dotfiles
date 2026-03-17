import Bluetooth from "gi://AstalBluetooth"
import { createBinding, createComputed } from "gnim"
import { execAsync } from "ags/process"
import { setCcVisible } from "../control-center-window"

const bt = Bluetooth.get_default()
const powered = createBinding(bt.adapter, "powered")
const devices = createBinding(bt, "devices")

const deviceLabel = createComputed(() => {
  const devs = devices()
  const connected = devs?.filter((d: any) => d.connected)
  return connected?.length ? connected[0].name : "Not connected"
})

const iconName = createComputed(() =>
  powered() ? "bluetooth-active-symbolic" : "bluetooth-disabled-symbolic"
)

export const BluetoothTile = (): JSX.Element => {
  return (
    <box cssClasses={createComputed(() => ["cc-tile", powered() ? "cc-tile-active" : ""])} orientation={1} spacing={4}>
      <button
        cssClasses={["cc-tile-icon"]}
        onClicked={() => bt.adapter.set_powered(!bt.adapter.powered)}
      >
        <image iconName={iconName} />
      </button>
      <button
        cssClasses={["cc-tile-label"]}
        onClicked={() => {
          setCcVisible(false)
          execAsync("env XDG_CURRENT_DESKTOP=gnome gnome-control-center bluetooth")
        }}
      >
        <box orientation={1}>
          <label label={"Bluetooth"} cssClasses={["cc-tile-title"]} />
          <label label={deviceLabel} cssClasses={["cc-tile-subtitle"]} ellipsize={3} />
        </box>
      </button>
    </box>
  )
}
