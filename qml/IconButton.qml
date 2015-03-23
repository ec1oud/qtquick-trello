import QtQuick 2.4
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

MouseArea {
    id: ma
    width: Math.max(icon.implicitWidth, Screen.pixelDensity * 7)
    height: icon.implicitHeight
    hoverEnabled: true
    property alias glyph: icon.text
    Text {
        id: icon
        font.family: iconFont.name
        font.pointSize: 18
        anchors.centerIn: parent
    }
    Glow {
        anchors.fill: icon
        radius: 8
        samples: 16
        color: "green"
        source: icon
        cached: true
        visible: ma.containsMouse
    }
}
