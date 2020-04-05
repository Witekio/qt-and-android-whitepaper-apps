package com.witekio.whitepaper.musicplayer;

import android.Manifest;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.lifecycle.ViewModelProvider;

public class MainActivity extends AppCompatActivity {

    private final int READ_EXTERNAL_STORAGE_REQUEST_CODE = 11178;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_layout);
        new ViewModelProvider(this).get(SharedViewModel.class).initialize(this);
    }

    @Override
    protected void onStart() {
        super.onStart();
        checkPermissionForReadExternalStorage();
    }

    private void checkPermissionForReadExternalStorage() {
        if (checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            requestPermissionForReadExternalStorage();
        }
    }

    private void requestPermissionForReadExternalStorage() {
        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, READ_EXTERNAL_STORAGE_REQUEST_CODE);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length == 0 || requestCode != READ_EXTERNAL_STORAGE_REQUEST_CODE) {
            return;
        }
        if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.READ_EXTERNAL_STORAGE)) {
                makePermissionExplanationDialog();
            } else {
                makeIrrecoverablePermissionIssueDialog();
            }
        }
    }

    private void makePermissionExplanationDialog() {
        AlertDialog alertDialog = new AlertDialog.Builder(this)
                .setTitle(R.string.permission_issue)
                .setMessage(R.string.app_needs_access)
                .setNeutralButton(R.string.understood, (dialog, which) -> checkPermissionForReadExternalStorage())
                .show();
        applyCustomDialogStyle(alertDialog);
    }

    private void applyCustomDialogStyle(AlertDialog alertDialog) {
        alertDialog.getButton(DialogInterface.BUTTON_NEUTRAL).setAllCaps(false);
        TextView message = alertDialog.findViewById(android.R.id.message);
        message.setMaxLines(Integer.MAX_VALUE);
    }

    private void makeIrrecoverablePermissionIssueDialog() {
        AlertDialog alertDialog = new AlertDialog.Builder(this)
                .setTitle(R.string.fatal_permission_issue)
                .setMessage(R.string.sorry_but_close)
                .setNeutralButton(R.string.so_long, (dialog, which) -> finishAffinity())
                .show();
        applyCustomDialogStyle(alertDialog);
    }
}
