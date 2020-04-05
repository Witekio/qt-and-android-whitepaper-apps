package com.witekio.whitepaper.musicplayer.backend.model;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

public class Artist implements Comparable<Artist>, Filterable {

    private final String mName;
    private final String mGenre;

    public Artist(@NotNull String name, @NotNull String genre) {
        mName = name;
        mGenre = genre;
    }

    public String getName() {
        return mName;
    }

    @Override
    public String getField(FilterType filter) {
        if (FilterType.GENRE.equals(filter)) {
            return mGenre;
        } else {
            throw new IllegalArgumentException("Filter " + filter + " doesn't exist for " + this.getClass());
        }
    }

    @Override
    public int compareTo(Artist o) {
        return mName.compareTo(o.mName);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Artist)) {
            return false;
        }
        Artist artist = (Artist) o;
        return Objects.equals(mName, artist.mName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(mName);
    }

}

