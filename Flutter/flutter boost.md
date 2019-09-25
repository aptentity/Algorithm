# Android

## Application

```
public class MyApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();

        FlutterBoost.init(new Platform() {

            @Override
            public Application getApplication() {
                return MyApplication.this;
            }

            @Override
            public boolean isDebug() {
                return true;
            }

            @Override
            public void openContainer(Context context, String url, Map<String, Object> urlParams, int requestCode, Map<String, Object> exts) {
                PageRouter.openPageByUrl(context, url, urlParams, requestCode);
            }

            @Override
            public IFlutterEngineProvider engineProvider() {
                return new BoostEngineProvider() {
                    @Override
                    public BoostFlutterEngine createEngine(Context context) {
                        return new BoostFlutterEngine(context, new DartExecutor.DartEntrypoint(
                                context.getResources().getAssets(),
                                FlutterMain.findAppBundlePath(context),
                                "main"), "/");
                    }
                };
            }

            @Override
            public int whenEngineStart() {
                return ANY_ACTIVITY_CREATED;
            }
        });

        BoostChannel.addActionAfterRegistered(new BoostChannel.ActionAfterRegistered() {
            @Override
            public void onChannelRegistered(BoostChannel channel) {
                //platform view register should use FlutterPluginRegistry instread of BoostPluginRegistry
                TextPlatformViewPlugin.register(FlutterBoost.singleton().engineProvider().tryGetEngine().getPluginRegistry());
            }
        });
    }
}
```

FlutterBoost初始化，注册BoostChannel

## FlutterBoost

```
public static synchronized void init(IPlatform platform) {
    if (sInstance == null) {
        sInstance = new FlutterBoost(platform);
    }

    if (platform.whenEngineStart() == IPlatform.IMMEDIATELY) {
        sInstance.mEngineProvider
                .provideEngine(platform.getApplication())
                .startRun(null);
    }
}
```

```
private FlutterBoost(IPlatform platform) {
    mPlatform = platform;
    mManager = new FlutterViewContainerManager();

    IFlutterEngineProvider provider = platform.engineProvider();
    if(provider == null) {
        provider = new BoostEngineProvider();
    }
    mEngineProvider = provider;
    platform.getApplication().registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks());

    BoostChannel.addActionAfterRegistered(new BoostChannel.ActionAfterRegistered() {
        @Override
        public void onChannelRegistered(BoostChannel channel) {
            channel.addMethodCallHandler(new BoostMethodHandler());
        }
    });
}
```

创建FlutterViewContainerManager，