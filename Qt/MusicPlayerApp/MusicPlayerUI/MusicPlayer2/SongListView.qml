import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

ListView {
    clip: true

    // backend req
    model: Constants.simulationMode ? albumModel : filteredSongModel // albumModel

    delegate: SongListItem {
        albumArtSource: albumArt
        songLabelColor: ListView.isCurrentItem ? Constants.qtGreen : Constants.qtLightGrey
        songLabel: songName
        artistLabel: artistName
        albumLabel: albumName
        totalDuration: duration
        audioFileUrl: Constants.simulationMode ? "" : audioFile

        // show play/pause icon only for selected song
        showPlayIcon: ListView.isCurrentItem ? 1 : 0
    }
    focus: true

    section.property: "artistName"
    section.criteria: ViewSection.FirstCharacter
    section.delegate: ListSectionHeader {
        sectionLabel: section
        sectionCountLabel: {
            if (Constants.simulationMode)
                9999
            else
                musicPlayerBackend.songItemCount(section)
        }
    }
    highlight: ListHighlight {}
}
