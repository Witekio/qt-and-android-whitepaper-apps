import QtQuick 2.12
import MusicPlayer2 1.0

// header used for separating the sections in the lists of the following views
//  - AlbumsView.ui.qml
//  - AllSongsView.ui.qml
//  - ArtistsView.ui.qml
Rectangle {
    id: rectangle

    property alias sectionLabel: sectionText.text
    property alias sectionCountLabel: sectionCountText.text

    width: parent.width
    height: Constants.listSectionHeight

    color: Constants.qtDarkGrey

    Text {
        id: sectionText
        text: "<N/A>"
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.smallFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey
        elide: Text.ElideRight
    }
    Text {
        id: sectionCountText
        text: qsTr("999")
        horizontalAlignment: Text.AlignRight
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.smallFontSize
            family: Constants.qtFontRegular.name
        }
        color: Constants.qtLightGrey
        elide: Text.ElideRight
    }
}
