/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

#include "musicplayerbackend.h"
#include "albummodel.h"
#include "artistmodel.h"
#include "genremodel.h"
#include "mediametadataparser.h"
#include "songmodel.h"
#include <QDir>
#include <QMediaMetaData>
#include <QMediaPlayer>
#include <QSortFilterProxyModel>
#include <QtDebug>
#include <QtMath>

MusicPlayerBackend::MusicPlayerBackend(QObject *parent)
    : QObject(parent)
    , m_player(new QMediaPlayer(this))
    , m_songModel(new SongModel(this))
    , m_genreModel(new GenreModel(this))
    , m_filteredAlbumModel(new QSortFilterProxyModel(this))
    , m_filteredSongModel(new QSortFilterProxyModel(this))
    , m_filteredArtistModel(new QSortFilterProxyModel(this))
    , m_artistModel(new ArtistModel(this))
    , m_albumModel(new AlbumModel(this))
    , m_position(0)
{
    connect(m_player, &QMediaPlayer::positionChanged, this, &MusicPlayerBackend::positionChanged);
    connect(m_player, &QMediaPlayer::stateChanged, this, &MusicPlayerBackend::stateChanged);

    m_filteredAlbumModel->setSourceModel(m_albumModel);
    m_filteredAlbumModel->setSortRole(AlbumModel::AlbumNameRole);

    m_filteredSongModel->setSourceModel(m_songModel);
    m_filteredSongModel->setSortRole(AlbumModel::ArtistNameRole);

    m_filteredArtistModel->setSourceModel(m_artistModel);
    m_filteredArtistModel->setSortRole(ArtistModel::ArtistNameRole);
}

QObject *MusicPlayerBackend::songModel() const
{
    return m_songModel;
}

QObject *MusicPlayerBackend::genreModel() const
{
    return m_genreModel;
}

QObject *MusicPlayerBackend::artistModel() const
{
    return m_artistModel;
}

QObject *MusicPlayerBackend::albumModel() const
{
    return m_albumModel;
}

QObject *MusicPlayerBackend::filteredAlbumModel() const
{
    return m_filteredAlbumModel;
}

void MusicPlayerBackend::setGenreFilter(const QVariant &genre)
{
    m_filteredAlbumModel->setFilterRole(AlbumModel::AlbumGenreRole);
    m_filteredAlbumModel->setFilterFixedString(genre.toString());

    m_filteredArtistModel->setFilterRole(ArtistModel::ArtistGenreRole);
    m_filteredArtistModel->setFilterFixedString(genre.toString());
}

QObject *MusicPlayerBackend::filteredSongModel() const
{
    return m_filteredSongModel;
}

QObject *MusicPlayerBackend::filteredArtistModel() const
{
    return m_filteredArtistModel;
}

void MusicPlayerBackend::sortFilteredModels()
{
    m_filteredAlbumModel->sort(0);

    // Sorting based on artists does not work with sorting based on songs first
    m_filteredSongModel->setSortRole(SongModel::SongNameRole);
    m_filteredSongModel->sort(0);

    m_filteredSongModel->setSortRole(SongModel::ArtistNameRole);
    m_filteredSongModel->sort(0);

    m_filteredArtistModel->sort(0);
}

int MusicPlayerBackend::albumItemCount(const QVariant &section) const
{
    auto count(0);
    for (int index = 0; index < m_filteredAlbumModel->rowCount(); ++index) {
        if (m_filteredAlbumModel
                ->data(m_filteredAlbumModel->index(index, 0), AlbumModel::AlbumNameRole)
                .toString()
                .at(0)
            == section)
            ++count;
    }
    return count;
}

void MusicPlayerBackend::setAlbumFilter(const QVariant &album)
{
    m_filteredSongModel->setFilterRole(SongModel::AlbumNameRole);
    m_filteredSongModel->setFilterFixedString(album.toString());
}

int MusicPlayerBackend::artistItemCount(const QVariant &section) const
{
    auto count(0);
    for (int index = 0; index < m_filteredAlbumModel->rowCount(); ++index) {
        if (m_filteredAlbumModel
                ->data(m_filteredAlbumModel->index(index, 0), AlbumModel::ArtistNameRole)
                .toString()
                .at(0)
            == section)
            ++count;
    }
    return count;
}

void MusicPlayerBackend::setArtistFilter(const QVariant &artist)
{
    m_filteredAlbumModel->setFilterRole(AlbumModel::ArtistNameRole);
    m_filteredAlbumModel->setFilterFixedString(artist.toString());

    m_filteredSongModel->setFilterRole(SongModel::ArtistNameRole);
    m_filteredSongModel->setFilterFixedString(artist.toString());
}

int MusicPlayerBackend::songItemCount(const QVariant &section) const
{
    auto count(0);
    for (int index = 0; index < m_filteredSongModel->rowCount(); ++index) {
        if (m_filteredSongModel
                ->data(m_filteredSongModel->index(index, 0), SongModel::ArtistNameRole)
                .toString()
                .at(0)
            == section)
            ++count;
    }
    return count;
}

void MusicPlayerBackend::resetAllFilters()
{
    m_filteredSongModel->setFilterFixedString("");
    m_filteredAlbumModel->setFilterFixedString("");
    m_filteredArtistModel->setFilterFixedString("");
}

void MusicPlayerBackend::addMusicFolder(const QUrl &musicFolder)
{
#ifdef Q_OS_WIN
    // Remove extra / char (/C:/...)
    QDir folder(musicFolder.path().right(musicFolder.path().length() - 1));
#else
    QDir folder(musicFolder.path());
#endif
    parseMusicFolder(folder.entryInfoList(QDir::NoDotAndDotDot | QDir::Dirs | QDir::Files));
}

void MusicPlayerBackend::play(const QUrl &song)
{
    m_player->setMedia(QMediaContent(song));
    m_player->play();
}

void MusicPlayerBackend::pause()
{
    m_player->pause();
}

void MusicPlayerBackend::resume()
{
    m_player->play();
}

void MusicPlayerBackend::stop()
{
    m_player->stop();
}

void MusicPlayerBackend::setVolume(qreal volumeValue)
{
    m_player->setVolume(qFloor(volumeValue));
}

void MusicPlayerBackend::setPosition(qint64 position)
{
    m_player->setPosition(position);
}

void MusicPlayerBackend::positionChanged(qint64 position)
{
    if (qAbs(m_position - position) >= 1000)
        Q_EMIT mediaPositionChanged(position / 1000);
}

void MusicPlayerBackend::parseMusicFolder(const QFileInfoList &folder,
                                          const QString &currentArtist,
                                          const QString &currentAlbum,
                                          ContentLevel level)
{
    QDir currentDir;

    for (const QFileInfo &fileInfo : folder) {
        if (fileInfo.isFile()) {
            MediaMetaDataParser *mediaMetaDataParser(
                new MediaMetaDataParser(this, currentArtist, currentAlbum, fileInfo.filePath()));
            Q_UNUSED(mediaMetaDataParser);
        }
        if (fileInfo.isDir()) {
            currentDir.cd(fileInfo.filePath());
            switch (level) {
            case Artists:
                parseMusicFolder(currentDir.entryInfoList(QDir::NoDotAndDotDot | QDir::Dirs
                                                          | QDir::Files),
                                 fileInfo.fileName(),
                                 currentAlbum,
                                 Albums);
                break;
            case Albums:
                parseMusicFolder(currentDir.entryInfoList(QDir::NoDotAndDotDot | QDir::Files),
                                 currentArtist,
                                 fileInfo.fileName(),
                                 Songs);
                break;
            case Songs:
                break;
            }
        }
    }
}
