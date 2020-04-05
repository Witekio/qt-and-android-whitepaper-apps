pragma Singleton

import QtQuick 2.10

QtObject {
    // Use the simulated backend
    readonly property bool simulationMode: false

    // size for AppView
    readonly property int width: 1200
    readonly property int height: 1310

    // small - large screen breakpoints
    readonly property int breakpointWidth: 480
    readonly property int breakpointHeight: 720

    // fonts
    readonly property FontLoader qtFontBold: QtFontBold {}
    readonly property FontLoader qtFontRegular: QtFontRegular {}

    readonly property FontLoader mySystemFont: FontLoader {
        name: "Arial"
    }

    readonly property font font: Qt.font({
                                             "family": mySystemFont.name,
                                             "pointSize": Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  "family": mySystemFont.name,
                                                  "pointSize": Qt.application.font.pixelSize * 1.6
                                              })

    // color definitions
    readonly property color qtDarkBlue: "#09102b"
    readonly property color qtMediumBlue: "#222840"
    readonly property color qtGreen: "#17a81a"
    readonly property color qtDarkGrey: "#3a4055"
    readonly property color qtLightGrey: "#cecfd5"

    // font size definitions
    readonly property int tinyFontSize: 12
    readonly property int smallFontSize: 18
    readonly property int normalFontSize: 24
    readonly property int largeFontSize: 36

    // margin definitions
    readonly property int tinyMargin: 8
    readonly property int smallMargin: 12
    readonly property int normalMargin: 24
    readonly property int largeMargin: 32
    readonly property int wideMargin: 60

    // item sizes
    readonly property int smallButton: 40
    readonly property int normalButton: 56
    readonly property int largeButton: 80

    readonly property int tinyCell: 56
    readonly property int smallCell: 120
    readonly property int normalCell: 200
    readonly property int largeCell: 260

    readonly property int listItemHeight: 80
    readonly property int listSectionHeight: 32
}
