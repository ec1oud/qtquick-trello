import QtQuick 2.4
import QtQuick.Controls 1.2
import QtGraphicalEffects 1.0

RectangularGlow {
    id: root
    color: "lightgreen"
    cornerRadius: 5
    glowRadius: 5
    property real margin: 8

    Rectangle {
        anchors.fill: parent
        color: "#001100"
        radius: 5
        antialiasing: true
    }

    function getCards(listId) {
        getJson("https://api.trello.com/1/lists/" + listId +
                "/cards?key=" + devKey +
                "&token=" + token, gotCards)
    }

    function gotCards(json) {
        console.log("got cards " + json)
        listModel.clear()
        for (var i in json) {
            var card = json[i]
            console.log("inserting card " + i + " '" + card["name"] + "' in list '" + name + "'")
            listModel.insert(i, card)
            ++i
        }
    }

    Text {
        id: listLabel
        color: "lightgreen"
        font.bold: true
        text: name
        x: margin
        y: margin
    }

    ListView {
        id: cardsList
        anchors {
            fill: parent
            margins: margin
            topMargin: margin * 2 + listLabel.implicitHeight
        }
        spacing: margin
        model: ListModel { id: listModel }

        delegate: Flipable {
            id: cardRoot
            width: cardsList.width
            height: flipped ? cardBack.implicitHeight : 30
            Behavior on height { NumberAnimation { duration: 400 } }

            property bool flipped: false

            front: CardFront { onClicked: flipped = true }
            back: CardBack {
                id: cardBack
                onDone: flipped = false
                implicitHeight: window.height * 0.7
                height: cardRoot.height
            }

            transform: Rotation {
                id: rotation
                origin.x: cardRoot.width / 2
                origin.y: cardRoot.height / 2
                axis.x: 0; axis.y: 1; axis.z: 0
                angle: 0
            }

            states: State {
                name: "back"
                PropertyChanges { target: rotation; angle: 180 }
                PropertyChanges { target: cardBack }
                when: cardRoot.flipped
            }

            transitions: Transition {
                NumberAnimation { target: rotation; property: "angle"; duration: 400 }
                NumberAnimation { target: cardRoot; property: "height"; duration: 400 }
            }
        }
    }
}
