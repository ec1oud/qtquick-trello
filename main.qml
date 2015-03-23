import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import "qml"

Window {
    id: root
    visible: true

    width: 640
    height: 480

    property string token
    property string boardId: "550c1275568fdb3ffd27de9d"
    property string devKey: "c4ee8aed0832024bb0c28de3d1d265f8"
    property real listWidth: width / 1.5
    property real margin: 8

    Settings {
        id: settings
        property alias token: root.token
    }

    Dialog {
        id: tokenInputDialog
        ColumnLayout {
            id: column
            width: parent ? parent.width : 100
            Label {
                id: label
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
                text: "Please supply a token:"
            }
            TextField {
                id: answerField
                Layout.fillWidth: true
            }
        }
        onAccepted: {
            root.token = answerField.text
            getLists()
        }
    }

    function getJson(url, callback) {
        console.log("getJson " + url)
        var request = new XMLHttpRequest()
        request.open('GET', url)
        request.onreadystatechange = function(event) {
            if (request.readyState === XMLHttpRequest.DONE) {
                console.log(request.responseText)
                callback(JSON.parse(request.responseText))
            }
        }
        request.send()
    }

    function getLists() {
        getJson("https://api.trello.com/1/boards/" + boardId +
            "/lists?key=" + devKey +
            "&token=" + token, gotLists)
    }

    function gotLists(json) {
        console.log("got lists " + json)
        listsModel.clear()
        var col = 0
        for (var lidx in json) {
            var list = json[lidx]
            listsModel.insert(col, list)
            ++col
        }
    }

    ListView {
        id: listsList
        orientation: ListView.Horizontal
        model: ListModel { id: listsModel }
        anchors.fill: parent
        anchors.margins: margin
        spacing: margin
        delegate: Rectangle {
            height: listsList.height
            width: listWidth
            border.color: "black"
            radius: 10
            antialiasing: true

            Text {
                id: listLabel
                text: name
                x: margin
                y: margin
            }
            CardsList { id: cardsList }
            Component.onCompleted: cardsList.getCards(id)
        }
    }

    Component.onCompleted: {
        if (token)
            getLists()
        else
            tokenInputDialog.visible = true
    }
}
