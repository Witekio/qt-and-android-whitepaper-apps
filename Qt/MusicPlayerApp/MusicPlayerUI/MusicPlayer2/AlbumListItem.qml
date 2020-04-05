import QtQuick 2.12
import MusicPlayer2 1.0

// displays a list item in AlbumsView.ui.qml
Item {
    id: listItem

    property alias albumLabel: albumText.text
    property alias artistLabel: artistText.text
    property alias albumArtSource: albumArt.source
    property alias iconWidth: albumArt.width

    // for changing the text color, if the item is highlighted
    property alias albumLabelColor: albumText.color

    width: parent.width
    height: Constants.listItemHeight

    // Image container for album art
    // In album & song views it can be play icon to indicate that song is played
    // for play indicator to icon is smaller
    Item {
        id: iconContainer
        width: Constants.tinyCell
        height: Constants.tinyCell

        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: albumArt

            width: Constants.tinyCell
            height: width
            anchors.centerIn: parent

            source: "assets/icon_album.png"
        }
    }
    Text {
        id: albumText
        anchors.top: parent.top
        anchors.topMargin: 4
        verticalAlignment: Text.AlignVCenter
        anchors.left: iconContainer.right
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        elide: Text.ElideRight
    }
    Text {
        id: artistText
        color: Constants.qtLightGrey
        anchors.bottomMargin: 4
        anchors.bottom: parent.bottom
        anchors.topMargin: 4
        anchors.left: iconContainer.right
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        verticalAlignment: Text.AlignVCenter
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
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
            currentAlbum = albumText.text
            currentArtist = artistText.text
            currentAlbumArt = albumArt.source
            albumsListView.currentIndex = index
            if (!Constants.simulationMode)
                musicPlayerBackend.setAlbumFilter(albumText.text)
            stackView.push("AlbumSongsView.ui.qml", {
                               "viewLabel": albumText.text
                           })
        }
    }
}
