import { Gtk } from "ags/gtk4";
import Hyprland from "gi://AstalHyprland"
import { createBinding, createComputed } from "gnim"

const hyprland = Hyprland.get_default()


function workspaceButton(n: number): JSX.Element {
    const active = createBinding(hyprland, "focused_workspace");
    const visible = createBinding(hyprland, "workspaces");

    const className = createComputed(() => {
        if (active() && n == active().get_id()) {
            return "workspace-focused";
        } else if (visible() && visible().map((w: Hyprland.Workspace) => w.get_id()).includes(n)) {
            return "workspace-visible";
        } else {
            return ""
        }
    })

    return (
        <button
            onClicked={() => { hyprland.message_async(`dispatch workspace ${n}`, () => { }) }}
            class={className}
            label={n.toString()}
        />
    )
}

export const Workspaces = (): JSX.Element => <box cssClasses={["workspaces"]} spacing={2} children={[1, 2, 3, 4, 5].map(workspaceButton)} />;
