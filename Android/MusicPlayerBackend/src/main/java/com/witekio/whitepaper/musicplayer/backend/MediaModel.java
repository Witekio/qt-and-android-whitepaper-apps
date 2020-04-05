package com.witekio.whitepaper.musicplayer.backend;

import com.witekio.whitepaper.musicplayer.backend.model.Album;
import com.witekio.whitepaper.musicplayer.backend.model.Artist;
import com.witekio.whitepaper.musicplayer.backend.model.Filter;
import com.witekio.whitepaper.musicplayer.backend.model.FilterType;
import com.witekio.whitepaper.musicplayer.backend.model.Filterable;
import com.witekio.whitepaper.musicplayer.backend.model.Song;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class MediaModel {

    private final List<Song> mSongs = new ArrayList<>();
    private final List<String> mGenres = new SetArrayList<>();
    private final List<Artist> mArtists = new SetArrayList<>();
    private final List<Album> mAlbums = new SetArrayList<>();

    private final Object mLocker = new Object();

    private Filter mFilter;

    public List<Song> getSongs() {
        return mSongs;
    }

    public int countSongs() {
        return mSongs.size();
    }

    public List<Song> getFilteredSongs() {
        return getFilteredElements(mSongs);
    }

    public long countFilteredSongs() {
        return countFilteredElements(mSongs);
    }

    public List<String> getGenres() {
        return mGenres;
    }

    public int countGenres() {
        return mGenres.size();
    }

    public List<Artist> getArtists() {
        return mArtists;
    }

    public int countArtists() {
        return mArtists.size();
    }

    public long countFilteredArtists() {
        return countFilteredElements(mArtists);
    }

    public List<Album> getAlbums() {
        return mAlbums;
    }

    public int countAlbums() {
        return mAlbums.size();
    }

    public List<Album> getFilteredAlbums() {
        return getFilteredElements(mAlbums);
    }

    public long countFilteredAlbums() {
        return countFilteredElements(mAlbums);
    }

    public void setFilter(FilterType filter, String value) {
        mFilter = new Filter(filter, value);
    }

    public void setFilter(Filter filter) {
        mFilter = filter;
    }

    private <T extends Filterable> long countFilteredElements(List<T> items) {
        return getFilteredStream(items).count();
    }

    private <T extends Filterable> List<T> getFilteredElements(List<T> items) {
        return getFilteredStream(items).collect(Collectors.toList());
    }

    private <T extends Filterable> Stream<T> getFilteredStream(List<T> items) {
        return items.stream().filter(item -> item.getField(mFilter.getType()).equals(mFilter.getValue()));
    }

    public Filter getFilter() {
        return mFilter;
    }

    public void addSong(Song song) {
        synchronized (mLocker) {
            mSongs.add(song);
            mAlbums.add(new Album(song.getAlbum(), song.getArtist(), song.getGenre(), song::getArt));
            mArtists.add(new Artist(song.getArtist(), song.getGenre()));
            mGenres.add(song.getGenre());
        }
    }

    private static class SetArrayList<E> extends ArrayList<E> {
        @Override
        public boolean add(final E object) {
            if (this.contains(object)) {
                return false;
            }
            return super.add(object);
        }
    }
}
