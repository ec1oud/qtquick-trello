import QtQuick 2.4
import QtQuick.Layouts 1.1

Rectangle {
    border.color: "darkgray"
    border.width: 3
    width: cardsList.width
    antialiasing: true
    signal done

    RowLayout {
        spacing: margin
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: margin
        }

        IconButton {
            glyph: ""
            onClicked: done()
        }

        IconButton {
            glyph: ""
            onClicked: done()
        }
    }
}
