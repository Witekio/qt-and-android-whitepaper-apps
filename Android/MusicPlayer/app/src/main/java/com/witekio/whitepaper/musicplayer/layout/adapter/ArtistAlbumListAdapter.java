package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.model.Album;

import java.util.List;
import java.util.function.Consumer;

public class ArtistAlbumListAdapter extends RecyclerView.Adapter<ArtistAlbumListAdapter.ViewHolder> {

    private final Context mContext;
    private final List<Album> mAlbums;
    private final Consumer<Album> mOnAlbumSelected;

    public ArtistAlbumListAdapter(@NonNull Context context, @NonNull List<Album> albums, @NonNull Consumer<Album> onAlbumSelected) {
        mContext = context;
        mAlbums = albums;
        mOnAlbumSelected = onAlbumSelected;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_artist_album, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Album itemName = mAlbums.get(position);
        holder.bind(itemName);
    }

    @Override
    public int getItemCount() {
        return mAlbums.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        private final ImageView mAlbumArt;
        private final TextView mAlbumName;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            mAlbumArt = itemView.findViewById(R.id.album_art);
            mAlbumName = itemView.findViewById(R.id.album_name);
        }

        void bind(@NonNull Album album) {
            mAlbumName.setText(album.getName());
            Bitmap albumArt = album.getArt(mContext);
            if (albumArt == null) {
                mAlbumArt.setImageResource(R.drawable.icon_album);
            } else {
                mAlbumArt.setImageBitmap(albumArt);
            }
            itemView.setOnClickListener(view -> mOnAlbumSelected.accept(album));
        }
    }
}
