package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.backend.ListMediaPlayer;
import com.witekio.whitepaper.musicplayer.backend.model.Song;
import com.witekio.whitepaper.musicplayer.layout.model.Section;
import com.witekio.whitepaper.musicplayer.view.SongView;

import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.function.Consumer;

public class SongSectionAdapter extends SectionAdapter<Song> {

    private final SimpleDateFormat mFormatter = new SimpleDateFormat("m:ss", Locale.getDefault());

    private final Context mContext;
    private final ListMediaPlayer mMediaPlayer;
    private final Consumer<Song> mOnSongSelected;

    public SongSectionAdapter(Context context, ListMediaPlayer mediaPlayer, List<Song> songs, Consumer<Song> onSongSelected) {
        super(songs);
        mContext = context;
        mMediaPlayer = mediaPlayer;
        mOnSongSelected = onSongSelected;
    }

    @Override
    protected boolean isSameSection(@NonNull Section lastSection, Song song) {
        return lastSection.getTitle().equals(getSectionLabel(song));
    }

    @Override
    protected String getSectionLabel(Song song) {
        return String.valueOf(song.getArtist().charAt(0)).toUpperCase();
    }

    @Override
    protected Comparator<? super Song> getComparator() {
        return (Comparator<Song>) (one, two) -> {
            int result = one.getArtist().compareTo(two.getArtist());
            if (result == 0) {
                return one.getTitle().compareTo(two.getTitle());
            } else {
                return result;
            }
        };
    }

    @Override
    protected BaseViewHolder getElementViewHolder(ViewGroup parent) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_song, parent, false);
        if (view instanceof SongView) {
            return new SongViewHolder(mContext, (SongView) view, mMediaPlayer, mOnSongSelected, mFormatter);
        } else {
            throw new IllegalStateException("View class " + view.getClass() + " should be assignable to SongView");
        }
    }
}
