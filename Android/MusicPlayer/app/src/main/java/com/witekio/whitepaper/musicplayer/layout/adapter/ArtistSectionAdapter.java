package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.model.Artist;
import com.witekio.whitepaper.musicplayer.layout.model.Section;

import java.util.Comparator;
import java.util.List;
import java.util.function.Consumer;

public class ArtistSectionAdapter extends SectionAdapter<Artist> {

    private final Consumer<Artist> mOnArtistSelected;
    private final MediaModel mMediaModel;

    public ArtistSectionAdapter(List<Artist> artists, MediaModel mediaModel, Consumer<Artist> onArtistSelected) {
        super(artists);
        mMediaModel = mediaModel;
        mOnArtistSelected = onArtistSelected;
    }

    @Override
    protected boolean isSameSection(Section lastSection, Artist element) {
        return lastSection.getTitle().equals(getSectionLabel(element));
    }

    @Override
    protected String getSectionLabel(Artist element) {
        return String.valueOf(element.getName().charAt(0));
    }

    @Override
    protected Comparator<? super Artist> getComparator() {
        return (Comparator<Artist>) (one, two) -> one.getName().compareTo(two.getName());
    }

    @Override
    protected BaseViewHolder getElementViewHolder(ViewGroup parent) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_artist, parent, false);
        return new ArtistViewHolder(mMediaModel, view, mOnArtistSelected);
    }
}
