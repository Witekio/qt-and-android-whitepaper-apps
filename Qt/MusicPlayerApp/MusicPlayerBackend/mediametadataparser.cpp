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

#include "mediametadataparser.h"
#include <utility>
#include <QMediaMetaData>
#include <QSortFilterProxyModel>

#include <QtDebug>

MediaMetaDataParser::MediaMetaDataParser(QObject *parent)
    : QMediaPlayer(parent)
    , m_backend()
    , m_artist()
    , m_album()
    , m_musicFile()
{
    connect(this,
            &QMediaPlayer::metaDataAvailableChanged,
            this,
            &MediaMetaDataParser::metaDataAvailable);
}

MediaMetaDataParser::MediaMetaDataParser(MusicPlayerBackend *backend,
                                         QString artist,
                                         QString album,
                                         const QString &musicFile,
                                         QObject *parent)
    : QMediaPlayer(parent)
    , m_backend(backend)
    , m_artist(std::move(artist))
    , m_album(std::move(album))
    , m_musicFile(musicFile)
{
#ifdef Q_OS_WIN
    setMedia(QMediaContent(QUrl("file:///" + musicFile)));
#else
    setMedia(QMediaContent(QUrl("file://" + musicFile)));
#endif

    setupNewSong();

    connect(this,
            &QMediaPlayer::metaDataAvailableChanged,
            this,
            &MediaMetaDataParser::metaDataAvailable);
}

void MediaMetaDataParser::metaDataAvailable(bool available)
{
    if (available) {
        /*
        qDebug() << "Duration" << this->duration() << metaData(QMediaMetaData::Duration);
        qDebug() << "Title" << metaData(QMediaMetaData::Title);
        qDebug() << "SubTitle" << metaData(QMediaMetaData::SubTitle);
        qDebug() << "Author" << metaData(QMediaMetaData::Author);
        qDebug() << "Comment" << metaData(QMediaMetaData::Comment);
        qDebug() << "Description" << metaData(QMediaMetaData::Description);
        qDebug() << "Category" << metaData(QMediaMetaData::Category);
        qDebug() << "Genre" << metaData(QMediaMetaData::Genre);
        qDebug() << "Year" << metaData(QMediaMetaData::Date);
        qDebug() << "Date" << metaData(QMediaMetaData::Year);
        qDebug() << "UserRating" << metaData(QMediaMetaData::UserRating);
        qDebug() << "Keywords" << metaData(QMediaMetaData::Keywords);
        qDebug() << "Language" << metaData(QMediaMetaData::Language);
        qDebug() << "Publisher" << metaData(QMediaMetaData::Publisher);
        qDebug() << "Copyright" << metaData(QMediaMetaData::Copyright);

        qDebug() << "Size" << metaData(QMediaMetaData::Size);
        qDebug() << "AlbumTitle" << metaData(QMediaMetaData::AlbumTitle);
        qDebug() << "AlbumArtist" << metaData(QMediaMetaData::AlbumArtist);
        qDebug() << "ContributingArtist" << metaData(QMediaMetaData::ContributingArtist);
        qDebug() << "Lyrics" << metaData(QMediaMetaData::Lyrics);
        qDebug() << "Mood" << metaData(QMediaMetaData::Mood);
        qDebug() << "TrackNumber" << metaData(QMediaMetaData::TrackNumber);
        qDebug() << "Composer" << metaData(QMediaMetaData::Composer);
        qDebug() << "CoverArtUrlSmall" << metaData(QMediaMetaData::CoverArtUrlSmall);
        qDebug() << "CoverArtUrlLarge" << metaData(QMediaMetaData::CoverArtUrlLarge);
        qDebug() << "CoverArtImage" << metaData(QMediaMetaData::CoverArtImage);
        qDebug() << "CoverArtUrlSmall" << metaData(QMediaMetaData::CoverArtUrlSmall);
        qDebug() << "PosterImage" << metaData(QMediaMetaData::PosterImage);
        qDebug() << "Subject" << metaData(QMediaMetaData::Subject);
        qDebug() << "PosterImage" << metaData(QMediaMetaData::PosterImage);
        qDebug() << "ThumbnailImage" << metaData(QMediaMetaData::ThumbnailImage);
*/

        qint64 duration = this->duration();
        if (duration > 0)
            m_newSong.setDuration(duration / 1000);
        else {
            duration = metaData(QMediaMetaData::Duration).toLongLong();
        }

        QString songName(metaData(QMediaMetaData::Title).toString());
        if (!songName.isEmpty())
            m_newSong.setSongName(songName);

        QString artist(metaData(QMediaMetaData::ContributingArtist).toString());
        if (!artist.isEmpty())
            m_newSong.setArtistName(artist);

        QString album(metaData(QMediaMetaData::AlbumTitle).toString());
        if (!album.isEmpty())
            m_newSong.setAlbumName(album);

        QUrl art(metaData(QMediaMetaData::CoverArtUrlLarge).toUrl());
        if (!art.isEmpty())
            m_newSong.setArt(art);

        QString genre(metaData(QMediaMetaData::Genre).toString());
        if (!genre.isEmpty())
            m_newSong.setGenre(genre);
    }

    // qDebug() << "Music file" << m_newSong.songName() << m_newSong.audioFile() << m_newSong.art() << m_newSong.genre()
    //          << m_newSong.duration() << m_newSong.artistName() << m_newSong.albumName();

    dynamic_cast<SongModel *>(m_backend->songModel())->addSong(m_newSong);
    dynamic_cast<GenreModel *>(m_backend->genreModel())->addGenre(Genre(m_newSong.genre()));
    dynamic_cast<ArtistModel *>(m_backend->artistModel())
        ->addArtist(Artist(m_newSong.artistName(), m_newSong.genre()));
    dynamic_cast<AlbumModel *>(m_backend->albumModel())
        ->addAlbum(Album(m_newSong.albumName(),
                         m_newSong.artistName(),
                         m_newSong.art(),
                         m_newSong.genre()));

    deleteLater();
}

void MediaMetaDataParser::setupNewSong()
{
    QString fileNameWithExtension(
        m_musicFile.right(m_musicFile.length() - m_musicFile.lastIndexOf('/') - 1));

    m_newSong.setSongName(fileNameWithExtension.left(fileNameWithExtension.indexOf('.')));

#ifdef Q_OS_WIN
    m_newSong.setAudioFile(QUrl("file:///" + m_musicFile));
#else
    m_newSong.setAudioFile(QUrl("file://" + m_musicFile));
#endif

    m_newSong.setArt(QUrl("qrc:/MusicPlayer2/assets/icon_album.png"));

    m_newSong.setGenre("Unknown genre");

    qint64 duration = this->duration();
    m_newSong.setDuration(duration / 1000);

    if (!m_artist.isEmpty())
        m_newSong.setArtistName(m_artist);

    if (!m_album.isEmpty())
        m_newSong.setAlbumName(m_album);
}
