package com.witekio.whitepaper.musicplayer.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.RelativeLayout;

import com.witekio.whitepaper.musicplayer.R;

public class SongView extends RelativeLayout {

    private static final int[] STATE_PLAYING = {R.attr.state_playing};
    private static final int[] STATE_PAUSED = {R.attr.state_paused};

    private boolean mPlayingState = false;
    private boolean mPausedState = false;

    public SongView(Context context) {
        super(context);
    }

    public SongView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public SongView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    public SongView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
    }

    @Override
    protected int[] onCreateDrawableState(int extraSpace) {
        final int[] drawableState = super.onCreateDrawableState(extraSpace + 2);
        if (mPlayingState) {
            mergeDrawableStates(drawableState, STATE_PLAYING);
        }
        if (mPausedState) {
            mergeDrawableStates(drawableState, STATE_PAUSED);
        }
        return drawableState;
    }

    public void setPlayingState(boolean playingState) {
        mPlayingState = playingState;
    }

    public void setPausedState(boolean pausedState) {
        mPausedState = pausedState;
    }
}
