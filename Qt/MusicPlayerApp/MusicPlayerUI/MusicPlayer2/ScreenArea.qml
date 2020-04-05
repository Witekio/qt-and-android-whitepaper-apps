import QtQuick 2.10
import MusicPlayer2 1.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.3
import io.qt 42.0

// displays Music Player and contains
//  - SplashView
//  - StackView for displaying app views
//  - has albumModel and artistModel for testing purposes
Rectangle {
    // is a playback on or paused
    property bool isPlaying: false

    // is shuffle toggled on/off
    property bool isShuffling: false

    // is shuffle toggled on/off
    property bool isRepeating: false

    // default size for display
    property int currWidth: 480
    property int currHeight: 854

    property string currentGenre: "<N/A>"
    property string currentAlbum: "<N/A>"
    property string currentAlbumArt: "<N/A>"
    property string currentArtist: "<N/A>"
    property string currentSong: "<N/A>"
    property url currentAudioFile: "<N/A>"
    property int currentSongPosition: 0
    property int currentSongDuration: 360

    // splash screen time out
    property int timeOutInterval: 1500

    // backend req
    // All songs model
    property var allSongModel: Constants.simulationMode ? undefined : MusicPlayerBackend.songModel()
    property var filteredSongModel: Constants.simulationMode ? undefined : MusicPlayerBackend.filteredSongModel()
    property var genreModel: Constants.simulationMode ? undefined : MusicPlayerBackend.genreModel()
    property var artistNameModel: Constants.simulationMode ? undefined : MusicPlayerBackend.artistModel()
    property var filteredArtistModel: Constants.simulationMode ? undefined : MusicPlayerBackend.filteredArtistModel()
    property var albumArtistModel: Constants.simulationMode ? undefined : MusicPlayerBackend.albumModel()
    property var filteredAlbumModel: Constants.simulationMode ? undefined : MusicPlayerBackend.filteredAlbumModel()
    property var musicPlayerBackend: Constants.simulationMode ? undefined : MusicPlayerBackend

    // set base state
    state: ""

    // Create and display SplashView
    // to-do: add transition from SpalshView to StackView
    SplashView {
        id: splash

        signal timeout

        // fill the whole display
        width: displayArea.currWidth
        height: displayArea.currHeight

        // Timer for showing splash
        Timer {
            interval: timeOutInterval
            running: true
            repeat: false
            onTriggered: {
                splash.visible = false
                splash.timeout()
                mainView.opacity = 1
                // Backend req
                fileDialog.open()
            }
        }
        // Show splash once it is done
        Component.onCompleted: visible
    }

    StackView {
        id: stackView

        anchors.fill: parent

        // Create MainView as initial item in the stack
        initialItem: mainView

        // define tranisitions for stack navigation
        // to-do: polish StackView animations
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 200
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 200
            }
        }

        MainView {
            id: mainView
            width: displayArea.currWidth
            height: displayArea.currHeight

            // opacity is 0 in order to show the splash
            opacity: 0
        }
    }

    // Backend req
    FileDialog {
        id: fileDialog
        selectFolder: true
        title: qsTr("Please add a folder with artists")
        folder: shortcuts.music

        onAccepted: {
            if (!Constants.simulationMode)
                musicPlayerBackend.addMusicFolder(fileDialog.fileUrls[0])
        }
        onRejected: {
            console.log(qsTr("No music files chosen"))
        }
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

