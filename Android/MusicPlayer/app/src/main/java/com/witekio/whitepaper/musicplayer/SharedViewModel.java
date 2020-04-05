package com.witekio.whitepaper.musicplayer;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.lifecycle.ViewModel;

import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;

public class SharedViewModel extends ViewModel {

    private MediaModel mMediaModel;
    private ListMediaPlayer mMediaPlayer;

    public void initialize(Context context) {
        mMediaPlayer = new ListMediaPlayer(context);
    }

    public void setMediaModel(@NonNull MediaModel mediaModel) {
        mMediaModel = mediaModel;
    }
    public MediaModel getMediaModel() {
        return mMediaModel;
    }

    public ListMediaPlayer getListMediaPlayer() {
        return mMediaPlayer;
    }
}
