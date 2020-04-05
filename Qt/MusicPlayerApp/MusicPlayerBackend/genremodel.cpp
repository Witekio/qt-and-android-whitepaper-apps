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

#include "genremodel.h"

bool operator==(const Genre &genre1, const Genre &genre2)
{
    return (genre1.genre() == genre2.genre());
}

Genre::Genre()
    : m_genre("")
{}

Genre::Genre(QString genre)
    : m_genre(std::move(genre))
{}

QString Genre::genre() const
{
    return m_genre;
}

void Genre::setGenre(const QString &genre)
{
    if (m_genre != genre)
        m_genre = genre;
}

GenreModel::GenreModel(QObject *parent)
    : QAbstractListModel(parent)
{}

void GenreModel::addGenre(const Genre &genre)
{
    if (!ifGenreExists(genre)) {
        beginInsertRows(QModelIndex(), rowCount(), rowCount());
        m_genres << genre;
        endInsertRows();
        Q_EMIT nofGenresChanged();
    }
}

int GenreModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return m_genres.count();
}

Qt::ItemFlags GenreModel::flags(const QModelIndex &index) const
{
    return Qt::ItemIsEditable | QAbstractListModel::flags(index);
}

bool GenreModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    if (index.row() < 0 || index.row() > m_genres.count())
        return false;

    Genre &genre = m_genres[index.row()];
    if (role == GenreRole || role == Qt::EditRole)
        genre.setGenre(value.toString());

    m_genres[index.row()] = genre;
    Q_EMIT dataChanged(index, index);
    return true;
}

QVariant GenreModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= m_genres.count())
        return QVariant();

    const Genre &genre = m_genres[index.row()];
    if (role == GenreRole || role == Qt::DisplayRole)
        return genre.genre();

    return QVariant();
}

bool GenreModel::ifGenreExists(const Genre &genre) const
{
    return m_genres.contains(genre);
}

QHash<int, QByteArray> GenreModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[GenreRole] = "genre";
    return roles;
}
