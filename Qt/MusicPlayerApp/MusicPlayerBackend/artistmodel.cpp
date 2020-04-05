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

#include "artistmodel.h"
#include <utility>

bool operator==(const Artist &artist1, const Artist &artist2)
{
    return (artist1.artistName() == artist2.artistName());
}

Artist::Artist(QString artistName, QString genre)
    : m_artistName(std::move(artistName))
    , m_genre(std::move(genre))
{}

QString Artist::artistName() const
{
    return m_artistName;
}

QString Artist::genre() const
{
    return m_genre;
}

void Artist::setArtistName(const QString &artistName)
{
    if (m_artistName != artistName)
        m_artistName = artistName;
}

void Artist::setGenre(const QString &genre)
{
    if (m_genre != genre)
        m_genre = genre;
}

ArtistModel::ArtistModel(QObject *parent)
    : QAbstractListModel(parent)
{}

void ArtistModel::addArtist(const Artist &artist)
{
    if (!ifArtistExists(artist)) {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        m_artists << artist;
        endInsertRows();
        Q_EMIT nofArtistsChanged();
    }
}

int ArtistModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_artists.count();
}

Qt::ItemFlags ArtistModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

bool ArtistModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() < 0 || index.row() > m_artists.count())
        return false;

    Artist &artist = m_artists[index.row()];
    if (role == ArtistNameRole || role == Qt::EditRole)
        artist.setArtistName(value.toString());
    if (role == ArtistGenreRole)
        artist.setGenre(value.toString());

    m_artists[index.row()] = artist;
    Q_EMIT dataChanged(index, index);
    return true;
}

QVariant ArtistModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_artists.count())
        return QVariant();

    const Artist &artist = m_artists[index.row()];
    if (role == ArtistNameRole || role == Qt::DisplayRole)
        return artist.artistName();
    if (role == ArtistGenreRole)
        return artist.genre();
    return QVariant();
}

bool ArtistModel::ifArtistExists(const Artist &artist) const
{
    return m_artists.contains(artist);
}

QHash<int, QByteArray> ArtistModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ArtistNameRole] = "artistName";
    roles[ArtistGenreRole] = "artistGenre";
    return roles;
}
