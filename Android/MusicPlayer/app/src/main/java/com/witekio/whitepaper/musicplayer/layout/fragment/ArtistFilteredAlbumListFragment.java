package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.model.Album;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;
import com.witekio.whitepaper.musicplayer.layout.adapter.ArtistAlbumListAdapter;

import java.util.List;

public class ArtistFilteredAlbumListFragment extends BackFragment {

    private static final String TAG = "ALBUM_FILTERED";

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        SharedViewModel sharedViewModel = new ViewModelProvider(getActivity()).get(SharedViewModel.class);
        if (savedInstanceState == null) {
            savedInstanceState = getArguments();
        }

        View layout = inflater.inflate(R.layout.simple_list_layout, container, false);
        setupBack(layout);

        List<Album> albums;
        if (savedInstanceState == null || !savedInstanceState.containsKey(Filter.class.toString())) {
            albums = sharedViewModel.getMediaModel().getAlbums();
        } else {
            Filter filter = (Filter) savedInstanceState.getSerializable(Filter.class.toString());
            sharedViewModel.getMediaModel().setFilter(filter);
            albums = sharedViewModel.getMediaModel().getFilteredAlbums();
        }
        if (albums.isEmpty()) {
            return layout;
        }

        TextView title = layout.findViewById(R.id.title);
        title.setText(albums.get(0).getArtistName());

        setupRecyclerView(layout, albums);
        return layout;
    }

    private void setupRecyclerView(View view, List<Album> albums) {

        Context context = getContext();
        if (context == null) {
            Log.e(TAG, "RecyclerView setup failed: Context is null");
            return;
        }

        RecyclerView recyclerView = view.findViewById(R.id.item_list);
        RecyclerView.LayoutManager layoutManager = new GridLayoutManager(getContext(), 3);
        recyclerView.setLayoutManager(layoutManager);

        RecyclerView.Adapter adapter = new ArtistAlbumListAdapter(getContext(), albums, this::onAlbumSelected);
        recyclerView.setAdapter(adapter);

    }

    private void onAlbumSelected(Album album) {

        View view = getView();
        if (view == null) {
            Log.e(TAG, "Navigation failed: View is null");
            return;
        }

        Bundle bundle = new Bundle();
        bundle.putSerializable(Filter.class.toString(), new Filter(FilterType.ALBUM, album.getName()));
        Navigation.findNavController(view).navigate(R.id.album_fragment, bundle);

    }

}