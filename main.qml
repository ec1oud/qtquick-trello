import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import "qml"

Window {
    id: window
    visible: true

    width: 640
    height: 480
    color: "#112211"

    property string boardId: "550c1275568fdb3ffd27de9d" // testing board
    property string devKey: "c4ee8aed0832024bb0c28de3d1d265f8"
    property string token
    property real listWidth: width / 1.5
    property real margin: 8

    Settings {
        id: settings
        property alias boardId: window.boardId
        property alias devKey: window.devKey
        property alias token: window.token
    }

    Dialog {
        id: credentialsDialog
        title: "Log in to Trello"

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
            Text {
                text: 'Please get an <a href="xxx">access token</a> and paste it above'
                onLinkActivated: Qt.openUrlExternally("https://trello.com/1/authorize?key=" + devKeyField.text +
                         "&name=QtQuick+Trello+Client&expiration=never&response_type=token")
                Layout.columnSpan: 2
            }
        }
        onAccepted: {
            window.boardId = boardIdField.text
            window.devKey = devKeyField.text
            window.token = tokenField.text
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
                if (request.responseText.indexOf("invalid token") >= 0) {
                    credentialsDialog.setTitle("Please use a valid access token")
                    credentialsDialog.open()
                    tokenField.selectAll()
                }
                else
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
        lists.model = json
    }

    Flickable {
        id: listsFlick
        flickableDirection: Flickable.HorizontalFlick
        anchors.fill: parent
        anchors.margins: margin
        Row {
            id: listRow
            spacing: margin * 1.5
        }
        Instantiator {
            id: lists
            CardsList {
                parent: listRow
                objectName: "CardsList " + name
                height: listsFlick.height
                width: listWidth
                // Problem with Instantiator: model[index] is undefined at the time the delegate is instantiated
                property var delegateModel: lists.model[index]
                // Another difference compared to Repeater, ListView etc:
                // properties from the model are not automatically visible to the delegates
                name: delegateModel === undefined ? "" : delegateModel.name
                listId: delegateModel === undefined ? "" : delegateModel.id
            }
        }
    }

    Component.onCompleted: {
        if (token && boardId && devKey)
            getLists()
        else
            credentialsDialog.visible = true
    }

    FontLoader { id: iconFont; source: "qrc:/resources/fontawesome-webfont.ttf" }
}
