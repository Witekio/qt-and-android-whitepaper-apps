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

#ifndef MUSICPLAYERBACKEND_H
#define MUSICPLAYERBACKEND_H

#include <QObject>
#include <QMediaPlayer>
#include <QFileInfoList>

class SongModel;
class GenreModel;
class ArtistModel;
class AlbumModel;
class QSortFilterProxyModel;

class MusicPlayerBackend : public QObject
{
    Q_OBJECT
public:
    enum ContentLevel { Artists, Albums, Songs };

    explicit MusicPlayerBackend(QObject *parent = nullptr);

    Q_INVOKABLE QObject *songModel() const;
    Q_INVOKABLE QObject *genreModel() const;
    Q_INVOKABLE QObject *artistModel() const;
    Q_INVOKABLE QObject *albumModel() const;

    Q_INVOKABLE QObject *filteredAlbumModel() const;
    Q_INVOKABLE QObject *filteredSongModel() const;
    Q_INVOKABLE QObject *filteredArtistModel() const;

    Q_INVOKABLE void sortFilteredModels();

    Q_INVOKABLE void setGenreFilter(const QVariant &genre);
    Q_INVOKABLE int albumItemCount(const QVariant &section) const;

    Q_INVOKABLE void setAlbumFilter(const QVariant &album);
    Q_INVOKABLE int artistItemCount(const QVariant &section) const;

    Q_INVOKABLE void setArtistFilter(const QVariant &artist);
    Q_INVOKABLE int songItemCount(const QVariant &section) const;

    Q_INVOKABLE void resetAllFilters();

    Q_INVOKABLE void addMusicFolder(const QUrl &musicFolder);

    Q_INVOKABLE void play(const QUrl &song);
    Q_INVOKABLE void pause();
    Q_INVOKABLE void resume();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void setVolume(qreal volumeValue);
    Q_INVOKABLE void setPosition(qint64 position);

Q_SIGNALS:
    void mediaPositionChanged(qint64 position);
    void stateChanged(QMediaPlayer::State state);

protected Q_SLOTS:
    void positionChanged(qint64 position);

protected:
    void parseMusicFolder(const QFileInfoList &folder, const QString &currentArtist = "Unknown artist", const QString &currentAlbum = "Unknown album", ContentLevel level = Artists);

private:
    QMediaPlayer *m_player;
    QMap<QUrl, QMediaPlayer *> m_mediaPlayers;
    SongModel *m_songModel;
    GenreModel *m_genreModel;
    QSortFilterProxyModel *m_filteredAlbumModel;
    QSortFilterProxyModel *m_filteredSongModel;
    QSortFilterProxyModel *m_filteredArtistModel;
    ArtistModel *m_artistModel;
    AlbumModel *m_albumModel;
    qint64 m_position;
};

#endif // MUSICPLAYERBACKEND_H
