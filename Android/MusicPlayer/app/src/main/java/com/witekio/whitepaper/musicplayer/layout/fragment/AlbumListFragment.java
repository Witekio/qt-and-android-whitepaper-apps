package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.navigation.Navigation;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.model.Album;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;
import com.witekio.whitepaper.musicplayer.layout.adapter.AlbumSectionAdapter;

import java.util.List;

public class AlbumListFragment extends AbstractListFragment {

    private static final String TAG = "ALBUM_LIST";

    @Override
    protected String getTitle() {
        return getString(R.string.all_albums);
    }

    @Override
    protected RecyclerView.Adapter getAdapter() {
        List<Album> albums = mSharedViewModel.getMediaModel().getAlbums();
        return new AlbumSectionAdapter(getContext(), albums, this::onAlbumSelected);
    }

    void onAlbumSelected(Album album) {
        View view = getView();
        if (view == null) {
            Log.e(TAG, "Can't navigate: View is null");
            return;
        }
        Bundle bundle = new Bundle();
        bundle.putSerializable(Filter.class.toString(), new Filter(FilterType.ALBUM, album.getName()));
        Navigation.findNavController(view).navigate(R.id.album_fragment, bundle);
    }
}
