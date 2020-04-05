import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import MusicPlayer2 1.0

// displays a list of genres
ListView {
    delegate: GenreListItem {
        // backend req
        genreLabel: Constants.simulationMode ? albumGenre : genre // albumGenre
        albumCountLabel: {
            if (Constants.simulationMode)
                999
            else {
                musicPlayerBackend.setGenreFilter(genreLabel)
                filteredAlbumModel.rowCount()
            }
        }
        artistCountLabel: {
            if (Constants.simulationMode)
                99
            else
                filteredArtistModel.rowCount()
        }
    }

    model: Constants.simulationMode ? artistModel : genreModel // artistModel
}
