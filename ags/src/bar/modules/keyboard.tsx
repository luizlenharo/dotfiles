import { createPoll } from "ags/time"
import { exec, execAsync } from "ags/process"

function getLayout(): string {
    try {
        const out = exec("hyprctl devices -j")
        const data = JSON.parse(out)
        const kb = data.keyboards?.find((k: any) => !k.name.startsWith("virtual")) ?? data.keyboards?.[0]
        const map: string = kb?.active_keymap ?? ""
        if (map.toLowerCase().includes("brazil")) return "BR"
        if (map.toLowerCase().includes("english") || map.toLowerCase().includes("us")) return "US"
        return map.slice(0, 2).toUpperCase() || "??"
    } catch {
        return "??"
    }
}

const layout = createPoll("??", 500, getLayout)

export const KeyboardLayout = (): JSX.Element => (
    <button onClicked={() => execAsync("hyprctl switchxkblayout all next")}>
        <label label={layout} />
    </button>
)
