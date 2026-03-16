import AstalBattery from "gi://AstalBattery"
import { createBinding, createComputed } from "gnim"

const batt = AstalBattery.get_default();

const percent = createBinding(batt, "percentage",)
    ((p: number) => ` ${Math.floor(p * 100)}`);

const charging = createBinding(batt, "charging");

const iconName = createComputed(() => charging() ?
    (Number(percent()) == 100) ? `battery-level-${Math.floor(Number(percent()) / 10) * 10}-charged-symbolic` :
        `battery-level-${Math.floor(Number(percent()) / 10) * 10}-charging-symbolic` :
    `battery-level-${Math.floor(Number(percent()) / 10) * 10}-symbolic`);


export const Battery = (): JSX.Element => {
    return <button name={"batteryButton"}>
        <box>
            <image iconName={iconName} />
            <label label={percent(p => p + "%")} />
        </box>
    </button>;
}

