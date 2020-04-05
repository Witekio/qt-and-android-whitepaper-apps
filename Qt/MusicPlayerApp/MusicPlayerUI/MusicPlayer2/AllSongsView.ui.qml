import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

// displays a list of all songs
Rectangle {
    id: songsView

    property alias viewLabel: header.viewNameText

    width: displayArea.currWidth
    height: displayArea.currHeight

    color: showLayout ? "firebrick" : Constants.qtDarkBlue

    ViewHeader {
        id: header
        viewNameText: "ALL SONGS"
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

        SongListView {
            id: songsListView

            anchors.fill: parent
        }
    }
}
