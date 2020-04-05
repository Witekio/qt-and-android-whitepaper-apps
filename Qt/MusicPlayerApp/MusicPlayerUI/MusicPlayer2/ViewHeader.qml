import QtQuick 2.12
import MusicPlayer2 1.0

Rectangle {
    id: headerRow
    property alias viewNameText: headerText.text

    color: showLayout ? "darkviolet" : Constants.qtDarkBlue

    anchors.left: parent.left
    anchors.leftMargin: 0
    anchors.top: parent.top
    anchors.topMargin: 0

    height: Constants.smallButton + 2
            * (parent.width
               > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin)
    width: parent.width

    z: 10

    NavigationButton {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin

        lightIconSource: "assets/icon_back_light.png"
        darkIconSource: "assets/icon_back_dark.png"
    }

    Text {
        id: headerText
        font {
            pixelSize: Constants.largeFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey
        horizontalAlignment: Text.AlignHCenter
        anchors.verticalCenter: backButton.verticalCenter

        anchors.left: backButton.right
        anchors.leftMargin: Constants.smallMargin
        anchors.right: parent.right
        anchors.rightMargin: Constants.wideMargin + 12

        elide: Text.ElideRight
    }
}
