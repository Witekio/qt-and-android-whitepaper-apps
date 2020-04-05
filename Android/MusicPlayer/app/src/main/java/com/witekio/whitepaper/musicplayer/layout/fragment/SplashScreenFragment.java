package com.witekio.whitepaper.musicplayer.layout.fragment;

import android.Manifest;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.documentfile.provider.DocumentFile;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.Navigation;

import com.witekio.whitepaper.musicplayer.R;
import com.witekio.whitepaper.musicplayer.SharedViewModel;
import com.witekio.whitepaper.musicplayer.backend.MediaModel;
import com.witekio.whitepaper.musicplayer.backend.MediaModelBuilder;

import static android.app.Activity.RESULT_OK;

public class SplashScreenFragment extends Fragment {

    private static final String TAG = "SPLASH_SCREEN";

    private static final int PICK_FILE_REQUEST_CODE = 30203;
    private static final int WAITING_TO_ENJOY_SPLASH_SCREEN_MS = 500;

    private boolean mPermissionGranted = false;

    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {

        View layout = inflater.inflate(R.layout.splash_screen_layout, container, false);
        TextView version = layout.findViewById(R.id.version);

        if (getContext() == null) {
            Log.e(TAG, "Impossible to display version: context is null");
            return layout;
        }

        if (getContext().getPackageManager() == null) {
            Log.e(TAG, "Impossible to display version: package manager is null");
            return layout;
        }

        try {
            PackageInfo pInfo = getContext().getPackageManager().getPackageInfo(getContext().getPackageName(), 0);
            version.setText(pInfo.versionName);
        } catch (PackageManager.NameNotFoundException e) {
            Log.e(TAG, "Impossible to display version: " + e.getMessage());
        }

        return layout;

    }

    @Override
    public void onResume() {
        super.onResume();
        if (!mPermissionGranted) {
            checkStoragePermission();
        }
    }

    private void checkStoragePermission() {
        if (getActivity() != null && getActivity().checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
            mPermissionGranted = true;
            new Handler().postDelayed(() -> {
                Intent intent = new Intent(Intent.ACTION_OPEN_DOCUMENT_TREE);
                startActivityForResult(intent, PICK_FILE_REQUEST_CODE);
            }, WAITING_TO_ENJOY_SPLASH_SCREEN_MS);
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == PICK_FILE_REQUEST_CODE) {
            if (resultCode != RESULT_OK || data == null || data.getData() == null) {
                adviceUser();
            } else {
                handleResult(data.getData());
            }
        }
        super.onActivityResult(requestCode, resultCode, data);
    }

    private void handleResult(Uri uriTree) {

        View currentView = getView();
        if (currentView == null) {
            Log.e(TAG, "Navigation failed : View is null");
            return;
        }

        Context currentContext = getContext();
        if (currentContext == null) {
            Log.e(TAG, "Navigation failed : Context is null");
            return;
        }

        FragmentActivity currentActivity = getActivity();
        if (currentActivity == null) {
            Log.e(TAG, "Navigation failed : Activity is null");
            return;
        }

        DocumentFile documentFile = DocumentFile.fromTreeUri(currentContext, uriTree);
        if (documentFile == null) {
            adviceUser();
        } else {
            new Thread(() -> {
                MediaModel mediaModel = new MediaModelBuilder(currentContext).buildMediaModel(documentFile);
                new ViewModelProvider(currentActivity).get(SharedViewModel.class).setMediaModel(mediaModel);
                Navigation.findNavController(currentView).navigate(R.id.dashboard_fragment);
            }).start();
        }

    }

    private void adviceUser() {

        Context currentContext = getContext();
        if (currentContext == null) {
            Log.e(TAG, "Display dialog failed : Context is null");
            return;
        }

        AlertDialog alertDialog = new AlertDialog.Builder(currentContext)
                .setTitle(R.string.data_issue)
                .setMessage(R.string.retry_selected_folder)
                .setNeutralButton(R.string.ok, (dialog, which) -> checkStoragePermission())
                .show();

        TextView message = alertDialog.findViewById(android.R.id.message);
        message.setMaxLines(Integer.MAX_VALUE);

    }

}
