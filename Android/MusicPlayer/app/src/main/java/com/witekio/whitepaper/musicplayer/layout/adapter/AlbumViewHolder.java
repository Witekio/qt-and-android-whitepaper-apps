package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.model.Album;

import java.util.function.Consumer;

class AlbumViewHolder extends BaseViewHolder {

    private final Context mContext;
    private final View mView;
    private final Consumer<Album> mOnAlbumSelected;

    private final TextView mAlbumName;
    private final TextView mArtistName;
    private final ImageView mAlbumArtView;

    public AlbumViewHolder(Context context, View itemView, Consumer<Album> onAlbumSelected) {
        super(itemView);
        mContext = context;
        mView = itemView;
        mOnAlbumSelected = onAlbumSelected;
        mAlbumName = itemView.findViewById(R.id.album_name);
        mArtistName = itemView.findViewById(R.id.album_artist);
        mAlbumArtView = itemView.findViewById(R.id.album_art_view);
    }

    @Override
    void bind(Object item) {
        if (item instanceof Album) {
            Album album = (Album) item;

            mAlbumName.setText(album.getName());
            mArtistName.setText(album.getArtistName());

            Bitmap albumArt = album.getArt(mContext);
            if (albumArt != null) {
                mAlbumArtView.setImageBitmap(albumArt);
            } else {
                mAlbumArtView.setImageResource(R.drawable.icon_album);
            }

            mView.setOnClickListener(view -> mOnAlbumSelected.accept(album));
        }
    }

}
