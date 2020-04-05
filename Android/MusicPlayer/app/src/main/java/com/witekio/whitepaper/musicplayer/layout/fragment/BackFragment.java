package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.view.View;

import androidx.fragment.app.Fragment;
import androidx.navigation.Navigation;

import com.witekio.whitepaper.musicplayer.R;

abstract class BackFragment extends Fragment {

    void setupBack(View layout) {
        View back = layout.findViewById(R.id.back_button);
        back.setOnClickListener(view -> Navigation.findNavController(view).popBackStack());
    }

}
