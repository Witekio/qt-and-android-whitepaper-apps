package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.backend.model.Album;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.layout.adapter.AlbumSectionAdapter;

import java.util.List;

public class FilteredAlbumListFragment extends AlbumListFragment {

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        if (savedInstanceState == null) {
            savedInstanceState = getArguments();
        }
        if (savedInstanceState != null && savedInstanceState.containsKey(Filter.class.toString())) {
            Filter filter = (Filter) savedInstanceState.getSerializable(Filter.class.toString());
            mSharedViewModel.getMediaModel().setFilter(filter);
        }
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    protected String getTitle() {
        Filter filter = mSharedViewModel.getMediaModel().getFilter();
        if (filter == null){
            return super.getTitle();
        } else {
            return filter.getValue();
        }
    }

    @Override
    protected RecyclerView.Adapter getAdapter() {
        List<Album> albums = mSharedViewModel.getMediaModel().getFilteredAlbums();
        return new AlbumSectionAdapter(getContext(), albums, this::onAlbumSelected);
    }

}
