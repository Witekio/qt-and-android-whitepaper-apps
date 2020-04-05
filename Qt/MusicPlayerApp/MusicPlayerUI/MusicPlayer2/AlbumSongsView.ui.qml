import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

// displays songs of a selected album
//  - select an album in ArtistAlbums.ui.qml
//  - select an album in AlbumsView.ui.qml
Rectangle {
    id: singleAlbumView

    property alias viewLabel: header.viewNameText

    width: displayArea.currWidth
    height: displayArea.currHeight

    color: showLayout ? "firebrick" : Constants.qtDarkBlue

    clip: true

    ViewHeader {
        id: header
        viewNameText: currentAlbumName
    }

    Rectangle {
        id: listBackground

        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        anchors.topMargin: 0
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.bottomMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin

        color: Constants.qtDarkBlue
        clip: true

        ListView {
            id: singleAlbumlistView
            clip: true

            anchors.fill: parent

            // uses albumModel instead of artistModel
            // backend req
            model: Constants.simulationMode ? albumModel : filteredSongModel // albumModel

            delegate: SimpleSongListItem {

                // setting the text color for highlighted item
                labelColor: ListView.isCurrentItem ? Constants.qtGreen : Constants.qtLightGrey

                // show play/pause icon only for selected song
                showPlayIcon: ListView.isCurrentItem ? 1 : 0

                songLabel: songName
                totalDuration: duration

                // backend req
                artistLabel: artistName
                albumArtSource: albumArt
                audioFileUrl: Constants.simulationMode ? "" : audioFile
                albumLabel: albumName
            }

            // display albumArt and artistName in the header
            header: Rectangle {
                height: icon.height + artistText.height + Constants.normalMargin
                width: displayArea.currWidth

                anchors.horizontalCenter: parent.horizontalCenter

                color: Constants.qtDarkBlue

                Image {
                    id: icon
                    width: Constants.smallCell
                    height: Constants.smallCell
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    source: currentAlbumArt
                }
                Text {
                    id: artistText

                    font {
                        pixelSize: Constants.normalFontSize
                        family: Constants.qtFontBold.name
                        bold: true
                    }
                    color: Constants.qtLightGrey

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: icon.bottom
                    anchors.topMargin: Constants.tinyMargin
                    text: currentArtist
                    elide: Text.ElideRight
                }
            }
            highlight: ListHighlight {
            }
        }
    }
}
