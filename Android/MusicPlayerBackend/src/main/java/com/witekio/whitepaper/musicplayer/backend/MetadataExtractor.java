package com.witekio.whitepaper.musicplayer.backend;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.util.Log;

import com.witekio.whitepaper.musicplayer.backend.model.Song;

import java.util.function.Consumer;

final class MetadataExtractor {

    private MetadataExtractor() {
        // utility class
    }

    private static final String TAG = "METADATA_EXTRACTOR";

    public static Song extract(Context context, Uri uri) throws ParsingException, NumberFormatException {
        try (RetrieverHandler retriever = new RetrieverHandler(context, uri)) {
            Song newSong = setupNewSong(uri);
            int duration = Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION));
            newSong.setDuration(duration);

            extractMetadata(retriever, MediaMetadataRetriever.METADATA_KEY_TITLE, newSong::setTitle);
            extractMetadata(retriever, MediaMetadataRetriever.METADATA_KEY_ARTIST, newSong::setArtist);
            extractMetadata(retriever, MediaMetadataRetriever.METADATA_KEY_ALBUM, newSong::setAlbum);
            extractMetadata(retriever, MediaMetadataRetriever.METADATA_KEY_GENRE, newSong::setGenre);
            newSong.setArtCallback(MetadataExtractor::extractEmbeddedPicture);
            return newSong;
        }
    }

    private static void extractMetadata(RetrieverHandler retriever, int metadataKey, Consumer<String> consumer) {
        String data = retriever.extractMetadata(metadataKey);
        if (data != null) {
            consumer.accept(data);
        }
    }

    private static Song setupNewSong(Uri uri) {
        Song result = new Song(uri);
        String path = uri.getPath();
        if (path == null) {
            path = "Unknown title";
        } else {
            path = cleanPath(path);
        }
        result.setTitle(path);
        result.setAlbum("Unknown album");
        result.setArtist("Unknown artist");
        result.setGenre("Unknown genre");
        return result;
    }

    private static String cleanPath(String path) {
        int index;
        if ((index = path.lastIndexOf('.')) != -1) {
            path = path.substring(0, index);
        }
        if ((index = path.lastIndexOf('/')) != -1) {
            path = path.substring(index + 1);
        }
        return path;
    }

    private static Bitmap extractEmbeddedPicture(Context context, Uri uri, BitmapFactory.Options options) {
        byte[] picture = null;
        try (RetrieverHandler retriever = new RetrieverHandler(context, uri)) {
            picture = retriever.getEmbeddedPicture();
        } catch (ParsingException e) {
            Log.e(TAG, "Song file cannot be read:" + uri.getPath());
        }
        return picture == null ? null : BitmapFactory.decodeByteArray(picture, 0, picture.length, options);
    }

}
