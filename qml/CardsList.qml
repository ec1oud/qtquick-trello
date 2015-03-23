import QtQuick 2.4

ListView {
    id: cardsList
    anchors {
        fill: parent
        margins: margin
        topMargin: margin * 2 + listLabel.implicitHeight
    }
    spacing: 8
    model: ListModel { id: listModel }

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
console.log("inserting card " + i + card["name"] + " in list '" + name)
            listModel.insert(i, card)
            ++i
        }
    }

    delegate: Rectangle {
        width: cardsList.width
        height: 30
        radius: 10
        color: "beige"
        border.color: "brown"
        Text {
            id: cardLabel
            text: name
            x: margin
            y: margin
        }
    }
}
