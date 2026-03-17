import { toggleCC } from "../../control-center/control-center-window"

export const ControlCenterButton = (): JSX.Element => {
  return (
    <button onClicked={() => toggleCC()}>
      <image iconName={"open-menu-symbolic"} />
    </button>
  )
}
