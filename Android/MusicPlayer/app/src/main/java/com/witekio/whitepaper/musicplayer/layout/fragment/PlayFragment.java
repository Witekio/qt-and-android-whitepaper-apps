package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.SeekBar;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.ViewModelProvider;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Song;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

public class PlayFragment extends BackFragment {

    private static final String TAG = "PLAY_FRAGMENT";
    private static final float VOLUME_INCREMENT = 100.f;

    private Timer mUpdateTimer;
    private final SimpleDateFormat mFormatter = new SimpleDateFormat("m:ss", Locale.getDefault());
    private ListMediaPlayer mMediaPlayer;

    private SeekBar mTiming;
    private TextView mCurrentTiming;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View layout = inflater.inflate(R.layout.play_layout, container, false);

        setupBack(layout);

        FragmentActivity currentActivity = getActivity();
        if (currentActivity == null) {
            Log.e(TAG, "Setup view failed : Activity is null");
            return layout;
        }

        mMediaPlayer = new ViewModelProvider(currentActivity).get(SharedViewModel.class).getListMediaPlayer();

        mTiming = layout.findViewById(R.id.timing);
        mTiming.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    mMediaPlayer.seekTo(progress);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                // nothing to do
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                // nothing to do
            }
        });

        mCurrentTiming = layout.findViewById(R.id.current_timing);

        View playPause = layout.findViewById(R.id.play);
        playPause.setActivated(mMediaPlayer.isPlaying());
        mMediaPlayer.setOnPlayingChanged(playPause::setActivated);
        playPause.setOnClickListener(view -> {
            if (mMediaPlayer.isPlaying()) {
                mMediaPlayer.pause();
            } else {
                mMediaPlayer.start();
            }
        });

        layout.findViewById(R.id.previous).setOnClickListener(view -> changeSong(() -> mMediaPlayer.previous()));

        layout.findViewById(R.id.next).setOnClickListener(view -> changeSong(() -> mMediaPlayer.next()));

        SeekBar volumeLevel = layout.findViewById(R.id.volume_level);
        volumeLevel.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                if (fromUser) {
                    mMediaPlayer.setVolume(progress / VOLUME_INCREMENT);
                }
            }

            @Override
            public void onStartTrackingTouch(SeekBar seekBar) {
                // nothing to do
            }

            @Override
            public void onStopTrackingTouch(SeekBar seekBar) {
                // nothing to do
            }
        });
        volumeLevel.setMax((int) VOLUME_INCREMENT);
        volumeLevel.setProgress((int) (VOLUME_INCREMENT * mMediaPlayer.getVolume()));

        mUpdateTimer = new Timer();
        mUpdateTimer.scheduleAtFixedRate(new TimerTask() {
            @Override
            public void run() {
                currentActivity.runOnUiThread(() -> updateTiming());
            }
        }, 0, 500);

        prepareOptionButton(layout, R.id.shuffle);
        prepareOptionButton(layout, R.id.repeat);

        return layout;
    }

    private void changeSong(SupplierWithIO songChanger) {
        try {
            songChanger.get();
            updateUi();
        } catch (IOException | IllegalStateException e) {
            Log.e(TAG, "Song file cannot be read ["
                    + (mMediaPlayer.hasCurrentSong() ? mMediaPlayer.getCurrentSong().getUri() : "No song")
                    + ": " + e.getMessage());
        }
    }

    private void prepareOptionButton(View layout, int viewId) {
        View button = layout.findViewById(viewId);
        button.setActivated(false);
        button.setOnClickListener(view -> view.setActivated(!view.isActivated()));
    }

    private void updateTiming() {
        int currentPosition = mMediaPlayer.getCurrentPosition();
        mTiming.setProgress(currentPosition);
        mCurrentTiming.setText(mFormatter.format(currentPosition));
    }

    private void updateUi() {

        Song song = mMediaPlayer.getCurrentSong();

        if (song == null) {
            Log.e(TAG, "Update UI failed : Song is null");
            return;
        }

        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Update UI failed : View is null");
            return;
        }

        TextView titleTv = currentView.findViewById(R.id.song_title);
        titleTv.setText(song.getTitle());
        TextView artistTv = currentView.findViewById(R.id.artist_name);
        artistTv.setText(song.getArtist());
        TextView albumTv = currentView.findViewById(R.id.album_name);
        albumTv.setText(song.getAlbum());

        Bitmap albumArt = song.getLargeArt(getContext());
        if (albumArt != null) {
            ImageView albumArtView = currentView.findViewById(R.id.album_art_view);
            albumArtView.setImageBitmap(albumArt);
        }

        mTiming.setMax(song.getDuration());
        TextView maxTimingTv = currentView.findViewById(R.id.max_timing);
        maxTimingTv.setText(mFormatter.format(song.getDuration()));

    }

    @Override
    public void onStart() {
        super.onStart();
        updateUi();
        mMediaPlayer.startIfNew();
    }

    @Override
    public void onDestroyView() {
        mUpdateTimer.cancel();
        super.onDestroyView();
    }

    @FunctionalInterface
    private interface SupplierWithIO {

        void get() throws IOException;
    }
}
