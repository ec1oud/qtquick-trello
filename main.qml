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

    property string boardId: "550c1275568fdb3ffd27de9d" // testing board
    property string devKey: "c4ee8aed0832024bb0c28de3d1d265f8"
    property string token
    property real listWidth: width / 1.5
    property real margin: 8

    Settings {
        id: settings
        property alias boardId: root.boardId
        property alias devKey: root.devKey
        property alias token: root.token
    }

    Dialog {
        id: credentialsDialog

        GridLayout {
            columns: 2
            width: parent ? parent.width : implicitWidth
            Text { text: "Board ID" }
            TextField {
                id: boardIdField
                Layout.fillWidth: true
                text: boardId
            }

            Text { text: "Dev Key" }
            TextField {
                id: devKeyField
                Layout.fillWidth: true
                text: devKey
            }

            Text { text: "Token" }
            TextField {
                id: tokenField
                Layout.fillWidth: true
                text: token
            }
        }
        onAccepted: {
            root.boardId = boardIdField.text
            root.devKey = devKeyField.text
            root.token = tokenField.text
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
        delegate: CardsList {
            id: cardsList
            objectName: "CardsList " + name
            height: listsList.height
            width: listWidth
            Component.onCompleted: getCards(id)
        }
    }

    Component.onCompleted: {
        if (token && boardId && devKey)
            getLists()
        else
            credentialsDialog.visible = true
    }
}
