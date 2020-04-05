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

#ifndef SONGMODEL_H
#define SONGMODEL_H

#include <QString>
#include <QList>
#include <QUrl>
#include <utility>
#include <QAbstractListModel>

class Song
{
public:
    explicit Song();
    explicit Song(QUrl audioFile, QString albumName, QUrl art
                  , QString artistName, QString songName, qint64 duration, QString genre);

    QUrl audioFile() const;
    QString albumName() const;
    QUrl art() const;
    QString artistName() const;
    QString songName() const;
    qint64 duration() const;
    QString genre() const;

    void setAudioFile(const QUrl &audioFile);
    void setAlbumName(const QString &albumName);
    void setArt(const QUrl &art);
    void setArtistName(const QString &artistName);
    void setSongName(const QString &song);
    void setDuration(qint64 duration);
    void setGenre(const QString &genre);

private:
    QUrl m_audioFile;
    QString m_albumName;
    QUrl m_art;
    QString m_artistName;
    QString m_songName;
    qint64 m_duration;
    QString m_genre;
};

class SongModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int nofSongs READ rowCount NOTIFY nofSongsChanged)
public:
    enum SongsRoles {
        AudioFileRole = Qt::UserRole + 1,
        AlbumNameRole,
        AlbumArtRole,
        ArtistNameRole,
        SongNameRole,
        DurationRole,
        GenreRole
    };

    explicit SongModel(QObject *parent = nullptr);

    void addSong(const Song &song);

    int rowCount(const QModelIndex & parent = QModelIndex()) const override;

    Qt::ItemFlags flags(const QModelIndex &index) const override;

    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const override;

Q_SIGNALS:
    void nofSongsChanged();

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<Song> m_songs;
};

#endif // SONGMODEL_H
