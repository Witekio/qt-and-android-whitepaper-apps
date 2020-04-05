package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.model.Artist;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;

import java.util.function.Consumer;

class ArtistViewHolder extends BaseViewHolder {

    private final MediaModel mMediaModel;
    private final Consumer<Artist> mOnArtistSelected;
    private final TextView mArtistName;
    private final TextView mAlbumCount;
    private final TextView mSongCount;

    ArtistViewHolder(@NonNull MediaModel mediaModel, @NonNull View itemView, Consumer<Artist> onArtistSelected) {
        super(itemView);
        mMediaModel = mediaModel;
        mOnArtistSelected = onArtistSelected;
        mArtistName = itemView.findViewById(R.id.artist_name);
        mAlbumCount = itemView.findViewById(R.id.album_count);
        mSongCount = itemView.findViewById(R.id.song_count);
    }

    void bind(Object item) {
        if (item instanceof Artist) {
            Artist artist = (Artist) item;
            mArtistName.setText(artist.getName());

            mMediaModel.setFilter(FilterType.ARTIST, artist.getName());
            mAlbumCount.setText(String.valueOf(mMediaModel.countFilteredAlbums()));
            mSongCount.setText(String.valueOf(mMediaModel.countFilteredSongs()));

            itemView.setOnClickListener(view -> mOnArtistSelected.accept(artist));
        }
    }
}