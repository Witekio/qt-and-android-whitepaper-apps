package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.content.Context;
import android.graphics.Bitmap;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.view.SongView;

import java.text.SimpleDateFormat;
import java.util.function.Consumer;

class SongViewHolder extends BaseViewHolder {

    private final Context mContext;
    private final SongView mView;
    private final ListMediaPlayer mMediaPlayer;
    private final Consumer<Song> mOnSongSelected;
    private final SimpleDateFormat mFormatter;

    private final TextView mArtistName;
    private final TextView mSongTitle;
    private final TextView mSongDuration;
    private final ImageView mAlbumArtView;

    SongViewHolder(Context context, @NonNull SongView itemView, @NonNull ListMediaPlayer mediaPlayer, @NonNull Consumer<Song> OnSongSelected, @NonNull SimpleDateFormat formatter) {
        super(itemView);
        mContext = context;
        mView = itemView;
        mMediaPlayer = mediaPlayer;
        mOnSongSelected = OnSongSelected;
        mFormatter = formatter;
        mArtistName = itemView.findViewById(R.id.song_artist);
        mSongTitle = itemView.findViewById(R.id.song_title);
        mSongDuration = itemView.findViewById(R.id.song_duration);
        mAlbumArtView = itemView.findViewById(R.id.album_art_view);
    }

    void bind(Object item) {
        if (item instanceof Song) {
            Song song = (Song) item;

            mArtistName.setText(song.getArtist());
            mSongTitle.setText(song.getTitle());
            String duration = mFormatter.format(song.getDuration());
            mSongDuration.setText(duration);

            Bitmap albumArt = song.getArt(mContext);
            if (albumArt != null) {
                mAlbumArtView.setImageBitmap(albumArt);
            } else {
                mAlbumArtView.setImageResource(R.drawable.icon_album);
            }

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
