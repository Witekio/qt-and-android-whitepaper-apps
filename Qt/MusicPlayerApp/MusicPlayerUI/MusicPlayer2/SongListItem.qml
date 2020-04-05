import QtQuick 2.12
import MusicPlayer2 1.0

// displays a list item in AllSongsView.ui.qml
// contains:
//  - album art
//  - song name
//  - artist name
//  - duration
Item {
    id: listItem

    property alias artistLabel: artistText.text
    property alias albumArtSource: albumArt.source
    property alias songLabel: songText.text
    property alias songLabelColor: songText.color
    property url audioFileUrl

    // show play/pause icon only for the currentSong
    property alias showPlayIcon: playIcon.opacity

    property int totalDuration: 0
    property string albumLabel: "<N/A>"

    width: parent.width
    height: Constants.listItemHeight

    // container for displaying album art and isPlaying state
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
            anchors.fill: parent

            source: "assets/icon_album.png"
        }
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
            anchors.centerIn: parent
        }
    }
    Text {
        id: songText
        text: "<N/A>"
        anchors.top: parent.top
        anchors.topMargin: 4
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        verticalAlignment: Text.AlignVCenter
        anchors.left: iconContainer.right

        anchors.right: durationText.left
        anchors.rightMargin: Constants.tinyMargin
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
        text: "<N/A>"
        anchors.bottomMargin: 4
        anchors.bottom: parent.bottom
        anchors.topMargin: 4
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.left: iconContainer.right
        anchors.right: durationText.left
        anchors.rightMargin: Constants.tinyMargin
        verticalAlignment: Text.AlignVCenter
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        elide: Text.ElideRight
    }

    Text {
        id: durationText

        // width: 120
        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        color: Constants.qtLightGrey

        text: (Math.floor(totalDuration / 60)) + ":"
              + ((totalDuration % 60).toFixed(
                     0) < 10 ? "0" + (totalDuration % 60).toFixed(
                                   0) : (totalDuration % 60).toFixed(0))

        anchors.top: parent.top
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignRight
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
            currentArtist = artistText.text
            currentAlbumArt = albumArt.source
            currentAlbum = albumLabel
            currentSong = songText.text
            currentSongDuration = totalDuration
            songsListView.currentIndex = index
            currentAudioFile = audioFileUrl
            isPlaying = true
            // backend req
            if (!Constants.simulationMode)
                musicPlayerBackend.play(currentAudioFile)
            stackView.push("PlayView.ui.qml", {
                               "view": listItem.ListView.view
                           }) // was PlayView.ui.qml
        }
    }
}
