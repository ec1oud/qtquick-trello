import QtQuick 2.4
import QtQuick.Controls 1.2

MouseArea {
    id: cardFront
    width: cardsList.width
    height: 30
    Rectangle {
        anchors.fill: parent
        color: "beige"
        radius: 5
        antialiasing: true

        Label {
            id: cardLabel
            text: name
            anchors.fill: parent
            anchors.margins: margin
        }
    }
}
