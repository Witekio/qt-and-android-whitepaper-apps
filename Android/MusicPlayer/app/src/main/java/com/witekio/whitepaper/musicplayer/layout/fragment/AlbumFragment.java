package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.layout.adapter.AlbumListAdapter;

import java.io.IOException;
import java.util.List;

public class AlbumFragment extends BackFragment {

    private static final String TAG = "ALBUM";

    private SharedViewModel mSharedViewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        mSharedViewModel = new ViewModelProvider(getActivity()).get(SharedViewModel.class);
        if (savedInstanceState == null) {
            savedInstanceState = getArguments();
        }

        View layout = inflater.inflate(R.layout.album_layout, container, false);
        setupBack(layout);

        List<Song> songs;
        if (savedInstanceState == null || !savedInstanceState.containsKey(Filter.class.toString())) {
            songs = mSharedViewModel.getMediaModel().getSongs();
        } else {
            Filter filter = (Filter) savedInstanceState.getSerializable(Filter.class.toString());
            mSharedViewModel.getMediaModel().setFilter(filter);
            songs = mSharedViewModel.getMediaModel().getFilteredSongs();
        }
        if (songs.isEmpty()) {
            return layout;
        }

        setupHeader(layout, songs.get(0));
        setupRecyclerView(mSharedViewModel.getListMediaPlayer(), layout, songs);

        return layout;
    }

    private void setupRecyclerView(ListMediaPlayer mediaPlayer, View view, List<Song> songs) {
        RecyclerView recyclerView = view.findViewById(R.id.album_songs);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(linearLayoutManager);

        RecyclerView.Adapter adapter = new AlbumListAdapter(mediaPlayer, songs, song -> onSongSelected(songs, song));
        recyclerView.setAdapter(adapter);
    }

    private void setupHeader(View view, Song song) {
        TextView title = view.findViewById(R.id.title);
        title.setText(song.getAlbum());
        Bitmap albumArt = song.getLargeArt(getContext());
        if (albumArt != null) {
            ImageView albumArtView = view.findViewById(R.id.album_art_view);
            albumArtView.setImageBitmap(albumArt);
        }
        TextView artist = view.findViewById(R.id.artist_name);
        artist.setText(song.getArtist());
    }

    private void onSongSelected(List<Song> songs, Song song) {
        View view = getView();
        if (view == null) {
            Log.e(TAG, "Can't navigate : View is null");
            return;
        }
        ListMediaPlayer mediaPlayer = mSharedViewModel.getListMediaPlayer();
        try {
            mediaPlayer.setPlaylist(songs, songs.indexOf(song));
            Navigation.findNavController(view).navigate(R.id.play_fragment);
        } catch (IOException | IllegalStateException e) {
            Log.e(TAG, "Song file cannot be read [" + (song == null ? "No song" : song.getUri()) + "] : " + e.getMessage());
        }
    }
}
