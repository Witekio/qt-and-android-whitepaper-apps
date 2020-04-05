package com.witekio.whitepaper.musicplayer.layout.model;

import androidx.annotation.NonNull;

public class Section {

        private final String mTitle;
        private int mCount;

        public Section(@NonNull String title) {
            mTitle = title;
            mCount = 0;
        }

        public void increment() {
            ++mCount;
        }

        public int getCount() {
            return mCount;
        }

        @NonNull
        public String getTitle() {
            return mTitle;
        }
    }