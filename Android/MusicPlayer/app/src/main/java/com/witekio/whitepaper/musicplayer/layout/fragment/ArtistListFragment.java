package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.navigation.Navigation;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.model.Artist;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;
import com.witekio.whitepaper.musicplayer.layout.adapter.ArtistSectionAdapter;

public class ArtistListFragment extends AbstractListFragment {

    private static final String TAG = "ARTIST_LIST";

    @Override
    protected String getTitle() {
        return getString(R.string.all_artists);
    }

    @Override
    protected RecyclerView.Adapter getAdapter() {
        MediaModel mediaModel = mSharedViewModel.getMediaModel();
        return new ArtistSectionAdapter(mediaModel.getArtists(), mediaModel, this::onArtistSelected);
    }

    private void onArtistSelected(Artist artist) {

        View view = getView();
        if (view == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }

        Bundle bundle = new Bundle();
        bundle.putSerializable(Filter.class.toString(), new Filter(FilterType.ARTIST, artist.getName()));
        Navigation.findNavController(view).navigate(R.id.artist_filtered_album_list_fragment, bundle);

    }
}
