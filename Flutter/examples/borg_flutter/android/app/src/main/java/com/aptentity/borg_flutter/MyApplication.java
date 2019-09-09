package com.aptentity.borg_flutter;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.idlefish.flutterboost.FlutterBoost;
import com.idlefish.flutterboost.interfaces.IContainerRecord;
import com.idlefish.flutterboost.interfaces.IFlutterEngineProvider;
import com.idlefish.flutterboost.interfaces.IPlatform;

import java.util.Map;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class MyApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        FlutterBoost.init(new IPlatform() {
            @Override
            public Application getApplication() {
                return MyApplication.this;
            }

            @Override
            public boolean isDebug() {
                return true;
            }

            @Override
            public void registerPlugins(PluginRegistry registry) {
                Log.e("borg","registerPlugins ");
            }

            @Override
            public void openContainer(Context context, String url, Map<String, Object> urlParams, int requestCode, Map<String, Object> exts) {
                Log.e("borg","openContainer "+url);

            }

            @Override
            public void closeContainer(IContainerRecord record, Map<String, Object> result, Map<String, Object> exts) {
                Log.e("borg","closeContainer");
            }

            @Override
            public IFlutterEngineProvider engineProvider() {
                Log.e("borg","engineProvider");
                return null;
            }

            @Override
            public int whenEngineStart() {
                return ANY_ACTIVITY_CREATED;
            }
        });
    }
}
