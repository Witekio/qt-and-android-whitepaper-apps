import QtQuick 2.10
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0
import QtQuick.Controls 2.3

// displays a categories and play now button
Rectangle {
    id: mainView
    width: displayArea.currWidth
    height: displayArea.currHeight

    // backend req
    property bool isSorted: false

    property alias nowPlayingButton: nowPlayingButton

    color: showLayout ? "firebrick" : Constants.qtDarkBlue

    Rectangle {
        id: headerRow
        anchors.left: parent.left
        anchors.top: parent.top

        width: parent.width
        height: Constants.smallButton + 2
                * (parent.width
                   > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin)

        color: showLayout ? "darkviolet" : Constants.qtDarkBlue

        Item {
            id: labelGroup
            width: musicLabel.width + playerLabel.width
            height: 56
            anchors.verticalCenter: headerRow.verticalCenter
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
                anchors.left: parent.left
                anchors.leftMargin: 0
                elide: Text.ElideRight
            }
            Text {
                id: playerLabel
                y: 0
                font {
                    pixelSize: Constants.largeFontSize
                    family: Constants.qtFontRegular.name
                }
                color: Constants.qtLightGrey
                text: "PLAYER"
                anchors.left: musicLabel.right
                anchors.leftMargin: 0
                elide: Text.ElideRight
            }
        }
    }

    Rectangle {
        id: categoryGrid
        color: Constants.qtDarkBlue
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: headerRow.bottom
        anchors.topMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin

        width: parent.width

        // use grid for laying out category buttons
        Grid {
            id: gridLayout
            spacing: parent.width
                     > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
            anchors.horizontalCenter: parent.horizontalCenter

            columns: 2

            CategoryButton {
                id: genresButton
                label: "GENRES"
                // backend req
                countLabel: Constants.simulationMode ? 9 : genreModel.nofGenres

                Connections {
                    target: genresButton.buttonMouseArea
                    onClicked: {
                        if (!Constants.simulationMode) {
                            if (!isSorted) {
                                musicPlayerBackend.sortFilteredModels()
                                isSorted = true
                            }
                        }
                        stackView.push("GenresView.ui.qml", {
                                           "viewLabel": "ALL GENRES"
                                       })
                    }
                }
            }

            CategoryButton {
                id: artistsButton
                label: "ARTISTS"
                // backend req
                countLabel: Constants.simulationMode ? 9 : artistNameModel.nofArtists

                Connections {
                    target: artistsButton.buttonMouseArea
                    onClicked: {
                        if (!Constants.simulationMode) {
                            if (!isSorted) {
                                musicPlayerBackend.sortFilteredModels()
                                isSorted = true
                            }
                        }
                        stackView.push("ArtistsView.ui.qml", {
                                           "viewLabel": "ALL ARTISTS"
                                       })
                    }
                }
            }
            CategoryButton {
                id: albumsButton
                label: "ALBUMS"
                // backend req
                countLabel: Constants.simulationMode ? 99 : albumArtistModel.nofAlbums

                Connections {
                    target: albumsButton.buttonMouseArea
                    onClicked: {
                        if (!Constants.simulationMode) {
                            if (!isSorted) {
                                musicPlayerBackend.sortFilteredModels()
                                isSorted = true
                            }
                        }
                        stackView.push("AlbumsView.ui.qml", {
                                           "viewLabel": "ALL ALBUMS"
                                       })
                    }
                }
            }
            CategoryButton {
                id: songsButton
                label: "SONGS"
                // backend req
                countLabel: Constants.simulationMode ? 9999 : allSongModel.nofSongs

                Connections {
                    target: songsButton.buttonMouseArea
                    onClicked: {
                        if (!Constants.simulationMode) {
                            if (!isSorted) {
                                musicPlayerBackend.sortFilteredModels()
                                isSorted = true
                            }
                        }
                        stackView.push("AllSongsView.ui.qml", {
                                           "viewLabel": "ALL SONGS"
                                       })
                    }
                }
            }
        }
    }

    NowPlayingButton {
        id: nowPlayingButton

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
    }
}
