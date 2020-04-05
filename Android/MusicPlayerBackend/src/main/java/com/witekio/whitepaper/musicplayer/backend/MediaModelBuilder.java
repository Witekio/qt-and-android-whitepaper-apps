package com.witekio.whitepaper.musicplayer.backend;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.documentfile.provider.DocumentFile;

import com.witekio.whitepaper.musicplayer.backend.model.Song;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.Semaphore;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class MediaModelBuilder {

    private static final String TAG = "MODEL_BUILDER";
    private static final int NB_CORE_THREAD = 2;
    private static final int NB_MAX_THREAD = 4;
    private static final int INITIAL_PERMIT = 8;
    private static final int THREAD_IDLE_DURATION = 1;

    private final Semaphore mSemaphore = new Semaphore(INITIAL_PERMIT);
    private final ThreadPoolExecutor mExecutor;
    private final Context mContext;


    public MediaModelBuilder(Context context) {
        mContext = context;
        mExecutor = new ThreadPoolExecutor(NB_CORE_THREAD, NB_MAX_THREAD,
                THREAD_IDLE_DURATION, TimeUnit.SECONDS, new LinkedBlockingQueue<>());
    }

    public MediaModel buildMediaModel(@NonNull DocumentFile file) {
        MediaModel mediaModel = new MediaModel();
        addMusicFolder(mediaModel, file);
        try {
            mSemaphore.acquire(INITIAL_PERMIT);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
        mExecutor.shutdown();
        return mediaModel;
    }

    private void addMusicFolder(@NonNull MediaModel mediaModel, @NonNull DocumentFile file) {
        if (file.isDirectory()) {
            parseMusicFolder(mediaModel, file.listFiles());
        } else {
            try {
                mSemaphore.acquire();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            mExecutor.execute(() -> {
                try {
                    Song song = MetadataExtractor.extract(mContext, file.getUri());
                    if (song != null) {
                        mediaModel.addSong(song);
                    }
                } catch (ParsingException | NumberFormatException e) {
                    Log.w(TAG, "File [" + file.getUri().getPath() + "] cannot be analysed as media file: " + e.getMessage());
                } finally {
                    mSemaphore.release();
                }
            });
        }
    }

    private void parseMusicFolder(@NonNull MediaModel mediaModel, DocumentFile[] files) {
        if (files == null) {
            return;
        }
        for (DocumentFile file : files) {
            addMusicFolder(mediaModel, file);
        }
    }

}
