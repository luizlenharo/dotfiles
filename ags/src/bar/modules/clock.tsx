import { createPoll } from "ags/time"
import GLib from "gi://GLib?version=2.0"
// import { togglePopup } from "../lib/common";
// import { currentMon } from "../../app";

const time = createPoll("", 1000, () => {
    return GLib.DateTime.new_now_local().format("%H:%M") + " ";
})

export const Clock = (): JSX.Element => {
    // const tempmon = currentMon;
    // return <button onClicked={() => togglePopup("controlcenterWindow" + tempmon)}>
    return <button>
        <label label={time} />
    </button>

}
