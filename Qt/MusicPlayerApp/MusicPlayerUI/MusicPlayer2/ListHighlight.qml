import QtQuick 2.12
import MusicPlayer2 1.0

// displays a background for a list item highlight
Rectangle {
    width: parent.width
    height: Constants.listItemHeight

    color: Constants.qtMediumBlue

    Rectangle {
        width: 1
        height: parent.height
        color: Constants.qtLightGrey
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
    }
}
