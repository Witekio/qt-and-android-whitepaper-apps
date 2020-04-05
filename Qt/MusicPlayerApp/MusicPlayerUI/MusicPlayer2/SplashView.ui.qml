import QtQuick 2.12
import MusicPlayer2 1.0

// displays the splash screen in ScreenArea.qml when the app is started

Rectangle {
    id: rectangle

    color: Constants.qtDarkBlue

    Item {
        id: element
        height: musicLabel.height + playerLabel.height + qtIcon.height
        anchors.verticalCenterOffset: -72
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: musicLabel
            font {
                pixelSize: Constants.largeFontSize
                bold: true
                family: Constants.qtFontBold.name
            }
            color: Constants.qtGreen
            text: "MUSIC "
            verticalAlignment: Text.AlignBottom
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: playerLabel
            font {
                pixelSize: Constants.largeFontSize
                family: Constants.qtFontRegular.name
            }
            color: Constants.qtLightGrey
            text: "PLAYER"
            verticalAlignment: Text.AlignTop
            anchors.top: musicLabel.bottom
            anchors.topMargin: -12
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            id: byLabel
            font {
                pixelSize: Constants.smallFontSize
                family: Constants.qtFontRegular.name
            }
            text: "by"
            verticalAlignment: Text.AlignVCenter
            anchors.top: playerLabel.bottom
            anchors.topMargin: Constants.normalMargin
            color: Constants.qtLightGrey
            anchors.horizontalCenter: playerLabel.horizontalCenter
        }
        Image {
            id: qtIcon
            x: 149
            anchors.top: byLabel.bottom
            anchors.topMargin: Constants.wideMargin
            anchors.horizontalCenter: parent.horizontalCenter
            source: "assets/icon_qt.png"
        }
    }
}








/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_y:0}D{i:5;anchors_y:163}
}
 ##^##*/
