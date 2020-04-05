import QtQuick 2.12
import MusicPlayer2 1.0

// displays artist information in ArtistsView.ui.qml
Item {
    id: rectangle
    property alias artistLabel: artistTextLabel.text
    property alias albumCountLabel: albumCountText.text
    property alias songCountLabel: songCountText.text

    width: parent.width
    height: Constants.listItemHeight

    Text {
        id: artistTextLabel
        text: "<N/A>"
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.right: songCountText.left
        anchors.rightMargin: Constants.tinyMargin

        font {
            pixelSize: Constants.largeFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey
        elide: Text.ElideRight
    }
    Text {
        id: albumCountText

        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey

        text: "-"
        anchors.top: parent.top
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }
    Text {
        id: songCountText

        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        color: Constants.qtLightGrey

        text: "-"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }

    Rectangle {
        id: separator
        color: Constants.qtDarkGrey
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 1
    }
    MouseArea {
        id: listItemMouseArea
        anchors.fill: parent
        onClicked: {
            currentArtist = artistTextLabel.text
            artistsListView.currentIndex = index
            // backend req
            if (!Constants.simulationMode)
                musicPlayerBackend.setArtistFilter(currentArtist)
            stackView.push("ArtistAlbumsView.ui.qml", {
                               "viewLabel": currentArtist
                           })
        }
    }
}
