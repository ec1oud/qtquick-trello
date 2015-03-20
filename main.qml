import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Qt.labs.settings 1.0

Window {
    id: root
    visible: true

    property string token
    property string boardId: "550c1275568fdb3ffd27de9d"
    property string devKey: "c4ee8aed0832024bb0c28de3d1d265f8"

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
        listsList.model = json // ought to work, if only we had tried to make it this easy
        for (var lidx in json) {
            var list = json[lidx]
            console.log("list " + list["id"] + ":" + list["name"])
        }
    }

    ListView {
        id: listsList
        model: ListModel {
            ListElement {
                name: "fetching..."
            }
        }
        anchors.fill: parent
        delegate: Rectangle {
            height: 20
            width: listsList.width
            color: index % 2 ? "lightgrey" : "white"
            Text {
                text: index + " " + name
            }
        }
    }

    Component.onCompleted: {
        if (token)
            getLists()
        else
            tokenInputDialog.visible = true
    }
}
