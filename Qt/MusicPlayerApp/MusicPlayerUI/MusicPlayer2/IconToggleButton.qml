import QtQuick 2.10
import MusicPlayer2 1.0

// a toggle button with ON and OFF states. used for
//  - play/pause button in PlayView.ui.qml
//  - shuffle ON/OFF in PlayView.ui.qml
//  - repeat ON/OFF in PlayView.ui.qml
//  - play/pause in NowPlaying button
Item {
    property bool noBackground: false

    property alias onIconSource: onIcon.source
    property alias offIconSource: offIcon.source

    property alias buttonMouseArea: mouseArea

    width: Constants.smallButton
    height: Constants.smallButton

    // button background for shuffle and repeat buttons
    Rectangle {
        id: buttonBackground
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        color: Constants.qtLightGrey
        border.color: Constants.qtLightGrey
        border.width: noBackground == true ? 0 : 1
        opacity: noBackground == true ? 0 : 1
    }

    // icon when the button is toggled ON
    Image {
        id: onIcon
        width: noBackground == true ? parent.width : 16
        height: noBackground == true ? parent.height : 16
        anchors.centerIn: parent
    }

    // icon when the button is toggled OFF
    Image {
        id: offIcon
        width: noBackground == true ? parent.width : 16
        height: noBackground == true ? parent.height : 16
        anchors.centerIn: parent
        opacity: 0
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
    }

    Connections {
        target: mouseArea
        onClicked: {
            if (state == "off") {
                state = ""
            } else {
                state = "off"
            }
        }
    }

    states: [
        State {
            name: "off"

            PropertyChanges {
                target: offIcon
                opacity: 1.0
            }
            PropertyChanges {
                target: onIcon
                opacity: 0.0
            }
            PropertyChanges {
                target: buttonBackground
                color: Constants.qtDarkBlue
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "off"

            ParallelAnimation {
                NumberAnimation {
                    properties: "opacity"
                    duration: 120
                }
                ColorAnimation {
                    to: Constants.qtLightGrey
                    duration: 120
                }
            }
        },
        Transition {
            from: "off"
            to: ""
            ParallelAnimation {
                NumberAnimation {
                    properties: "opacity"
                    duration: 120
                }
                ColorAnimation {
                    to: Constants.qtDarkBlue
                    duration: 120
                }
            }
        }
    ]
}

/*##^## Designer {
    D{i:0;height:56;width:56}
}
 ##^##*/

