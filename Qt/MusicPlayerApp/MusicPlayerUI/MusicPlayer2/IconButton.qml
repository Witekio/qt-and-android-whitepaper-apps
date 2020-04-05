import QtQuick 2.10
import MusicPlayer2 1.0

// a button with an icon
// previous and next songs in PlayView.ui.qml
Item {
    id: iconButton

    property alias iconSource: icon.source
    property alias buttonMouseArea: iconButtonMouseArea

    width: parent.width
    height: parent.height

    state: ""

    Image {
        id: icon

        width: parent.width
        height: parent.width
        anchors.centerIn: parent
    }

    MouseArea {
        id: iconButtonMouseArea
        anchors.fill: parent
        onPressed: {
            parent.state = "pressed"
        }
        onReleased: {
            parent.state = "released"
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges {
                target: iconButton
                scale: 0.8
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "scale"
                duration: 100
            }
        },
        Transition {
            NumberAnimation {
                properties: "scale"
                duration: 100
            }
        }
    ]
}
