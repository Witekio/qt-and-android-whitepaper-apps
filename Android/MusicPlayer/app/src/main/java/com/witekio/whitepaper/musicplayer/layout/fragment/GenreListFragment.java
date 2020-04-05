package com.witekio.whitepaper.musicplayer.layout.fragment;

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
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;
import com.witekio.whitepaper.musicplayer.layout.adapter.GenreListAdapter;

import java.util.List;

public class GenreListFragment extends BackFragment {

    private static final String TAG = "GENRE_LIST";

    private SharedViewModel mSharedViewModel;

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        mSharedViewModel = new ViewModelProvider(getActivity()).get(SharedViewModel.class);
        View layout = inflater.inflate(R.layout.simple_list_layout, container, false);
        setupBack(layout);
        TextView title = layout.findViewById(R.id.title);
        title.setText(getString(R.string.all_genres));
        List<String> genres = mSharedViewModel.getMediaModel().getGenres();
        if (genres.isEmpty()) {
            return layout;
        }

        setupRecyclerView(layout, genres);
        return layout;
    }

    private void setupRecyclerView(View view, List<String> genres) {
        RecyclerView recyclerView = view.findViewById(R.id.item_list);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(linearLayoutManager);

        RecyclerView.Adapter adapter = new GenreListAdapter(genres, mSharedViewModel.getMediaModel(), this::onGenreSelected);
        recyclerView.setAdapter(adapter);
    }

    private void onGenreSelected(String genre) {

        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }

        Bundle bundle = new Bundle();
        bundle.putSerializable(Filter.class.toString(), new Filter(FilterType.GENRE, genre));
        Navigation.findNavController(currentView).navigate(R.id.filtered_album_list_fragment, bundle);

    }
}
