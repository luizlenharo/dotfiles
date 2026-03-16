import app from "ags/gtk4/app"
import style from "./style.scss"
import Bar from "./src/bar/bar"

app.start({
  css: style,
  main() {
    app.get_monitors().map(Bar)
  },
  requestHandler(argv: string[], res: (response: string) => void) {
    res("unknown command")
  },
})
