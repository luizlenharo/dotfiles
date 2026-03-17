import Network from "gi://AstalNetwork"
import { createBinding, createComputed } from "gnim"
import { execAsync } from "ags/process"
import { setCcVisible } from "../control-center-window"

const net = Network.get_default()
const enabled = createBinding(net.wifi, "enabled")
const ssid = createBinding(net.wifi, "ssid")((s: string | null) => s || "Not connected")
const iconName = createBinding(net.wifi, "icon_name")

export const WifiTile = (): JSX.Element => {
  return (
    <box cssClasses={createComputed(() => ["cc-tile", enabled() ? "cc-tile-active" : ""])} orientation={1} spacing={4}>
      <button
        cssClasses={["cc-tile-icon"]}
        onClicked={() => net.wifi.set_enabled(!net.wifi.enabled)}
      >
        <image iconName={iconName} />
      </button>
      <button
        cssClasses={["cc-tile-label"]}
        onClicked={() => {
          setCcVisible(false)
          execAsync("env XDG_CURRENT_DESKTOP=gnome gnome-control-center wifi")
        }}
      >
        <box orientation={1}>
          <label label={"Wi-Fi"} cssClasses={["cc-tile-title"]} />
          <label label={ssid} cssClasses={["cc-tile-subtitle"]} ellipsize={3} />
        </box>
      </button>
    </box>
  )
}
