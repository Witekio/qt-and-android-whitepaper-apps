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

#include "songmodel.h"
#include <utility>

Song::Song()
    : m_audioFile("")
    , m_albumName("")
    , m_art("")
    , m_artistName("")
    , m_songName("")
    , m_duration(0)
    , m_genre("")
{}

Song::Song(QUrl audioFile,
           QString albumName,
           QUrl art,
           QString artistName,
           QString songName,
           qint64 duration,
           QString genre)
    : m_audioFile(std::move(audioFile))
    , m_albumName(std::move(albumName))
    , m_art(std::move(art))
    , m_artistName(std::move(artistName))
    , m_songName(std::move(songName))
    , m_duration(duration)
    , m_genre(std::move(genre))
{}

QUrl Song::audioFile() const
{
    return m_audioFile;
}

QString Song::albumName() const
{
    return m_albumName;
}

QUrl Song::art() const
{
    return m_art;
}

QString Song::artistName() const
{
    return m_artistName;
}

QString Song::songName() const
{
    return m_songName;
}

qint64 Song::duration() const
{
    return m_duration;
}

QString Song::genre() const
{
    return m_genre;
}

void Song::setAudioFile(const QUrl &audioFile)
{
    if (m_audioFile != audioFile)
        m_audioFile = audioFile;
}

void Song::setAlbumName(const QString &albumName)
{
    if (m_albumName != albumName)
        m_albumName = albumName;
}

void Song::setArt(const QUrl &art)
{
    if (m_art != art)
        m_art = art;
}

void Song::setArtistName(const QString &artistName)
{
    if (m_artistName != artistName)
        m_artistName = artistName;
}

void Song::setSongName(const QString &song)
{
    if (m_songName != song)
        m_songName = song;
}

void Song::setDuration(qint64 duration)
{
    if (m_duration != duration)
        m_duration = duration;
}

void Song::setGenre(const QString &genre)
{
    if (m_genre != genre)
        m_genre = genre;
}

SongModel::SongModel(QObject *parent)
    : QAbstractListModel(parent)
{}

void SongModel::addSong(const Song &song)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    m_songs << song;
    endInsertRows();
    Q_EMIT nofSongsChanged();
}

int SongModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_songs.count();
}

Qt::ItemFlags SongModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

bool SongModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() < 0 || index.row() > m_songs.count())
        return false;

    Song &song = m_songs[index.row()];
    if (role == AudioFileRole)
        song.setAudioFile(value.toString());
    else if (role == AlbumNameRole)
        song.setAlbumName(value.toString());
    else if (role == AlbumArtRole)
        song.setArt(value.toUrl());
    else if (role == ArtistNameRole)
        song.setArtistName(value.toString());
    else if (role == SongNameRole)
        song.setSongName(value.toString());
    else if (role == DurationRole)
        song.setDuration(value.toInt());
    else if (role == GenreRole)
        song.setGenre(value.toString());
    m_songs[index.row()] = song;
    Q_EMIT dataChanged(index, index);
    return true;
}

QVariant SongModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_songs.count())
        return QVariant();

    const Song &song = m_songs[index.row()];
    if (role == AudioFileRole)
        return song.audioFile();
    if (role == AlbumNameRole)
        return song.albumName();
    if (role == AlbumArtRole)
        return song.art();
    if (role == ArtistNameRole)
        return song.artistName();
    if (role == SongNameRole)
        return song.songName();
    if (role == DurationRole)
        return song.duration();
    if (role == GenreRole)
        return song.genre();
    return QVariant();
}

QHash<int, QByteArray> SongModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[AudioFileRole] = "audioFile";
    roles[AlbumNameRole] = "albumName";
    roles[AlbumArtRole] = "albumArt";
    roles[ArtistNameRole] = "artistName";
    roles[SongNameRole] = "songName";
    roles[DurationRole] = "duration";
    roles[GenreRole] = "genre";
    return roles;
}
