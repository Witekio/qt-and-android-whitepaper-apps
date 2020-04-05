import QtQuick 2.12
import MusicPlayer2 1.0

// displays a list item in GenresView.ui.qml
Item {
    id: rectangle

    property alias genreLabel: genreText.text
    property alias artistCountLabel: artistCountText.text
    property alias albumCountLabel: albumCountText.text

    width: parent.width
    height: Constants.listItemHeight

    Text {
        id: genreText
        text: label
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        anchors.right: albumCountText.left
        anchors.rightMargin: Constants.tinyMargin

        font {
            pixelSize: Constants.largeFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey
        elide: Text.ElideRight
    }
    Text {
        id: artistCountText

        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontBold.name
            bold: true
        }
        color: Constants.qtLightGrey

        text: "999"
        anchors.top: parent.top
        anchors.topMargin: 2
        horizontalAlignment: Text.AlignRight
        elide: Text.ElideRight
    }
    Text {
        id: albumCountText

        anchors.right: parent.right
        anchors.rightMargin: parent.width > Constants.breakpointWidth ? Constants.normalMargin : Constants.tinyMargin
        font {
            pixelSize: Constants.normalFontSize
            family: Constants.qtFontRegular.name
        }
        color: Constants.qtLightGrey

        text: "9999"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
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
            currentGenre = genreLabel
            genresListView.currentIndex = index
            // backend req
            if (!Constants.simulationMode)
                musicPlayerBackend.setGenreFilter(genreLabel)
            stackView.push("AlbumsView.ui.qml", {
                               "viewLabel": genreLabel
                           })
        }
    }
}
