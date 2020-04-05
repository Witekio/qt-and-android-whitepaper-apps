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

#include "albummodel.h"
#include <utility>

bool operator==(const Album &album1, const Album &album2)
{
    return ((album1.albumName() == album2.albumName())
            && (album1.artistName() == album2.artistName()));
}

Album::Album(QString albumName, QString artistName, QUrl albumArt, QString genre)
    : m_artistName(std::move(artistName))
    , m_albumName(std::move(albumName))
    , m_albumArt(std::move(albumArt))
    , m_albumGenre(std::move(genre))
{}

QString Album::artistName() const
{
    return m_artistName;
}

QString Album::albumName() const
{
    return m_albumName;
}

QUrl Album::albumArt() const
{
    return m_albumArt;
}

QString Album::albumGenre() const
{
    return m_albumGenre;
}

void Album::setArtistName(const QString &artistName)
{
    if (m_artistName != artistName)
        m_artistName = artistName;
}

void Album::setAlbumName(const QString &albumName)
{
    if (m_albumName != albumName)
        m_albumName = albumName;
}

void Album::setAlbumArt(const QUrl &albumArt)
{
    if (m_albumArt != albumArt)
        m_albumArt = albumArt;
}

void Album::setAlbumGenre(const QString &genre)
{
    if (m_albumGenre != genre)
        m_albumArt = genre;
}

AlbumModel::AlbumModel(QObject *parent)
    : QAbstractListModel(parent)
{}

void AlbumModel::addAlbum(const Album &album)
{
    if (!ifAlbumExists(album)) {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        m_albums << album;
        endInsertRows();
        Q_EMIT nofAlbumsChanged();
    }
}

int AlbumModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_albums.count();
}

Qt::ItemFlags AlbumModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

bool AlbumModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() < 0 || index.row() > m_albums.count())
        return false;

    Album &album = m_albums[index.row()];
    if (role == ArtistNameRole || role == Qt::EditRole)
        album.setArtistName(value.toString());
    else if (role == AlbumNameRole)
        album.setAlbumName(value.toString());
    else if (role == AlbumArtRole)
        album.setAlbumArt(value.toUrl());
    else if (role == AlbumGenreRole)
        album.setAlbumGenre(value.toString());

    m_albums[index.row()] = album;
    Q_EMIT dataChanged(index, index);
    return true;
}

QVariant AlbumModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_albums.count())
        return QVariant();

    const Album &album = m_albums[index.row()];
    if (role == ArtistNameRole || role == Qt::DisplayRole)
        return album.artistName();
    if (role == AlbumNameRole)
        return album.albumName();
    if (role == AlbumArtRole)
        return album.albumArt();
    if (role == AlbumGenreRole)
        return album.albumGenre();

    return QVariant();
}

bool AlbumModel::ifAlbumExists(const Album &album) const
{
    return m_albums.contains(album);
}

QHash<int, QByteArray> AlbumModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ArtistNameRole] = "artistName";
    roles[AlbumNameRole] = "albumName";
    roles[AlbumArtRole] = "albumArt";
    roles[AlbumGenreRole] = "albumGenre";
    return roles;
}
