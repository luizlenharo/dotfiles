
import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { Clock } from "./modules/clock"
import { Workspaces } from "./modules/workspaces"
import { Battery } from "./modules/battery"
import { Wifi } from "./modules/network"
import { Sound } from "./modules/sound"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP}
      application={app}
    >
      <box cssClasses={["bar"]}>
        <box cssClasses={["bar-left"]} hexpand halign={Gtk.Align.START}>
          { Clock() }
        </box>
        <box cssClasses={["bar-center"]} hexpand halign={Gtk.Align.CENTER}>
          { Workspaces() }
        </box>
        <box cssClasses={["bar-right"]} hexpand halign={Gtk.Align.END}>
          { Sound() }
          { Wifi() }
          { Battery() }
        </box>
      </box>
    </window>
  )
}
