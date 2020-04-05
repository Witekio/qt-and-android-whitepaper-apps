package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.model.Album;
import com.witekio.whitepaper.musicplayer.layout.model.Section;

import java.util.Comparator;
import java.util.List;
import java.util.function.Consumer;

public class AlbumSectionAdapter extends SectionAdapter<Album> {

    private final Context mContext;
    private final Consumer<Album> mOnAlbumSelected;

    public AlbumSectionAdapter(Context context, List<Album> albums, Consumer<Album> onAlbumSelected) {
        super(albums);
        mContext = context;
        mOnAlbumSelected = onAlbumSelected;
    }

    @Override
    protected boolean isSameSection(Section lastSection, Album element) {
        return lastSection.getTitle().equals(getSectionLabel(element));
    }

    @Override
    protected String getSectionLabel(Album element) {
        return String.valueOf(element.getName().charAt(0));
    }

    @Override
    protected Comparator<? super Album> getComparator() {
        return (Comparator<Album>) (one, two) -> one.getName().compareTo(two.getName());
    }

    @Override
    protected BaseViewHolder getElementViewHolder(ViewGroup parent) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_album, parent, false);
        return new AlbumViewHolder(mContext, view, mOnAlbumSelected);
    }
}
