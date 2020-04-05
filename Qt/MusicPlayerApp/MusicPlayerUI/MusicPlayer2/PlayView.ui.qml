import QtQuick 2.10
import MusicPlayer2 1.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtMultimedia 5.12

// displays information about the selected song that is being played
// and controls for
//  - changing current playback position
//  - play/pause toggle button
//  - going to previous or next song in a selected category/album
//  - volume
//  - toggling shuffle ON/OFF
//  - toggling repeat ON/OFF
// PlayView uses ColumnLayout for laying out content, which are placed in panels (rectangles)
// inside panels the components are using anchors for layouts
Rectangle {
    id: playView
    property int headerHeight: Constants.smallButton + playView.width
                               > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
    // backend req
    property var view
    property bool isPreviousorNextClicked: false

    width: displayArea.currWidth
    height: displayArea.currHeight

    color: showLayout ? "firebrick" : Constants.qtDarkBlue

    Rectangle {
        id: contentRect
        color: showLayout ? "darkmagenta" : Constants.qtDarkBlue

        anchors.fill: parent

        anchors.right: parent.right
        anchors.rightMargin: playView.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.left: parent.left
        anchors.leftMargin: playView.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: playView.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.top: parent.top
        anchors.topMargin: playView.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin

        ColumnLayout {
            id: contentRectLayout

            width: parent.width
            height: parent.height
            spacing: playView.height
                     > Constants.breakpointHeight ? Constants.largeMargin : Constants.smallMargin

            Rectangle {
                id: headerPanel

                color: showLayout ? "darkviolet" : Constants.qtDarkBlue

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: headerHeight

                NavigationButton {
                    id: backButton
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    lightIconSource: "assets/icon_back_light.png"
                    darkIconSource: "assets/icon_back_dark.png"
                }
                Item {
                    id: labelGroup
                    width: nowLabel.width + playLabel.width
                    height: nowLabel.height
                    anchors.verticalCenter: backButton.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        id: nowLabel
                        font {
                            pixelSize: Constants.largeFontSize
                            bold: true
                            family: Constants.qtFontBold.name
                        }
                        color: Constants.qtGreen
                        text: "NOW "
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        elide: Text.ElideRight
                    }
                    Text {
                        id: playLabel
                        y: 0
                        font {
                            pixelSize: Constants.largeFontSize
                            family: Constants.qtFontRegular.name
                        }
                        color: Constants.qtLightGrey
                        text: qsTr("PLAYING")
                        anchors.left: nowLabel.right
                        anchors.leftMargin: 0
                        elide: Text.ElideRight
                    }
                }
            }

            Rectangle {
                id: albumArtPanel

                Layout.fillHeight: true
                Layout.preferredWidth: height

                color: showLayout ? "midnightblue" : Constants.qtDarkBlue

                Layout.alignment: Qt.AlignHCenter

                Image {
                    id: albumArt

                    height: parent.height
                    width: height

                    anchors.centerIn: parent

                    source: "assets/icon_album.png"
                }
            }
            Rectangle {
                id: songTextPane

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: songName.height + artistName.height + albumName.height

                color: showLayout ? "royalblue" : Constants.qtDarkBlue

                Layout.alignment: Qt.AlignHCenter

                Text {
                    id: songName
                    height: 40
                    width: parent.width
                    text: currentSong
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.horizontalCenter: songTextPane.horizontalCenter
                    anchors.bottom: artistName.top
                    anchors.bottomMargin: 0
                    fontSizeMode: Text.Fit
                    font {
                        pixelSize: playView.height > Constants.breakpointHeight ? Constants.largeFontSize : Constants.normalFontSize
                        family: Constants.qtFontBold.name
                        bold: true
                    }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Constants.qtGreen
                    elide: Text.ElideRight
                }
                Text {
                    id: artistName
                    height: 24
                    text: currentArtist
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenter: songTextPane.horizontalCenter
                    anchors.bottom: albumName.top
                    anchors.bottomMargin: 0
                    font {
                        pixelSize: playView.height > Constants.breakpointHeight ? Constants.normalFontSize : Constants.smallFontSize
                        family: Constants.qtFontBold.name
                        bold: true
                    }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Constants.qtLightGrey
                    elide: Text.ElideRight
                }
                Text {
                    id: albumName
                    height: 24
                    width: parent.width
                    text: currentAlbum
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    anchors.horizontalCenter: songTextPane.horizontalCenter
                    anchors.bottom: songTextPane.bottom
                    anchors.bottomMargin: 0
                    font {
                        pixelSize: playView.height > Constants.breakpointHeight ? Constants.normalFontSize : Constants.smallFontSize
                        family: Constants.qtFontRegular.name
                    }
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: Constants.qtLightGrey
                    elide: Text.ElideRight
                }
            }
            Rectangle {
                id: durationRow
                color: showLayout ? "orange" : Constants.qtDarkBlue

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: durationSlider.height + currPos.height
                Layout.alignment: Qt.AlignHCenter

                Slider {
                    id: durationSlider

                    height: 12
                    width: parent.width

                    from: 0
                    to: 1.0
                    stepSize: 0.1
                    value: 0.0

                    anchors.horizontalCenter: parent.horizontalCenter

                    rightPadding: 0
                    leftPadding: 0
                    bottomPadding: 0
                    topPadding: 0

                    background: Rectangle {
                        x: 0
                        y: durationSlider.availableHeight / 2 - height / 2
                        implicitWidth: 400
                        implicitHeight: 2
                        width: durationSlider.availableWidth
                        height: implicitHeight
                        radius: 0
                        color: Constants.qtLightGrey
                        anchors.bottom: parent.bottom
                    }

                    handle: Rectangle {
                        id: handle
                        radius: 0
                        width: durationSlider.visualPosition * parent.width
                        height: parent.height
                        color: Constants.qtGreen
                    }
                    Connections {
                        target: durationSlider
                        onMoved: {
                            musicPlayerBackend.setPosition(
                                        durationSlider.value * currentSongDuration * 1000)
                        }
                    }
                    Connections {
                        target: Constants.simulationMode ? null : musicPlayerBackend
                        onMediaPositionChanged: {
                            durationSlider.value = position / currentSongDuration
                        }
                    }
                }
                Text {
                    id: currPos
                    font {
                        pixelSize: Constants.smallFontSize
                        family: Constants.qtFontRegular.name
                    }
                    color: Constants.qtLightGrey
                    text: (Math.floor(
                               (durationSlider.value * currentSongDuration) / 60)) + ":"
                          + (((durationSlider.value * currentSongDuration) % 60).toFixed(0)
                             < 10 ? "0" + ((durationSlider.value
                                            * currentSongDuration) % 60).toFixed(
                                        0) : ((durationSlider.value * currentSongDuration)
                                              % 60).toFixed(0))
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: durationSlider.bottom
                    anchors.topMargin: 4
                    anchors.left: durationSlider.left
                    anchors.leftMargin: 0
                }
                Text {
                    id: totalDuration
                    font {
                        pixelSize: Constants.smallFontSize
                        family: Constants.qtFontRegular.name
                    }
                    color: Constants.qtLightGrey
                    text: (Math.floor(currentSongDuration / 60)) + ":"
                          + ((currentSongDuration % 60).toFixed(
                                 0) < 10 ? "0" + (currentSongDuration % 60).toFixed(
                                               0) : (currentSongDuration % 60).toFixed(
                                               0))
                    verticalAlignment: Text.AlignVCenter
                    anchors.top: durationSlider.bottom
                    anchors.topMargin: 4
                    anchors.right: durationSlider.right
                    anchors.rightMargin: 0
                }
            }
            Rectangle {
                id: buttonRow

                color: showLayout ? "peru" : Constants.qtDarkBlue

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: playView.width > Constants.breakpointWidth ? Constants.largeButton : Constants.normalButton
                Layout.alignment: Qt.AlignHCenter

                IconButton {
                    id: prevButton

                    height: playView.width > Constants.breakpointWidth ? Constants.normalButton : Constants.smallButton
                    width: playView.width
                           > Constants.breakpointWidth ? Constants.normalButton
                                                         * 0.75 : Constants.smallButton * 0.75

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    iconSource: "assets/icon_prev.png"

                    // backend req
                    Connections {
                        target: prevButton.buttonMouseArea
                        onClicked: {
                            if (view.currentIndex > 0) {
                                view.currentIndex -= 1

                                currentSong = view.currentItem.songLabel
                                currentArtist = view.currentItem.artistLabel
                                currentAlbumArt = view.currentItem.albumArtSource
                                currentAlbum = view.currentItem.albumLabel
                                currentSongDuration = view.currentItem.totalDuration
                                currentAudioFile = view.currentItem.audioFileUrl
                                isPlaying = true
                                isPreviousorNextClicked = true
                                if (!Constants.simulationMode)
                                    musicPlayerBackend.play(currentAudioFile)
                            }
                        }
                    }
                }

                IconToggleButton {
                    id: playButton
                    noBackground: true
                    height: playView.width > Constants.breakpointWidth ? Constants.largeButton : Constants.normalButton
                    width: playView.width
                           > Constants.breakpointWidth ? Constants.largeButton
                                                         * 0.75 : Constants.normalButton * 0.75

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    onIconSource: "assets/icon_play.png"
                    offIconSource: "assets/icon_pause.png"

                    state: "off"

                    Connections {
                        target: playButton.buttonMouseArea
                        // backend req
                        onClicked: {
                            if (!Constants.simulationMode) {
                                isPlaying ? musicPlayerBackend.pause(
                                                ) : musicPlayerBackend.resume()
                            }
                            isPlaying = isPlaying ? false : true
                            state = isPlaying ? "" : "off"
                        }
                    }
                }

                IconButton {
                    id: nextButton

                    height: playView.width > Constants.breakpointWidth ? Constants.normalButton : Constants.smallButton
                    width: playView.width
                           > Constants.breakpointWidth ? Constants.normalButton
                                                         * 0.75 : Constants.smallButton * 0.75

                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    iconSource: "assets/icon_next.png"

                    // backend req
                    Connections {
                        target: nextButton.buttonMouseArea
                        onClicked: {
                            if (view.currentIndex < (view.count - 1)) {
                                view.currentIndex += 1

                                currentSong = view.currentItem.songLabel
                                currentArtist = view.currentItem.artistLabel
                                currentAlbumArt = view.currentItem.albumArtSource
                                currentAlbum = view.currentItem.albumLabel
                                currentSongDuration = view.currentItem.totalDuration
                                currentAudioFile = view.currentItem.audioFileUrl
                                isPlaying = true
                                isPreviousorNextClicked = true
                                if (!Constants.simulationMode)
                                    musicPlayerBackend.play(currentAudioFile)
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: volumeRow

                color: showLayout ? "goldenrod" : Constants.qtDarkBlue

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: Constants.tinyCell
                Layout.alignment: Qt.AlignHCenter

                Slider {
                    id: volumeSlider
                    width: parent.width
                    height: 16
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    value: 0.5
                    padding: 0

                    Connections {
                        target: volumeSlider
                        // backend req
                        onValueChanged: {
                            if (!Constants.simulationMode) {
                                musicPlayerBackend.setVolume(
                                            Math.floor(
                                                volumeSlider.value * 100))
                            }
                        }
                    }

                    background: Rectangle {
                        id: track
                        y: volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: parent.width
                        implicitHeight: 2
                        width: volumeSlider.availableWidth
                        height: implicitHeight
                        color: Constants.qtLightGrey
                    }

                    handle: Rectangle {
                        id: volumeThumb
                        x: volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.availableHeight / 2 - height / 2
                        width: 4
                        height: 16
                        implicitWidth: 4
                        implicitHeight: 12
                        color: Constants.qtGreen
                        border.width: 0
                    }
                }
                Image {
                    id: iconVolumeDown
                    width: 16
                    height: 12
                    anchors.left: volumeSlider.left
                    anchors.leftMargin: 0
                    anchors.top: volumeSlider.bottom
                    anchors.topMargin: 4
                    source: "assets/icon_vol_down.png"
                }

                Image {
                    id: iconVolumeUp
                    width: 24
                    height: 18
                    anchors.top: volumeSlider.bottom
                    anchors.topMargin: 4
                    anchors.right: volumeSlider.right
                    anchors.rightMargin: 0
                    source: "assets/icon_vol_up.png"
                }
            }
            Rectangle {
                id: buttonRow2

                color: showLayout ? "sandybrown" : Constants.qtDarkBlue

                Layout.preferredWidth: parent.width
                Layout.preferredHeight: Constants.smallButton
                Layout.alignment: Qt.AlignHCenter

                //anchors.bottomMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : 0 //Constants.normalMargin
                IconToggleButton {
                    id: shuffleButton
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    noBackground: false
                    onIconSource: "assets/icon_shuffle_dark.png"
                    offIconSource: "assets/icon_shuffle_light.png"

                    state: "off"

                    Connections {
                        target: shuffleButton.buttonMouseArea
                        onClicked: {
                            isShuffling = isShuffling ? false : true
                            // backend req (state is already changed in IconToggleButton)
                            // state = isShuffling ? "" : "off"
                        }
                    }
                }

                IconToggleButton {
                    id: repeatButton
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    noBackground: false
                    onIconSource: "assets/icon_repeat_dark.png"
                    offIconSource: "assets/icon_repeat_light.png"

                    state: "off"

                    Connections {
                        target: repeatButton.buttonMouseArea
                        onClicked: {
                            isRepeating = isRepeating ? false : true
                            // backend req (state is already changed in IconToggleButton)
                            // state = isRepeating ? "" : "off"
                        }
                    }
                }
            }
        }
    }

    // backend req
    Connections {
        target: Constants.simulationMode ? null : musicPlayerBackend
        onStateChanged: {
            if (Constants.simulationMode)
                return

            if (state !== MediaPlayer.StoppedState)
                return

            if (isPreviousorNextClicked) {
                isPreviousorNextClicked = false
                return
            }

            if (isShuffling) {
                view.currentIndex = Math.floor(Math.random() * view.count)
            } else if (!isRepeating && (view.currentIndex < (view.count - 1))) {
                view.currentIndex += 1
            }

            if (!isRepeating) {
                currentSong = view.currentItem.songLabel
                currentArtist = view.currentItem.artistLabel
                currentAlbumArt = view.currentItem.albumArtSource
                currentAlbum = view.currentItem.albumLabel
                currentSongDuration = view.currentItem.totalDuration
                currentAudioFile = view.currentItem.audioFileUrl
            }

            isPlaying = true
            musicPlayerBackend.play(currentAudioFile)
        }
    }
}
