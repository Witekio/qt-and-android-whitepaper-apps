import QtQuick 2.12
import MusicPlayer2 1.0

// displays a grid item in ArtsitAlbumsView.ui.qml
Item {
    property alias albumLabel: albumText.text
    property alias albumArtSource: albumArt.source

    // cell size with margins between items
    height: albumsGridView.cellHeight
    width: albumsGridView.cellWidth

    Rectangle {
        id: cellContent

        // actual cell size (no margins)
        height: albumsGridView.width
                > Constants.breakpointWidth ? Constants.normalCell : Constants.smallCell
        width: height

        anchors.centerIn: parent

        color: Constants.qtDarkBlue
        border.width: 1
        border.color: Constants.qtLightGrey

        Image {
            id: albumArt
            source: ""

            // albumArt should not overlap cell borders
            width: parent.width - 4
            height: width

            anchors.centerIn: parent
        }

        Rectangle {
            id: textBackground
            height: 24
            width: parent.width - 2
            color: Constants.qtDarkBlue
            opacity: 0.5

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 1
        }
        Text {
            id: albumText
            font {
                pixelSize: Constants.smallFontSize
                family: Constants.qtFontRegular.name
            }
            text: "<N/A>"
            elide: Text.ElideRight
            verticalAlignment: Text.AlignBottom
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: textBackground.bottom
            anchors.bottomMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: Constants.tinyMargin
            anchors.right: parent.right
            anchors.rightMargin: Constants.tinyMargin
            color: Constants.qtLightGrey
        }
    }

    MouseArea {
        id: gridItemMouseArea
        anchors.fill: parent
        onClicked: {
            currentAlbum = albumText.text
            currentAlbumArt = albumArt.source

            albumsGridView.currentIndex = index
            // backend req
            if (!Constants.simulationMode)
                musicPlayerBackend.setAlbumFilter(albumText.text)
            stackView.push("AlbumSongsView.ui.qml", {
                               "viewLabel": currentAlbum
                           })
        }
    }
}
