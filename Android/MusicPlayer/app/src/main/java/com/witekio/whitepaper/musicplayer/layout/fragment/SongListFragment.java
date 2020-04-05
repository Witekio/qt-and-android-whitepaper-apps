package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.util.Log;

import androidx.navigation.Navigation;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.layout.adapter.SongSectionAdapter;

import java.io.IOException;
import java.util.List;

public class SongListFragment extends AbstractListFragment{

    private static final String TAG = "SONG_LIST";

    @Override
    protected String getTitle() {
        return getString(R.string.all_songs);
    }

    @Override
    protected RecyclerView.Adapter getAdapter() {
        List<Song> songs = mSharedViewModel.getMediaModel().getSongs();
        return new SongSectionAdapter(getContext(), mSharedViewModel.getListMediaPlayer(), songs, song -> onSongSelected(songs, song));
    }

    private void onSongSelected(List<Song> songs, Song song) {
        if (getView() == null) {
            Log.e(TAG, "View is null, can't navigate");
            return;
        }
        ListMediaPlayer mediaPlayer = mSharedViewModel.getListMediaPlayer();
        try {
            mediaPlayer.setPlaylist(songs, songs.indexOf(song));
            Navigation.findNavController(getView()).navigate(R.id.play_fragment);
        } catch (IOException | IllegalStateException e) {
            Log.e(TAG, "Song file cannot be read [" + (song == null ? "No song" : song.getUri()) + "] : " + e.getMessage());
        }
    }
}
