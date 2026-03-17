import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./src/bar/bar"
import ControlCenterPopup, { toggleCC } from "./src/control-center/control-center-window"

app.start({
  css: style,
  main() {
    app.get_monitors().map((m) => {
      Bar(m)
      ControlCenterPopup(m)
    })
  },
  requestHandler(argv: string[], res: (response: string) => void) {
    if (argv[0] === "toggle-cc") {
      toggleCC()
      res("toggled")
    } else {
      res("unknown command")
    }
  },
})
