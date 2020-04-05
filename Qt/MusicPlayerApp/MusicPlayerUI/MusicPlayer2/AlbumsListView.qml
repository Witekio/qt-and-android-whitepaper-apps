import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

ListView {
    clip: true

    // backend req
    model: Constants.simulationMode ? artistModel : filteredAlbumModel

    delegate: AlbumListItem {
        iconWidth: Constants.tinyCell
        albumLabelColor: Constants.qtLightGrey
        // backend req
        albumLabel: albumName
        artistLabel: artistName
        albumArtSource: albumArt
    }
    focus: true

    // the list uses sections, where the first character of artistName of artistModel
    // is used to define in which section the artist belongs
    section.property: "albumName"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: ListSectionHeader {
        sectionLabel: section
        // backendReq
        sectionCountLabel: Constants.simulationMode ? 999 : musicPlayerBackend.albumItemCount(
                                                          section)
    }
}
