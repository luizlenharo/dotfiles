import PowerProfiles from "gi://AstalPowerProfiles"
import { createBinding, createComputed } from "gnim"

const pp = PowerProfiles.get_default()
const activeProfile = createBinding(pp, "active_profile")

const profiles = [
  { id: "power-saver", label: "Low Power", icon: "power-profile-power-saver-symbolic" },
  { id: "balanced", label: "Balanced", icon: "power-profile-balanced-symbolic" },
  { id: "performance", label: "Performance", icon: "power-profile-performance-symbolic" },
]

export const PowerProfile = (): JSX.Element => {
  return (
    <box cssClasses={["cc-power-profiles"]} spacing={4} homogeneous>
      {profiles.map(({ id, label, icon }) => (
        <button
          cssClasses={createComputed(() =>
            ["cc-profile-btn", activeProfile() === id ? "cc-profile-active" : ""]
          )}
          onClicked={() => pp.set_active_profile(id)}
        >
          <box orientation={1} spacing={2}>
            <image iconName={icon} />
            <label label={label} />
          </box>
        </button>
      ))}
    </box>
  )
}
