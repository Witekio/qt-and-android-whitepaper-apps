package com.witekio.whitepaper.musicplayer.backend;

import android.content.Context;
import android.media.MediaPlayer;
import android.util.Log;

import androidx.annotation.Nullable;

import com.witekio.whitepaper.musicplayer.backend.model.Song;

import org.jetbrains.annotations.NotNull;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

public class ListMediaPlayer {

    private static final String TAG = "MEDIA_PLAYER";

    private final Context mContext;
    private final MediaPlayer mMediaPlayer;

    private List<Song> mPlaylist = new ArrayList<>();
    private int mCurrentSongIndex;
    private float mVolume = 0.5f;
    private Consumer<Boolean> mOnPlayingChanged;

    public ListMediaPlayer(Context context) {
        mContext = context;
        mMediaPlayer = new MediaPlayer();
        setVolume(mVolume);
        mMediaPlayer.setOnCompletionListener(mp -> {
            try {
                next();
            } catch (IOException e) {
                Log.e(TAG, "Cannot play next song");
            }
        });
    }

    public void setPlaylist(@NotNull List<Song> playlist, int currentSongIndex) throws IOException {
        if (currentSongIndex < 0 || currentSongIndex >= playlist.size()) {
            throw new IllegalArgumentException("Inconsistent index " + currentSongIndex);
        }
        mPlaylist = playlist;
        mCurrentSongIndex = currentSongIndex;
        prepare();
    }

    @Nullable
    public Song getCurrentSong() {
        if (hasCurrentSong()) {
            return mPlaylist.get(mCurrentSongIndex);
        } else {
            return null;
        }

    }

    public boolean isCurrentSong(@NotNull Song song) {
        if (mPlaylist.isEmpty()) {
            return false;
        } else {
            return song.equals(mPlaylist.get(mCurrentSongIndex));
        }
    }

    public void startIfNew() {
        if (mMediaPlayer.getCurrentPosition() == 0) {
            start();
        }
    }

    public void start() {
        mMediaPlayer.start();
        if (mOnPlayingChanged != null) {
            mOnPlayingChanged.accept(isPlaying());
        }
    }

    public boolean isPlaying() {
        return mMediaPlayer.isPlaying();
    }

    public void pause() {
        mMediaPlayer.pause();
        if (mOnPlayingChanged != null) {
            mOnPlayingChanged.accept(isPlaying());
        }
    }

    public void next() throws IOException, IllegalStateException {
        if (mCurrentSongIndex == mPlaylist.size() - 1) {
            return;
        }
        mCurrentSongIndex++;
        prepare();
        start();
    }

    private void prepare() throws IOException, IllegalStateException {
        mMediaPlayer.reset();
        if (hasCurrentSong() && getCurrentSong() != null) {
            mMediaPlayer.setDataSource(mContext, getCurrentSong().getUri());
        }
        mMediaPlayer.prepare();
    }

    public void previous() throws IOException, IllegalStateException {
        if (mCurrentSongIndex == 0) {
            return;
        }
        mCurrentSongIndex--;
        prepare();
        start();
    }

    public void seekTo(int offset) {
        mMediaPlayer.seekTo(offset);
    }

    public int getCurrentPosition() {
        return mMediaPlayer.getCurrentPosition();
    }

    public void setVolume(float volume) {
        mVolume = volume;
        mMediaPlayer.setVolume(mVolume, mVolume);
    }

    public float getVolume() {
        return mVolume;
    }

    public void setOnPlayingChanged(Consumer<Boolean> onPlayingChanged) {
        mOnPlayingChanged = onPlayingChanged;
    }

    public boolean hasCurrentSong() {
        return mCurrentSongIndex > -1 && mCurrentSongIndex < mPlaylist.size();
    }
}
