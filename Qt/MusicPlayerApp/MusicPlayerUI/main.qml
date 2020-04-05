import QtQuick 2.12
import QtQuick.Window 2.12
import "qrc:/MusicPlayer2"
import MusicPlayer2 1.0

Window {
    visible: true
    width: Constants.width
    height: Constants.height
    title: qsTr("Music Player")

    MusicPlayer2 {
        anchors.fill: parent
    }
}
