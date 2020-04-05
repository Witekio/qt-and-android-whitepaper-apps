package com.witekio.whitepaper.musicplayer.backend;

import android.content.Context;
import android.media.MediaMetadataRetriever;
import android.net.Uri;

class RetrieverHandler implements AutoCloseable {

    private final MediaMetadataRetriever inner;

    RetrieverHandler(Context context, Uri uri) throws ParsingException {
        inner = new MediaMetadataRetriever();
        setDataSource(context, uri);
    }

    @Override
    public void close() {
        inner.release();
    }

    private void setDataSource(Context context, Uri uri) throws IllegalArgumentException, ParsingException {
        try {
            inner.setDataSource(context, uri);
        } catch (RuntimeException e) {
            throw new ParsingException(e);
        }
    }

    public String extractMetadata(int keyCode) {
        return inner.extractMetadata(keyCode);
    }

    public byte[] getEmbeddedPicture() {
        return inner.getEmbeddedPicture();
    }
}
