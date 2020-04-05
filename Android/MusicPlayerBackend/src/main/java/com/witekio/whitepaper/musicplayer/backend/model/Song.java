package com.witekio.whitepaper.musicplayer.backend.model;

import android.content.Context;
import android.graphics.Bitmap;
import android.net.Uri;

import org.jetbrains.annotations.NotNull;

import java.lang.ref.Reference;
import java.lang.ref.SoftReference;

import static android.graphics.BitmapFactory.Options;

public class Song implements Comparable<Song>, Filterable {

    private final Uri mUri;
    private String mAlbum;
    private TerFunction<Context, Uri, Options, Bitmap> mArtCallback;
    private Reference<Bitmap> mArt = new SoftReference<>(null);
    private String mArtist;
    private String mTitle;
    private int mDuration;
    private String mGenre;

    public Song(@NotNull Uri uri) {
        mUri = uri;
    }

    public Uri getUri() {
        return mUri;
    }

    public String getAlbum() {
        return mAlbum;
    }

    public void setAlbum(String album) {
        mAlbum = album;
    }

    public Bitmap getArt(Context context) {
        Bitmap result = mArt.get();
        if (result == null && mArtCallback != null) {
            Options options = new Options();
            options.inSampleSize = 4;
            result = mArtCallback.apply(context, getUri(), options);
            mArt = new SoftReference<>(result);
        }
        return result;
    }

    public Bitmap getLargeArt(Context context) {
        Options options = new Options();
        options.inSampleSize = 1;
        return mArtCallback.apply(context, getUri(), options);
    }

    @NotNull
    public String getArtist() {
        return mArtist;
    }

    public void setArtist(String artist) {
        mArtist = artist;
    }

    public String getTitle() {
        return mTitle;
    }

    public void setTitle(String title) {
        mTitle = title;
    }

    public int getDuration() {
        return mDuration;
    }

    public void setDuration(int duration) {
        mDuration = duration;
    }

    public String getGenre() {
        return mGenre;
    }

    public void setGenre(String genre) {
        mGenre = genre;
    }

    @Override
    public int compareTo(Song o) {
        return mTitle.compareTo(o.mTitle);
    }

    public void setArtCallback(TerFunction<Context, Uri, Options, Bitmap> artCallback) {
        mArtCallback = artCallback;
    }

    @Override
    public String getField(FilterType filter) {
        switch (filter) {
            case ALBUM:
                return mAlbum;
            case GENRE:
                return mGenre;
            case ARTIST:
                return mArtist;
            default:
                throw new IllegalArgumentException("Filter " + filter + " doesn't exist for " + this.getClass());
        }
    }
}
