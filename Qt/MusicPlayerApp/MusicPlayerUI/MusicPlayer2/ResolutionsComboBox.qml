import QtQuick 2.10
import QtQuick.Controls 2.5
import MusicPlayer2 1.0

// displays a combobox for selecting different resolutions
ComboBox {
    id: control
    height: 30
    rightPadding: 0
    width: 140

    font {
        family: Constants.qtFontRegular.name
        pixelSize: Constants.smallFontSize
    }
    textRole: "key"

    // model for the resolutions
    //  - key = name in the combobox
    //  - width
    //  - height
    model: ListModel {
        id: resoModel
        ListElement {
            key: "5:4 (SXGA)"
            width: "1024"
            height: "1280"
        }
        ListElement {
            key: "8:5 (WXGA)"
            width: "800"
            height: "1280"
        }
        ListElement {
            key: "4:3 (XGA)"
            width: "768"
            height: "1024"
        }
        ListElement {
            key: "16:9 (HD720)"
            width: "720"
            height: "1280"
        }
        ListElement {
            key: "16:9 (WVGA)"
            width: "480"
            height: "854"
        }
        ListElement {
            key: "3:2"
            width: "480"
            height: "720"
        }
        ListElement {
            key: "4:3 (VGA)"
            width: "480"
            height: "640"
        }
    }
    onActivated: {
        displayArea.currWidth = resoModel.get(currentIndex).width
        displayArea.currHeight = resoModel.get(currentIndex).height
    }
}

/*##^## Designer {
    D{i:0;height:24;width:140}
}
 ##^##*/

