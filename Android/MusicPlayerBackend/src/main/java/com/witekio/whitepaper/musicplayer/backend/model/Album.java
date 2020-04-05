package com.witekio.whitepaper.musicplayer.backend.model;

import android.content.Context;
import android.graphics.Bitmap;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;
import java.util.function.Function;

public class Album implements Comparable<Album>, Filterable {

    private final String mName;
    private final String mArtistName;
    private final String mGenre;
    private final Function<Context, Bitmap> mArtCallback;

    public Album(@NotNull String name, @NotNull String artistName, @NotNull String genre, @NotNull Function<Context, Bitmap> artCallback) {
        mName = name;
        mArtistName = artistName;
        mGenre = genre;
        mArtCallback = artCallback;
    }

    public String getName() {
        return mName;
    }

    public String getArtistName() {
        return mArtistName;
    }

    public Bitmap getArt(Context context) {
        return mArtCallback.apply(context);
    }

    @Override
    public int compareTo(Album o) {
        return mName.compareTo(o.mName);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Album)) {
            return false;
        }
        Album album = (Album) o;
        return Objects.equals(mName, album.mName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mName);
    }

    @Override
    public String getField(FilterType filter) {
        switch (filter) {
            case ALBUM:
                return mName;
            case GENRE:
                return mGenre;
            case ARTIST:
                return mArtistName;
            default:
                throw new IllegalArgumentException("Filter " + filter + " doesn't exist for " + this.getClass());
        }
    }
}
