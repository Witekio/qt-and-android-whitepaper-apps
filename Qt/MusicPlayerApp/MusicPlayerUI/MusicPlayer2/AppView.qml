import QtQuick 2.10
import MusicPlayer2 1.0
import QtQuick.Controls 2.3

// the view that contains
//  - ResolutionsComboBox for changing size of ScreenArea
//  - ScreenArea for displaying MusicPlayer2 app
//  - checkbox to toggle ON/OFF layout colors
Rectangle {
    id: homeView
    width: Constants.width
    height: Constants.height
    color: Constants.qtLightGrey

    property alias resolutionsList: resolutionsList
    property alias showLayout: showLayoutCheckbox.checked

    Text {
        id: aspectRatioLabel
        text: "Aspect ratio"
        anchors.left: parent.left
        anchors.leftMargin: Constants.tinyMargin
        anchors.top: parent.top
        anchors.topMargin: 12
        font {
            family: Constants.qtFontBold.name
            bold: true
            pixelSize: Constants.smallFontSize
        }
        elide: Text.ElideRight
    }

    // control for showing different resolutions and change them
    ResolutionsComboBox {
        id: resolutionsList
        height: 32
        rightPadding: 0
        anchors.top: aspectRatioLabel.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: Constants.smallMargin
    }

    Text {
        id: resolutionLabel
        text: "Resolution"
        anchors.top: resolutionsList.bottom
        anchors.topMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: Constants.tinyMargin
        font {
            family: Constants.qtFontBold.name
            bold: true
            pixelSize: Constants.smallFontSize
        }
        elide: Text.ElideRight
    }

    Text {
        id: currResolutionLabel
        text: displayArea.currHeight + " x " + displayArea.currWidth
        anchors.top: resolutionLabel.bottom
        anchors.topMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: Constants.smallMargin
        font {
            family: Constants.qtFontRegular.name
            pixelSize: Constants.smallFontSize
        }
    }

    // Create screen for the music player XXXXX
    ScreenArea {
        id: displayArea
        anchors.left: parent.left
        anchors.leftMargin: 160
        anchors.top: parent.top
        anchors.topMargin: 8
    }

    Text {
        id: layoutLabel
        text: "Layout"
        anchors.leftMargin: Constants.tinyMargin
        font.bold: true
        font.pixelSize: Constants.smallFontSize
        font.family: Constants.qtFontBold.name
        anchors.top: currResolutionLabel.bottom
        anchors.left: parent.left
        anchors.topMargin: 4
        elide: Text.ElideRight
    }

    // toggle ON/OFF showing the layout information
    CheckBox {
        id: showLayoutCheckbox
        text: qsTr("Visible")
        padding: 0
        rightPadding: 0
        leftPadding: 0
        bottomPadding: 0
        topPadding: 0
        anchors.left: parent.left
        anchors.leftMargin: Constants.smallMargin
        anchors.top: layoutLabel.bottom
        anchors.topMargin: 0
        font.pixelSize: Constants.smallFontSize
        font.family: Constants.qtFontBold.name

        checked: false
    }

    Image {
        id: qtLogoContainer
        width: Constants.smallCell
        fillMode: Image.PreserveAspectFit

        anchors.left: parent.left
        anchors.leftMargin: Constants.smallMargin
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Constants.smallMargin

        source: "assets/icon_builtWithQt.png"
    }
}
