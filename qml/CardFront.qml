import QtQuick 2.4
import QtQuick.Controls 1.2

MouseArea {
    id: cardFront

    // Properties to be set from the model
    property alias label: cardLabel.text

    width: cardsList.width
    height: 30

    Rectangle {
        anchors.fill: parent
        color: "beige"
        radius: 5
        antialiasing: true

        Label {
            id: cardLabel
            anchors.fill: parent
            anchors.margins: margin
        }
    }
}
