package com.example.nearlikes;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.content.Intent;
import android.os.Build;
import android.os.Environment;
import android.Manifest;
import androidx.annotation.Nullable;
import androidx.core.content.ContextCompat;
import android.net.Uri;
import android.provider.Settings;
import androidx.core.app.ActivityCompat;
import android.content.pm.PackageManager;
import android.widget.Toast;

public class MainActivity extends FlutterActivity {
    private static final String PERMISSION_CHANNEL = "com.example.nearlikes/permission";

    private static boolean isPermission = false;

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PERMISSION_CHANNEL)
                .setMethodCallHandler((MethodCall call, MethodChannel.Result result) -> {
                    if (call.method.equals("getPermission")) {
                        result.success(getPermissions());
                    } else {
                        System.out.println("Wrong Method call from java");
                    }
                });
    }

    public boolean getPermissions() {
        if (isPermissionGranted()) {
            // Toast.makeText(this, "Permission Already Granted",
            // Toast.LENGTH_SHORT).show();
            System.out.println("Permission Granted");
            isPermission = true;
        } else {
            takePermission();
        }
        return isPermission;
    }

    private boolean isPermissionGranted() {
        if (Build.VERSION.SDK_INT == Build.VERSION_CODES.R) {
            // for Android 11
            return Environment.isExternalStorageManager();
        } else {
            // for Android 10 and below
            int readExternalStoragePermission = ContextCompat.checkSelfPermission(this,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE);
            return readExternalStoragePermission == PackageManager.PERMISSION_GRANTED;
        }
    }

    private void takePermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            try {
                Intent intent = new Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
                intent.addCategory("android.intent.category.DEFAULT");
                intent.setData(Uri.parse(String.format("package:%s", getApplicationContext().getPackageName())));
                startActivityForResult(intent, 100);
            } catch (Exception exception) {
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION);
                startActivityForResult(intent, 100);
            }
        } else {
            ActivityCompat.requestPermissions(this, new String[] { Manifest.permission.WRITE_EXTERNAL_STORAGE }, 101);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK) {
            if (requestCode == 100) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    if (Environment.isExternalStorageManager()) {
                        Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show();
                        isPermission = true;
                    } else {
                        takePermission();
                    }
                }
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,
            @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (grantResults.length > 0) {
            if (requestCode == 101) {
                boolean writeExternalStorage = grantResults[0] == PackageManager.PERMISSION_GRANTED;

                if (writeExternalStorage) {
                    Toast.makeText(this, "Permission Granted", Toast.LENGTH_SHORT).show();
                    isPermission = true;
                } else {
                    takePermission();
                }
            }
        }
    }

}
