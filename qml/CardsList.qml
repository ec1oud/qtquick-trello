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
