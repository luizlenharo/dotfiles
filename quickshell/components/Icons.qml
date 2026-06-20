import QtQuick
import QtQuick.Shapes

// SVG-equivalent glyphs from the prototype, drawn via QtQuick.Shapes so we
// don't need raster icons. Set `glyph` to one of the supported names; the
// shape paints itself in `color` and fills the parent's bounds.
Item {
    id: root

    property string glyph: "speaker"
    property color color: "#ffffff"
    property real strokeWidth: 1.6

    readonly property var _filled: ["speaker", "speakerMute"]
    readonly property string _strokePath: {
        switch (glyph) {
        case "speaker":      return "M15.5 8.5a5 5 0 0 1 0 7 M18.5 5.5a9 9 0 0 1 0 13";
        case "speakerMute":  return "M16 9l5 6 M21 9l-5 6";
        case "wifi":         return "M5 11.5a11 11 0 0 1 14 0 M8 15a6.5 6.5 0 0 1 8 0";
        case "battery":      return "M2 8h17v8H2z M21 10v4";
        case "hamburger":    return "M4 7h16 M4 12h16 M4 17h16";
        case "sun":          return "M12 8a4 4 0 1 0 0 8a4 4 0 1 0 0-8 M12 2v2 M12 20v2 M4.93 4.93l1.41 1.41 M17.66 17.66l1.41 1.41 M2 12h2 M20 12h2 M4.93 19.07l1.41-1.41 M17.66 6.34l1.41-1.41";
        case "search":       return "M11 4a7 7 0 1 0 0 14a7 7 0 1 0 0-14 M16.5 16.5l3.5 3.5";
        case "chevronLeft":  return "M14 6l-6 6l6 6";
        case "chevronRight": return "M10 6l6 6l-6 6";
        case "lock":         return "M5 11h14v9H5z M8 11V8a4 4 0 0 1 8 0v3";
        case "sleep":        return "M21 13a8 8 0 1 1-9.9-9.9a7 7 0 0 0 9.9 9.9z";
        case "restart":      return "M21 12a9 9 0 1 1-3-6.7 M21 4v5h-5";
        case "logOut":       return "M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4 M16 17l5-5l-5-5 M21 12H9";
        case "power":        return "M12 3v9 M5.5 7.5a8 8 0 1 0 13 0";
        case "wifiDot":      return "";
        default: return "";
        }
    }
    readonly property string _fillPath: {
        switch (glyph) {
        case "speaker":     return "M11 5L6 9H3v6h3l5 4V5z";
        case "speakerMute": return "M11 5L6 9H3v6h3l5 4V5z";
        case "battery":     return "M4 10h7v4H4z";
        case "wifi":        return "M10.6 18a1.4 1.4 0 1 1 2.8 0a1.4 1.4 0 1 1 -2.8 0";
        case "wifiDot":     return "M11 18.5a1 1 0 1 1 2 0a1 1 0 1 1-2 0";
        case "bolt":        return "M13 2.5L6 13.2h4.2l-1.2 8.3L18 10.4h-4.6l1.4-7.9z";
        default: return "";
        }
    }

    Shape {
        anchors.fill: parent
        antialiasing: true
        preferredRendererType: Shape.CurveRenderer
        transform: Scale {
            xScale: root.width / 24
            yScale: root.height / 24
        }

        ShapePath {
            strokeColor: root.color
            fillColor: "transparent"
            strokeWidth: root.strokeWidth
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root._strokePath }
        }
        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillColor: root._fillPath.length > 0 ? root.color : "transparent"
            PathSvg { path: root._fillPath || "M0 0z" }
        }
    }
}
