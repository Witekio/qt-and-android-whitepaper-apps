import QtQuick 2.10
import MusicPlayer2 1.0

// button for providing quick access to PlayView.ui.qml if song is selected
// album art provides a play/pause control song that is currently played
Rectangle {
    id: button
    color: Constants.qtDarkBlue
    border.color: isPlaying ? Constants.qtLightGrey : Constants.qtDarkGrey

    height: Constants.listItemHeight
    width: parent.width > Constants.breakpointWidth ? parent.width - 2
                                                      * Constants.wideMargin : parent.width - 2
                                                      * Constants.normalMargin

    enabled: currentSong != "<N/A>"

    Text {
        id: currSong
        text: currentSong
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.left: albumArtBackground.right
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: isPlaying ? Constants.qtGreen : Constants.qtDarkGrey
        elide: Text.ElideRight
    }

    Text {
        id: currArtist
        text: currentArtist
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        anchors.left: albumArtBackground.right
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        color: isPlaying ? Constants.qtLightGrey : Constants.qtDarkGrey
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onPressed: {
            parent.state = "pressed"
        }
        onReleased: {
            parent.state = ""
            stackView.push("PlayView.ui.qml")
        }
    }

    Image {
        id: albumArtBackground
        width: 56
        height: 56
        source: isPlaying ? "assets/icon_album.png" : ""

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin

        IconToggleButton {
            id: togglePlayButton
            anchors.centerIn: parent
            onIconSource: "assets/icon_play.png"
            offIconSource: "assets/icon_pause.png"
            noBackground: true
            width: 16
            height: 20
            opacity: isPlaying ? 1 : 0.25
            buttonMouseArea.onClicked: {
                isPlaying ? musicPlayerBackend.pause(
                                ) : musicPlayerBackend.resume()
                isPlaying = isPlaying ? false : true
                state = isPlaying ? "" : "off"
            }
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges {
                target: button
                scale: 0.98
            }
            PropertyChanges {
                target: button
                color: Constants.qtLightGrey
            }
            PropertyChanges {
                target: currSong
                color: Constants.qtDarkBlue
            }
            PropertyChanges {
                target: currArtist
                color: Constants.qtDarkBlue
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "pressed"

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
            from: "pressed"
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
