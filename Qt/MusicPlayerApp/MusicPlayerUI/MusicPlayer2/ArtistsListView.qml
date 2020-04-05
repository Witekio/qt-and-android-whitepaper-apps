import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

ListView {
    // backend req
    model: Constants.simulationMode ? artistModel : filteredArtistModel

    delegate: ArtistListItem {
        artistLabel: artistName

        // artist specific album and song counts comes from the back-end
        // backend req
        albumCountLabel: {
            if (Constants.simulationMode)
                9
            else {
                musicPlayerBackend.setArtistFilter(artistName)
                filteredAlbumModel.rowCount()
            }
        }
        songCountLabel: {
            if (Constants.simulationMode)
                99
            else
                filteredSongModel.rowCount()
        }
    }

    // the list uses sections, where the first character of artistName of artistModel
    // is used to define in which section the artist belongs
    section.property: "artistName"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: ListSectionHeader {
        sectionLabel: section
        // backend req
        sectionCountLabel: {
            if (Constants.simulationMode)
                99
            else
                musicPlayerBackend.artistItemCount(section)
        }
    }
}
