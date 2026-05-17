import QtQuick
import ".."

// Apple Big Sur glass: dark translucent fill + inset 1px top hairline.
// QML can't do CSS box-shadow inset, so we approximate with a 1px border in
// hairlineStrong, which reads as a soft ring around the pill. Hyprland's
// namespace blur is what produces the actual frosted-glass effect.
Rectangle {
    color: Config.glassFill
    radius: Config.rPill
    antialiasing: true

    border.width: 1
    border.color: Config.hairlineStrong
}
