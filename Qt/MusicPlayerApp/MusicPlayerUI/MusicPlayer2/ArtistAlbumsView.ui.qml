import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

// displays the albums of the selected artist
// uses GridView
Rectangle {
    id: albumsView

    property alias viewLabel: header.viewNameText

    width: displayArea.currWidth
    height: displayArea.currHeight

    color: showLayout ? "firebrick" : Constants.qtDarkBlue

    ViewHeader {
        id: header
        viewNameText: "ARTIST NAME"
    }

    Rectangle {
        id: gridBackground

        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        anchors.topMargin: 0
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin
        anchors.bottomMargin: parent.width > Constants.breakpointWidth ? Constants.wideMargin : Constants.normalMargin

        color: Constants.qtDarkBlue

        GridView {
            id: albumsGridView
            clip: true

            // this is a bit of a hack, because GridView component's implementation
            // need to define grid's width by defining number of columns and cell sizes that INCLUDE the margins
            width: cellWidth * 3
            height: parent.height

            anchors.centerIn: parent
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            // Cell height and width includes margins. Actual item is smaller
            cellHeight: parent.width > Constants.breakpointWidth ? (Constants.normalCell + Constants.wideMargin) : (Constants.smallCell + Constants.normalMargin)
            cellWidth: parent.width > Constants.breakpointWidth ? (Constants.normalCell + Constants.wideMargin) : (Constants.smallCell + Constants.normalMargin)
            delegate: AlbumGridItem {
                albumLabel: albumName
                albumArtSource: albumArt
            }

            // backend req
            model: Constants.simulationMode ? artistModel : filteredAlbumModel // artistModel
        }
    }
}
