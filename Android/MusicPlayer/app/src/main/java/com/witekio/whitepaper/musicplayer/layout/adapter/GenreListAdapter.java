package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;

import java.util.List;
import java.util.function.Consumer;

public class GenreListAdapter extends RecyclerView.Adapter<GenreListAdapter.ViewHolder> {

    private final List<String> mGenres;
    private final Consumer<String> mOnGenreSelected;
    private final MediaModel mMediaModel;

    public GenreListAdapter(List<String> genres, MediaModel mediaModel, Consumer<String> onGenreSelected) {
        mGenres = genres;
        mMediaModel = mediaModel;
        mOnGenreSelected = onGenreSelected;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_genre, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        holder.bind(mGenres.get(position));
    }

    @Override
    public int getItemCount() {
        return mGenres.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        private final TextView mGenreName;
        private final TextView mAlbumCount;
        private final TextView mArtistCount;

        ViewHolder(@NonNull View itemView) {
            super(itemView);
            mGenreName = itemView.findViewById(R.id.genre_name);
            mAlbumCount = itemView.findViewById(R.id.album_count);
            mArtistCount = itemView.findViewById(R.id.artist_count);
        }

        void bind(String genre) {
            mGenreName.setText(genre);

            mMediaModel.setFilter(FilterType.GENRE, genre);
            mAlbumCount.setText(String.valueOf(mMediaModel.countFilteredAlbums()));
            mArtistCount.setText(String.valueOf(mMediaModel.countFilteredArtists()));

            itemView.setOnClickListener(view -> mOnGenreSelected.accept(genre));
        }
    }
}
