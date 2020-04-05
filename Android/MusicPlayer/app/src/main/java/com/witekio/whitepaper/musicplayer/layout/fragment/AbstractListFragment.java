package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;

abstract class AbstractListFragment extends BackFragment {

    SharedViewModel mSharedViewModel;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        mSharedViewModel = new ViewModelProvider(getActivity()).get(SharedViewModel.class);
        super.onCreate(savedInstanceState);
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        View layout = inflater.inflate(R.layout.generic_list_layout, container, false);

        setupBack(layout);

        TextView title = layout.findViewById(R.id.title);
        title.setText(getTitle());

        RecyclerView recyclerView = layout.findViewById(R.id.list_sections);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(getContext());
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setAdapter(getAdapter());
        return layout;
    }

    protected abstract String getTitle();

    protected abstract RecyclerView.Adapter getAdapter();

}
