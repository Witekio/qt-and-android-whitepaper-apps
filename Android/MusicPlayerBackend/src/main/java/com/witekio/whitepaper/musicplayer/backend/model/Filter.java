package com.witekio.whitepaper.musicplayer.backend.model;

import androidx.annotation.NonNull;

import java.io.Serializable;

public class Filter implements Serializable {

    private final FilterType mType;
    private final String mValue;

    public Filter(@NonNull FilterType type, @NonNull String value) {
        mType = type;
        mValue = value;
    }

    public String getValue() {
        return mValue;
    }

    public FilterType getType() {
        return mType;
    }
}
