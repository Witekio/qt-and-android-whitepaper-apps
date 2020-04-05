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
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.view.SongView;

public class DashboardFragment extends Fragment {

    private static final String TAG = "DASHBOARD";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View layout = inflater.inflate(R.layout.dashboard_layout, container, false);

        MediaModel mediaModel = new ViewModelProvider(getActivity()).get(SharedViewModel.class).getMediaModel();
        assignCategoryButtonData(layout.findViewById(R.id.genres), mediaModel.countGenres(), getString(R.string.genres), view -> goToGenresList());
        assignCategoryButtonData(layout.findViewById(R.id.artists), mediaModel.countArtists(), getString(R.string.artists), view -> goToArtistsList());
        assignCategoryButtonData(layout.findViewById(R.id.albums), mediaModel.countAlbums(), getString(R.string.albums), view -> goToAlbumsList());
        assignCategoryButtonData(layout.findViewById(R.id.album_songs), mediaModel.countSongs(), getString(R.string.songs), view -> goSongsList());

        createCurrentSongView(layout.findViewById(R.id.current_playing_song));

        return layout;
    }

    private void createCurrentSongView(SongView songView) {

        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }

        FragmentActivity currentActivity = getActivity();
        if (currentActivity == null) {
            Log.e(TAG, "Navigation failed : Activity is null");
            return;
        }

        TextView songTitle = songView.findViewById(R.id.song_title);
        TextView artistName = songView.findViewById(R.id.song_artist);

        ListMediaPlayer mediaPlayer = new ViewModelProvider(currentActivity).get(SharedViewModel.class).getListMediaPlayer();
        if (mediaPlayer.hasCurrentSong()) {
            songView.setOnClickListener(view -> Navigation.findNavController(currentView).navigate(R.id.play_fragment));
            if (mediaPlayer.isPlaying()) {
                songView.setPlayingState(true);
                songView.setPausedState(false);
            } else {
                songView.setPlayingState(false);
                songView.setPausedState(true);
            }
            Song currentSong = mediaPlayer.getCurrentSong();
            songTitle.setText(currentSong.getTitle());
            artistName.setText(currentSong.getArtist());

            ImageView albumArtView = songView.findViewById(R.id.album_art_view);
            Bitmap albumArt = currentSong.getArt(getContext());
            if (albumArt != null) {
                albumArtView.setImageBitmap(albumArt);
            }
        } else {
            songView.setEnabled(false);
            songTitle.setText(R.string.n_a);
            artistName.setText(R.string.n_a);
            songView.setPlayingState(false);
            songView.setPausedState(false);
        }
    }

    private void assignCategoryButtonData(View view, int count, String label, View.OnClickListener onClickListener) {
        view.setOnClickListener(onClickListener);
        TextView countTv = view.findViewById(R.id.count);
        countTv.setText(String.valueOf(count));
        TextView labelTv = view.findViewById(R.id.label);
        labelTv.setText(label);
    }

    private void goSongsList() {
        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }
        Navigation.findNavController(currentView).navigate(R.id.song_list_fragment);
    }

    private void goToAlbumsList() {
        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }
        Navigation.findNavController(currentView).navigate(R.id.album_list_fragment);
    }

    private void goToArtistsList() {
        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }
        Navigation.findNavController(currentView).navigate(R.id.artist_list_fragment);
    }

    private void goToGenresList() {
        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }
        Navigation.findNavController(currentView).navigate(R.id.genre_list_fragment);
    }
}
