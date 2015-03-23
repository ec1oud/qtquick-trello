import QtQuick 2.4
import QtQuick.Controls 1.2

Rectangle {
    id: root
    border.color: "black"
    radius: 10
    antialiasing: true

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

    states: [
        State {
            when: dropArea.containsDrag
            PropertyChanges {
                target: root
                border.color: "red"
                border.width: 3
            }
        }
    ]

    DropArea {
        id: dropArea
        anchors { fill: parent }
        onEntered: {
            console.log(root)
//            drag.accept(Qt.MoveAction)
        }
        onDropped: console.log("dropped " + drop + " " + drop.drag.source + " in " + root)
    }

    Text {
        id: listLabel
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
        spacing: 8
        model: ListModel { id: listModel }

        delegate: MouseArea {
            id: cardRoot
            width: cardsList.width
            height: 30
            // onClick: flip over to back side...
            drag.target: cardFront
            onParentChanged: console.log("parent" + parent)

            states: [
                State {
                    when: cardRoot.Drag.active
                    ParentChange {
                        target: cardRoot
                        parent: root.parent
                    }
                    PropertyChanges {
                        target: cardRoot
                        z: 1000
                    }
                }
            ]

            Drag.active: cardRoot.drag.active
            Drag.source: cardRoot
            Drag.hotSpot { x: width / 2; y: height / 2 }

            Rectangle {
                id: cardFront
                width: cardsList.width
                height: 30
                radius: 10
                color: "beige"
                border.color: "brown"

                Label {
                    id: cardLabel
                    text: name
                    anchors.fill: parent
                    anchors.margins: margin
                }
            }
        }
    }
}
