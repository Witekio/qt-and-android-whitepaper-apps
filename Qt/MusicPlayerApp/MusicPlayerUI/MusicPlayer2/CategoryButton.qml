import QtQuick 2.10
import MusicPlayer2 1.0

// a button for displaying & accessing a category in MainView.ui.qml
Rectangle {
    id: button
    property alias label: buttonText.text
    property alias countLabel: categoryCountText.text
    property alias buttonMouseArea: mouseArea

    color: Constants.qtDarkBlue
    border.color: Constants.qtDarkGrey
    border.width: 1

    width: categoryGrid.width
           > Constants.breakpointWidth ? Constants.largeCell : Constants.normalCell
    height: categoryGrid.width
            > Constants.breakpointWidth ? Constants.largeCell : Constants.normalCell

    Text {
        id: buttonText
        anchors.centerIn: parent
        font {
            pixelSize: Constants.largeFontSize
            bold: true
            family: Constants.qtFontBold.name
        }
        text: "GENRES"
        color: Constants.qtLightGrey
        elide: Text.ElideRight
    }

    Text {
        id: categoryCountText
        color: Constants.qtLightGrey
        anchors.right: parent.right
        anchors.rightMargin: Constants.tinyMargin
        anchors.top: parent.top
        anchors.topMargin: Constants.tinyMargin
        horizontalAlignment: Text.AlignRight
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
        }
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: parent.state = "Pressed"
        onReleased: parent.state = ""
    }

    states: [
        State {
            name: "Pressed"
            PropertyChanges {
                target: button
                scale: 0.95
            }
            PropertyChanges {
                target: button
                color: "red" // Constants.qtLightGrey
            }
            PropertyChanges {
                target: buttonText
                color: Constants.qtDarkBlue
            }
            PropertyChanges {
                target: categoryCountText
                color: Constants.qtDarkBlue
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "Pressed"

            ParallelAnimation {
                NumberAnimation {
                    properties: "scale"
                    duration: 120
                }
                ColorAnimation {
                    to: Constants.qtLightGrey
                    duration: 120
                }
            }
        },
        Transition {
            from: "Pressed"
            to: ""
            ParallelAnimation {
                NumberAnimation {
                    properties: "scale"
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
