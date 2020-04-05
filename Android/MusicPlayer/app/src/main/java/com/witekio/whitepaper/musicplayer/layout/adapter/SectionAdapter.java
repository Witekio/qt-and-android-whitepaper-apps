package com.witekio.whitepaper.musicplayer.layout.adapter;

import android.annotation.SuppressLint;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.DiffUtil;
import androidx.recyclerview.widget.ListAdapter;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.layout.model.Section;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

abstract class SectionAdapter<T> extends ListAdapter<Object, BaseViewHolder> {

    private final int SECTION_TYPE = 0;
    private final int ELEMENT_TYPE = 1;
    private final T mReferenceElement;

    @SuppressLint("StaticFieldLeak")
    SectionAdapter(List<T> elements) {
        super(new DiffUtil.ItemCallback<Object>() {
            @Override
            public boolean areItemsTheSame(@NonNull Object oldItem, @NonNull Object newItem) {
                return oldItem == newItem;
            }

            @Override
            public boolean areContentsTheSame(@NonNull Object oldItem, @NonNull Object newItem) {
                if (oldItem instanceof Section) {
                    return ((Section) oldItem).getCount() == ((Section) newItem).getCount();
                } else {
                    return true;
                }
            }
        });

        if (elements.isEmpty()) {
            mReferenceElement = null;
            return;
        }

        mReferenceElement = elements.get(0);
        AsyncTask<List<T>, List<Object>, Void> createDisplayList = new AsyncTask<List<T>, List<Object>, Void>() {

            @SafeVarargs
            @Override
            protected final Void doInBackground(List<T>... param) {
                List<T> elements = param[0];
                List<Object> sectionAndElements = new ArrayList<>(elements.size());
                Section lastSection = null;
                Collections.sort(elements, getComparator());
                for (T element : elements) {
                    if (lastSection == null || !isSameSection(lastSection, element)) {
                        lastSection = new Section(getSectionLabel(element));
                        sectionAndElements.add(lastSection);
                    }
                    sectionAndElements.add(element);
                    lastSection.increment();
                    publishProgress(sectionAndElements);
                }
                return null;
            }

            @SafeVarargs
            @Override
            protected final void onProgressUpdate(List<Object>... sectionAndElements) {
                SectionAdapter.this.submitList(new ArrayList<>(sectionAndElements[0]));
            }
        };
        createDisplayList.execute(elements);
    }

    protected abstract boolean isSameSection(Section lastSection, T element);

    protected abstract String getSectionLabel(T element);

    protected abstract Comparator<? super T> getComparator();

    @Override
    public int getItemViewType(int position) {
        Object item = getItem(position);
        if (item instanceof Section) {
            return SECTION_TYPE;
        } else if (item.getClass().isAssignableFrom(mReferenceElement.getClass())) {
            return ELEMENT_TYPE;
        } else {
            throw new IllegalArgumentException("Type unknown: " + item.getClass());
        }
    }

    @NonNull
    @Override
    public BaseViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        if (viewType == SECTION_TYPE) {
            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.list_section, parent, false);
            return new SectionViewHolder(view);
        } else if (viewType == ELEMENT_TYPE) {
            return getElementViewHolder(parent);
        } else {
            throw new IllegalArgumentException("View type unknown: " + viewType);
        }
    }

    protected abstract BaseViewHolder getElementViewHolder(ViewGroup parent);

    @Override
    public void onBindViewHolder(@NonNull BaseViewHolder holder, int position) {
        holder.bind(getItem(position));
    }


    static class SectionViewHolder extends BaseViewHolder {

        private final TextView mSectionLabel;
        private final TextView mElementsCount;

        private SectionViewHolder(@NonNull View itemView) {
            super(itemView);
            mSectionLabel = itemView.findViewById(R.id.section_label);
            mElementsCount = itemView.findViewById(R.id.elements_count);
        }

        @Override
        void bind(Object item) {
            if (item instanceof Section) {
                Section section = (Section) item;
                mSectionLabel.setText(section.getTitle());
                mElementsCount.setText(String.valueOf(section.getCount()));
            }
        }
    }
}
