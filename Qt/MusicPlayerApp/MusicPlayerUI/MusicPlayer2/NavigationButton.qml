import QtQuick 2.10
import MusicPlayer2 1.0

// used for back stepping in stackView
// light and dark icons as a parameters
//   - close
//   - back
Rectangle {
    id: navigationButton

    property alias lightIconSource: lightIcon.source
    property alias darkIconSource: darkIcon.source
    property alias buttonMouseArea: iconButtonMouseArea

    width: Constants.smallButton
    height: Constants.smallButton

    color: Constants.qtDarkBlue
    border.width: 1
    border.color: Constants.qtDarkGrey

    state: ""

    // icon for base state and dark background
    Image {
        id: lightIcon
        width: Constants.smallButton - 2 * (Constants.tinyMargin)
        height: Constants.smallButton - 2 * (Constants.tinyMargin)
        anchors.centerIn: parent
        source: lightIconSource
        opacity: 1
    }

    // icon for pressed state and light background
    Image {
        id: darkIcon
        width: Constants.smallButton - 2 * (Constants.tinyMargin)
        height: Constants.smallButton - 2 * (Constants.tinyMargin)
        anchors.centerIn: parent
        source: darkIconSource
        opacity: 0
    }

    MouseArea {
        id: iconButtonMouseArea
        anchors.fill: navigationButton
        onPressed: {
            parent.state = "pressed"
        }

        // navigation starts after released signal
        onReleased: {
            parent.state = "released"

            // backend req
            if (stackView.depth <= 2) {
                if (!Constants.simulationMode)
                    musicPlayerBackend.resetAllFilters()
            }
            if (stackView.depth > 0) {
                stackView.pop()
            }
        }
    }

    states: [
        State {
            name: "pressed"
            PropertyChanges {
                target: navigationButton
                scale: 0.8
            }
            PropertyChanges {
                target: navigationButton
                color: Constants.qtLightGrey
            }
            PropertyChanges {
                target: lightIcon
                opacity: 0
            }
            PropertyChanges {
                target: darkIcon
                opacity: 1
            }
        },
        State {
            name: "released"
            PropertyChanges {
                target: navigationButton
                scale: 1.0
            }
            PropertyChanges {
                target: navigationButton
                color: Constants.qtDarkBlue
            }
            PropertyChanges {
                target: lightIcon
                opacity: 1
            }
            PropertyChanges {
                target: darkIcon
                opacity: 0
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
                    duration: 150
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 150
                }
                ColorAnimation {
                    to: Constants.qtLightGrey
                    duration: 150
                }
            }
        },
        Transition {
            from: "pressed"
            to: "released"
            ParallelAnimation {
                NumberAnimation {
                    properties: "scale"
                    duration: 150
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 150
                }
                ColorAnimation {
                    to: Constants.qtDarkBlue
                    duration: 150
                }
            }
        }

        /*,
        Transition {
            from: "released"
            to: ""
            ParallelAnimation{
                NumberAnimation {
                    properties: "scale"
                    duration: 100
                }
                NumberAnimation {
                    properties: "opacity"
                    duration: 100
                }
                ColorAnimation {
                    to: Constants.qtDarkBlue
                    duration: 100
                }
            }
        }*/
    ]
}
