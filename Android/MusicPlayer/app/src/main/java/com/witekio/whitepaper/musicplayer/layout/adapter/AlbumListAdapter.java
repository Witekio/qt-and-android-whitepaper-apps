package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.view.LayoutInflater;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.view.SongView;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.function.Consumer;

public class AlbumListAdapter extends RecyclerView.Adapter<AlbumListAdapter.ViewHolder> {

    private final SimpleDateFormat mFormatter = new SimpleDateFormat("m:ss", Locale.getDefault());

    private final ListMediaPlayer mMediaPlayer;
    private final List<Song> mSongs;
    private final Consumer<Song> mOnSongSelected;

    public AlbumListAdapter(ListMediaPlayer mediaPlayer, List<Song> songs, Consumer<Song> onSongSelected) {
        mMediaPlayer = mediaPlayer;
        mSongs = songs;
        mOnSongSelected = onSongSelected;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        SongView view = (SongView) LayoutInflater.from(parent.getContext()).inflate(R.layout.item_album_song, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        Song itemName = mSongs.get(position);
        holder.bind(itemName);
    }

    @Override
    public int getItemCount() {
        return mSongs.size();
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        private final SongView mView;
        private final TextView mSongTitle;
        private final TextView mSongDuration;

        ViewHolder(@NonNull SongView itemView) {
            super(itemView);
            mView = itemView;
            mSongTitle = mView.findViewById(R.id.song_title);
            mSongDuration =  mView.findViewById(R.id.song_duration);
        }

        void bind(Song song) {
            mSongTitle.setText(song.getTitle());

            String duration = mFormatter.format(song.getDuration());
            mSongDuration.setText(duration);

            mView.setOnClickListener(view -> mOnSongSelected.accept(song));
            if (mMediaPlayer.isCurrentSong(song)) {
                boolean isPlaying = mMediaPlayer.isPlaying();
                mView.setPlayingState(isPlaying);
                mView.setPausedState(!isPlaying);
            } else {
                mView.setPlayingState(false);
                mView.setPausedState(false);
            }
        }
    }
}
