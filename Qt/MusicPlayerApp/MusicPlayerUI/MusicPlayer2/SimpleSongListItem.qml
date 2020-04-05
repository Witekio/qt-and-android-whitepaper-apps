import QtQuick 2.12
import MusicPlayer2 1.0

// displays a list item in AlbumSongsView.ui.qml
// no need to include album art or name as they are in the list header
// contains:
//  - song name
//  - duration
Item {
    id: listItem

    // backend req
    property string artistLabel
    property url albumArtSource
    property url audioFileUrl
    property string albumLabel: "<N/A>"

    property alias songLabel: songNameText.text
    property alias labelColor: songNameText.color

    // show play/pause icon only for currently selected song
    property alias showPlayIcon: playIcon.opacity

    // needed to covert duration from int to string
    property int totalDuration: 0

    width: parent.width
    height: Constants.listItemHeight

    Image {
        id: playIcon

        width: 16
        height: 16

        source: {
            // no playback indicator, if no song selected yet
            if (currentSong == "<N/A>") {
                source: ""
            } // when playback is ON show play icon, else show pause for currently selected song
            else {
                isPlaying ? "assets/icon_play.png" : "assets/icon_pause.png"
            }
        }

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
    }

    Text {
        id: songNameText
        color: Constants.qtLightGrey

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: playIcon.right
        anchors.leftMargin: isPlaying ? Constants.tinyMargin : (parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin)
        anchors.right: durationText.left
        anchors.rightMargin: Constants.tinyMargin

        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        verticalAlignment: Text.AlignVCenter
        text: qsTr("Item label")
        elide: Text.ElideRight
    }

    Text {
        id: durationText

        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        color: songNameText.color

        text: (Math.floor(totalDuration / 60)) + ":"
              + ((totalDuration % 60).toFixed(
                     0) < 10 ? "0" + (totalDuration % 60).toFixed(
                                   0) : (totalDuration % 60).toFixed(0))
        anchors.verticalCenter: parent.verticalCenter
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
            currentSong = songNameText.text
            currentSongDuration = totalDuration
            singleAlbumlistView.currentIndex = index
            isPlaying = true
            // backend req
            currentArtist = artistName
            currentAlbumArt = albumArt
            currentAlbum = albumName
            if (!Constants.simulationMode) {
                currentAudioFile = audioFile
                musicPlayerBackend.play(currentAudioFile)
            }
            stackView.push("PlayView.ui.qml", {
                               "view": listItem.ListView.view
                           }) // was PlayView.ui.qml
        }
    }
}
