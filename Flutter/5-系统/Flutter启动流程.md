# Native部分

## Android

### FlutterApplication

```
public class FlutterApplication extends Application {
    private Activity mCurrentActivity = null;

    public FlutterApplication() {
    }

    @CallSuper
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }

    public Activity getCurrentActivity() {
        return this.mCurrentActivity;
    }

    public void setCurrentActivity(Activity mCurrentActivity) {
        this.mCurrentActivity = mCurrentActivity;
    }
}
```

```
public static void startInitialization(@NonNull Context applicationContext) {
    if (!isRunningInRobolectricTest) {
        startInitialization(applicationContext, new FlutterMain.Settings());
    }
}

public static void startInitialization(@NonNull Context applicationContext, @NonNull FlutterMain.Settings settings) {
    if (!isRunningInRobolectricTest) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("startInitialization must be called on the main thread");
        } else if (sSettings == null) {
            sSettings = settings;
            long initStartTimestampMillis = SystemClock.uptimeMillis();
            initConfig(applicationContext);
            initResources(applicationContext);
            System.loadLibrary("flutter");
            VsyncWaiter.getInstance((WindowManager)applicationContext.getSystemService("window")).init();
            long initTimeMillis = SystemClock.uptimeMillis() - initStartTimestampMillis;
            FlutterJNI.nativeRecordStartTimestamp(initTimeMillis);
        }
    }
}
```

`startInitialization`只能执行在主线程中，否则会抛出异常。

通过`sSettings`这个变量可以看出，启动的过程中，这个方法将只执行一遍。

`initConfig`初始化一些变量的配置信息（在AndroidManifest.xml中可以通过meta-data方式配置这些变量值）， `System.loadLibrary("flutter")`则完成装载flutter库文件，期间会在c++层完成JNI方法的动态注册。

```
public static class Settings {
    private String logTag;

    public Settings() {
    }

    @Nullable
    public String getLogTag() {
        return this.logTag;
    }

    public void setLogTag(String tag) {
        this.logTag = tag;
    }
}
```

Settings很简单，只是Log的tag值。

#### initConfig

```
private static void initConfig(@NonNull Context applicationContext) {
    Bundle metadata = getApplicationInfo(applicationContext).metaData;
    if (metadata != null) {
        sAotSharedLibraryName = metadata.getString(PUBLIC_AOT_SHARED_LIBRARY_NAME, "libapp.so");
        sFlutterAssetsDir = metadata.getString(PUBLIC_FLUTTER_ASSETS_DIR_KEY, "flutter_assets");
        sVmSnapshotData = metadata.getString(PUBLIC_VM_SNAPSHOT_DATA_KEY, "vm_snapshot_data");
        sIsolateSnapshotData = metadata.getString(PUBLIC_ISOLATE_SNAPSHOT_DATA_KEY, "isolate_snapshot_data");
    }
}
```

#### initResources

初始化一些变量的配置信息（在AndroidManifest.xml中可以通过meta-data方式配置这些变量值）

```
private static void initResources(@NonNull Context applicationContext) {
    (new ResourceCleaner(applicationContext)).start();
    String dataDirPath = PathUtils.getDataDirectory(applicationContext);
    String packageName = applicationContext.getPackageName();
    PackageManager packageManager = applicationContext.getPackageManager();
    AssetManager assetManager = applicationContext.getResources().getAssets();
    sResourceExtractor = new ResourceExtractor(dataDirPath, packageName, packageManager, assetManager);
    sResourceExtractor.addResource(fromFlutterAssets(sVmSnapshotData)).addResource(fromFlutterAssets(sIsolateSnapshotData)).addResource(fromFlutterAssets("kernel_blob.bin"));
    sResourceExtractor.start();
}
```

`ResourceCleaner`将清理带有指定标识的缓存文件，`ResourceExtractor`将完成asset 目录下flutter相关资源的拷贝，这些资源会在后续flutter engine和DartVM等初始化时使用。

### FlutterActivity

```
protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    this.eventDelegate.onCreate(savedInstanceState);
}
```

FlutterActivity中执行onCreate，可以看到这里面并没有当前ContentView的设置，那么其内容界面是在哪里设置的呢，我们可以看到第二句this.eventDelegate.onCreate(savedInstanceState);，最终我们发现Activity中显示的view是在代理类中进行初始化的，下面看下代理类FlutterActivityDelegate的执行,

#### FlutterActivityDelegate

```
public void onCreate(Bundle savedInstanceState) {
    if (VERSION.SDK_INT >= 21) {
        Window window = this.activity.getWindow();
        window.addFlags(-2147483648);
        window.setStatusBarColor(1073741824);
        window.getDecorView().setSystemUiVisibility(1280);
    }

    String[] args = getArgsFromIntent(this.activity.getIntent());
    FlutterMain.ensureInitializationComplete(this.activity.getApplicationContext(), args);
    this.flutterView = this.viewFactory.createFlutterView(this.activity);
    if (this.flutterView == null) {
        FlutterNativeView nativeView = this.viewFactory.createFlutterNativeView();
        this.flutterView = new FlutterView(this.activity, (AttributeSet)null, nativeView);
        this.flutterView.setLayoutParams(matchParent);
        this.activity.setContentView(this.flutterView);
        this.launchView = this.createLaunchView();
        if (this.launchView != null) {
            this.addLaunchView();
        }
    }

    if (!this.loadIntent(this.activity.getIntent())) {
        String appBundlePath = FlutterMain.findAppBundlePath();
        if (appBundlePath != null) {
            this.runBundle(appBundlePath);
        }

    }
}
```

```
public static void ensureInitializationComplete(@NonNull Context applicationContext, @Nullable String[] args) {
    if (!isRunningInRobolectricTest) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            throw new IllegalStateException("ensureInitializationComplete must be called on the main thread");
        } else if (sSettings == null) {
            throw new IllegalStateException("ensureInitializationComplete must be called after startInitialization");
        } else if (!sInitialized) {
            try {
                if (sResourceExtractor != null) {
                    sResourceExtractor.waitForCompletion();
                }

                List<String> shellArgs = new ArrayList();
                shellArgs.add("--icu-symbol-prefix=_binary_icudtl_dat");
                ApplicationInfo applicationInfo = getApplicationInfo(applicationContext);
                shellArgs.add("--icu-native-lib-path=" + applicationInfo.nativeLibraryDir + File.separator + "libflutter.so");
                if (args != null) {
                    Collections.addAll(shellArgs, args);
                }

                String kernelPath = null;
                String appStoragePath = PathUtils.getDataDirectory(applicationContext) + File.separator + sFlutterAssetsDir;
                kernelPath = appStoragePath + File.separator + "kernel_blob.bin";
                shellArgs.add("--snapshot-asset-path=" + appStoragePath);
                shellArgs.add("--vm-snapshot-data=" + sVmSnapshotData);
                shellArgs.add("--isolate-snapshot-data=" + sIsolateSnapshotData);
                shellArgs.add("--cache-dir-path=" + PathUtils.getCacheDirectory(applicationContext));
                if (sSettings.getLogTag() != null) {
                    shellArgs.add("--log-tag=" + sSettings.getLogTag());
                }

                appStoragePath = PathUtils.getFilesDir(applicationContext);
                String engineCachesPath = PathUtils.getCacheDirectory(applicationContext);
                FlutterJNI.nativeInit(applicationContext, (String[])shellArgs.toArray(new String[0]), kernelPath, appStoragePath, engineCachesPath);
                sInitialized = true;
            } catch (Exception var7) {
                Log.e("FlutterMain", "Flutter initialization failed.", var7);
                throw new RuntimeException(var7);
            }
        }
    }
}
```

它将等待解压任务结束，资源处理完毕，然后拼接参数，完成参数初始化后将执行`nativeInit`方法对c++层初始化。

然后会创建FlutterView对象。

this.flutterView = this.viewFactory.createFlutterView(this.activity);返回null

FlutterNativeView nativeView = this.viewFactory.createFlutterNativeView(); 也是null

this.flutterView = new FlutterView(this.activity, (AttributeSet)null, nativeView); 创建flutterView

```
public FlutterView(Context context, AttributeSet attrs, FlutterNativeView nativeView) {
    super(context, attrs);
    this.nextTextureId = new AtomicLong(0L);
    this.mIsSoftwareRenderingEnabled = false;
    this.didRenderFirstFrame = false;
    this.onAccessibilityChangeListener = new OnAccessibilityChangeListener() {
        public void onAccessibilityChanged(boolean isAccessibilityEnabled, boolean isTouchExplorationEnabled) {
            FlutterView.this.resetWillNotDraw(isAccessibilityEnabled, isTouchExplorationEnabled);
        }
    };
    Activity activity = getActivity(this.getContext());
    if (activity == null) {
        throw new IllegalArgumentException("Bad context");
    } else {
        if (nativeView == null) {
            this.mNativeView = new FlutterNativeView(activity.getApplicationContext());
        } else {
            this.mNativeView = nativeView;
        }

        this.dartExecutor = this.mNativeView.getDartExecutor();
        this.flutterRenderer = new FlutterRenderer(this.mNativeView.getFlutterJNI());
        this.mIsSoftwareRenderingEnabled = FlutterJNI.nativeGetIsSoftwareRenderingEnabled();
        this.mMetrics = new FlutterView.ViewportMetrics();
        this.mMetrics.devicePixelRatio = context.getResources().getDisplayMetrics().density;
        this.setFocusable(true);
        this.setFocusableInTouchMode(true);
        this.mNativeView.attachViewAndActivity(this, activity);
        this.mSurfaceCallback = new Callback() {
            public void surfaceCreated(SurfaceHolder holder) {
                FlutterView.this.assertAttached();
                FlutterView.this.mNativeView.getFlutterJNI().onSurfaceCreated(holder.getSurface());
            }

            public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {
                FlutterView.this.assertAttached();
                FlutterView.this.mNativeView.getFlutterJNI().onSurfaceChanged(width, height);
            }

            public void surfaceDestroyed(SurfaceHolder holder) {
                FlutterView.this.assertAttached();
                FlutterView.this.mNativeView.getFlutterJNI().onSurfaceDestroyed();
            }
        };
        this.getHolder().addCallback(this.mSurfaceCallback);
        this.mActivityLifecycleListeners = new ArrayList();
        this.mFirstFrameListeners = new ArrayList();
        this.navigationChannel = new NavigationChannel(this.dartExecutor);
        this.keyEventChannel = new KeyEventChannel(this.dartExecutor);
        this.lifecycleChannel = new LifecycleChannel(this.dartExecutor);
        this.localizationChannel = new LocalizationChannel(this.dartExecutor);
        this.platformChannel = new PlatformChannel(this.dartExecutor);
        this.systemChannel = new SystemChannel(this.dartExecutor);
        this.settingsChannel = new SettingsChannel(this.dartExecutor);
        final PlatformPlugin platformPlugin = new PlatformPlugin(activity, this.platformChannel);
        this.addActivityLifecycleListener(new ActivityLifecycleListener() {
            public void onPostResume() {
                platformPlugin.updateSystemUiOverlays();
            }
        });
        this.mImm = (InputMethodManager)this.getContext().getSystemService("input_method");
        PlatformViewsController platformViewsController = this.mNativeView.getPluginRegistry().getPlatformViewsController();
        this.mTextInputPlugin = new TextInputPlugin(this, this.dartExecutor, platformViewsController);
        this.androidKeyProcessor = new AndroidKeyProcessor(this.keyEventChannel, this.mTextInputPlugin);
        this.androidTouchProcessor = new AndroidTouchProcessor(this.flutterRenderer);
        this.mNativeView.getPluginRegistry().getPlatformViewsController().attachTextInputPlugin(this.mTextInputPlugin);
        this.sendLocalesToDart(this.getResources().getConfiguration());
        this.sendUserPlatformSettingsToDart();
    }
}
```

这个方法中先执行FlutterNativeView对象创建，然后是FlutterJNI对象创建，再通过c++层完成两者的绑定关系。另外activity和flutterView的绑定关系也在这里完成，并会在PlatformViewsController中完成注册方法回调关系。这个方法还包含了界面绘制监听，flutter绘制的关键调用，建立了通讯体系（各类Channel）。在c++层会用到的资源处理对象也是从这里创建的。

```
public FlutterNativeView(@NonNull Context context, boolean isBackgroundView) {
    this.mContext = context;
    this.mPluginRegistry = new FlutterPluginRegistry(this, context);
    this.mFlutterJNI = new FlutterJNI();
    this.mFlutterJNI.setRenderSurface(new FlutterNativeView.RenderSurfaceImpl());
    this.dartExecutor = new DartExecutor(this.mFlutterJNI, context.getAssets());
    this.mFlutterJNI.addEngineLifecycleListener(new FlutterNativeView.EngineLifecycleListenerImpl());
    this.attach(this, isBackgroundView);
    this.assertAttached();
}
```

# Flutter部分

最简单的flutter程序

```
void main(){
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  final String _message = "Flutter框架分析";
  @override
  Widget build(BuildContext context) => ErrorWidget(_message);
}
```

flutter入口为main函数，MyWidget是要显示的页面。使用runApp将Widget挂载到根上。

```
void runApp(Widget app) {
  WidgetsFlutterBinding.ensureInitialized()
    ..attachRootWidget(app)
    ..scheduleWarmUpFrame();
}
```

通过WidgetsFlutterBinding的ensureInitialized去初始化，然后调用attachRootWidget将我们的MyWidget传入，来遍历挂载整个视图树，最后使用scheduleWarmUpFrame去渲染。

## 初始化过程

WidgetsFlutterBinding继承自 BindingBase 并混入了很多Binding

Window正是Flutter Framework连接宿主操作系统的接口。Window类包含了当前设备和系统的一些信息以及Flutter Engine的一些回调。

```
class Window {
 
  // 当前设备的DPI，即一个逻辑像素显示多少物理像素，数字越大，显示效果就越精细保真。
  // DPI是设备屏幕的固件属性，如Nexus 6的屏幕DPI为3.5 
  double get devicePixelRatio => _devicePixelRatio;
 
  // Flutter UI绘制区域的大小
  Size get physicalSize => _physicalSize;
 
  // 当前系统默认的语言Locale
  Locale get locale;
 
  // 当前系统字体缩放比例。  
  double get textScaleFactor => _textScaleFactor;  
 
  // 当绘制区域大小改变回调
  VoidCallback get onMetricsChanged => _onMetricsChanged;  
  // Locale发生变化回调
  VoidCallback get onLocaleChanged => _onLocaleChanged;
  // 系统字体缩放变化回调
  VoidCallback get onTextScaleFactorChanged => _onTextScaleFactorChanged;
  // 绘制前回调，一般会受显示器的垂直同步信号VSync驱动，当屏幕刷新时就会被调用
  FrameCallback get onBeginFrame => _onBeginFrame;
  // 绘制回调  
  VoidCallback get onDrawFrame => _onDrawFrame;
  // 点击或指针事件回调
  PointerDataPacketCallback get onPointerDataPacket => _onPointerDataPacket;
  // 调度Frame，该方法执行后，onBeginFrame和onDrawFrame将紧接着会在合适时机被调用，
  // 此方法会直接调用Flutter engine的Window_scheduleFrame方法
  void scheduleFrame() native 'Window_scheduleFrame';
  // 更新应用在GPU上的渲染,此方法会直接调用Flutter engine的Window_render方法
  void render(Scene scene) native 'Window_render';
 
  // 发送平台消息
  void sendPlatformMessage(String name,
                           ByteData data,
                           PlatformMessageResponseCallback callback) ;
  // 平台通道消息处理回调  
  PlatformMessageCallback get onPlatformMessage => _onPlatformMessage;
 
  ... //其它属性及回调
 
}

```

WidgetsFlutterBinding混入的各种Binding。通过查看这些 Binding的源码，我们可以发现这些Binding中基本都是监听并处理Window对象的一些事件，然后将这些事件按照Framework的模型包装、抽象然后分发。可以看到WidgetsFlutterBinding正是粘连Flutter engine与上层Framework的”胶水“。

- GestureBinding：提供了window.onPointerDataPacket 回调，绑定Framework手势子系统，是Framework事件模型与底层事件的绑定入口。
- ServicesBinding：提供了window.onPlatformMessage 回调， 用于绑定平台消息通道（message channel），主要处理原生和Flutter通信。
- SchedulerBinding：提供了window.onBeginFrame和window.onDrawFrame回调，监听刷新事件，绑定Framework绘制调度子系统。
- PaintingBinding：绑定绘制库，主要用于处理图片缓存。
- SemanticsBinding：语义化层与Flutter engine的桥梁，主要是辅助功能的底层支持。
- RendererBinding: 提供了window.onMetricsChanged 、window.onTextScaleFactorChanged 等回调。它是渲染树与Flutter engine的桥梁。
- WidgetsBinding：提供了window.onLocaleChanged、onBuildScheduled 等回调。它Flutter Widget层与engine的桥梁。





## 挂载过程

```
void attachRootWidget(Widget rootWidget) {
  _renderViewElement = RenderObjectToWidgetAdapter<RenderBox>(
    container: renderView,
    debugShortDescription: '[root]',
    child: rootWidget,
  ).attachToRenderTree(buildOwner, renderViewElement);
}
```

通过RenderObjectToWidgetAdapter的attachToRenderTree去构建顶层试图的element（renderViewElement）

代码中的有renderView和renderViewElement两个变量，renderView是一个RenderObject，它是渲染树的根，而renderViewElement是renderView对应的Element对象，可见该方法主要完成了 根Widget 到根 RenderObject再到更Element的整个关联过程。


```
RenderObjectToWidgetElement<T> attachToRenderTree(BuildOwner owner, [ RenderObjectToWidgetElement<T> element ]) {
  if (element == null) {
    owner.lockState(() {
      element = createElement();
      assert(element != null);
      element.assignOwner(owner);
    });
    owner.buildScope(element, () {
      element.mount(null, null);
    });
  } else {
    element._newWidget = this;
    element.markNeedsBuild();
  }
  return element;
}
```

如果element是空，则调用方法去创建，然后通过mount方法将其挂载到视图树上。

```
@override
void mount(Element parent, dynamic newSlot) {
  assert(parent == null);
  super.mount(parent, newSlot);
  _rebuild();
}
```

```
void _rebuild() {
  try {
    _child = updateChild(_child, widget.child, _rootChildSlot);
    assert(_child != null);
  } catch (exception, stack) {
    final FlutterErrorDetails details = FlutterErrorDetails(
      exception: exception,
      stack: stack,
      library: 'widgets library',
      context: ErrorDescription('attaching to the render tree'),
    );
    FlutterError.reportError(details);
    final Widget error = ErrorWidget.builder(details);
    _child = updateChild(null, error, _rootChildSlot);
  }
}
```

```
@protected
Element updateChild(Element child, Widget newWidget, dynamic newSlot) {
  assert(() {
    if (newWidget != null && newWidget.key is GlobalKey) {
      final GlobalKey key = newWidget.key;
      key._debugReserveFor(this);
    }
    return true;
  }());
  if (newWidget == null) {
    if (child != null)
      deactivateChild(child);
    return null;
  }
  if (child != null) {
    if (child.widget == newWidget) {
      if (child.slot != newSlot)
        updateSlotForChild(child, newSlot);
      return child;
    }
    if (Widget.canUpdate(child.widget, newWidget)) {
      if (child.slot != newSlot)
        updateSlotForChild(child, newSlot);
      child.update(newWidget);
      assert(child.widget == newWidget);
      assert(() {
        child.owner._debugElementWasRebuilt(child);
        return true;
      }());
      return child;
    }
    deactivateChild(child);
    assert(child._parent == null);
  }
  return inflateWidget(newWidget, newSlot);
}
```

updateChild用来更新一个孩子节点。更新有四种情况：

- 新`Widget`为空，老`Widget`也为空。则啥也不做。
- 新`Widget`为空，老`Widget`不为空。这个`Element`被移除。
- 新`Widget`不为空，老`Widget`为空。则调用`inflateWidget()`以这个`Wiget`为配置实例化一个`Element`。
- 新`Widget`不为空，老`Widget`不为空。调用`update()`函数更新子`Element`。`update()`函数由子类实现。

```
@protected
Element inflateWidget(Widget newWidget, dynamic newSlot) {
  assert(newWidget != null);
  final Key key = newWidget.key;
  if (key is GlobalKey) {
    final Element newChild = _retakeInactiveElement(key, newWidget);
    if (newChild != null) {
      assert(newChild._parent == null);
      assert(() { _debugCheckForCycles(newChild); return true; }());
      newChild._activateWithParent(this, newSlot);
      final Element updatedChild = updateChild(newChild, newWidget, newSlot);
      assert(newChild == updatedChild);
      return updatedChild;
    }
  }
  final Element newChild = newWidget.createElement();
  assert(() { _debugCheckForCycles(newChild); return true; }());
  newChild.mount(this, newSlot);
  assert(newChild._debugLifecycleState == _ElementLifecycle.active);
  return newChild;
}
```

mount方法最终调用了inflateWidget方法，进而通过newWidget创建子element并调用其mount方法。

这里的newWidget就是我们runApp中传进来的rootWidget，也就是例子中的MyApp，MyApp是继承自StatelessWidget。

```
abstract class StatelessWidget extends Widget {
  const StatelessWidget({ Key key }) : super(key: key);
  
  @override
  StatelessElement createElement() => StatelessElement(this);
  
  @protected
  Widget build(BuildContext context);
}
```

创建了一个StatelessElement

```
class StatelessElement extends ComponentElement {
  /// Creates an element that uses the given widget as its configuration.
  StatelessElement(StatelessWidget widget) : super(widget);

  @override
  StatelessWidget get widget => super.widget;

  @override
  Widget build() => widget.build(this);

  @override
  void update(StatelessWidget newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _dirty = true;
    rebuild();
  }
}
```

StatelessElement继承自ComponentElement，我们来看一下ComponentElement的mount方法。

```
@override
void mount(Element parent, dynamic newSlot) {
  super.mount(parent, newSlot);
  assert(_child == null);
  assert(_active);
  _firstBuild();
  assert(_child != null);
}

void _firstBuild() {
  rebuild();
}

```

```
void rebuild() {
  assert(_debugLifecycleState != _ElementLifecycle.initial);
  if (!_active || !_dirty)
    return;
  assert(() {
    if (debugOnRebuildDirtyWidget != null) {
      debugOnRebuildDirtyWidget(this, _debugBuiltOnce);
    }
    if (debugPrintRebuildDirtyWidgets) {
      if (!_debugBuiltOnce) {
        debugPrint('Building $this');
        _debugBuiltOnce = true;
      } else {
        debugPrint('Rebuilding $this');
      }
    }
    return true;
  }());
  assert(_debugLifecycleState == _ElementLifecycle.active);
  assert(owner._debugStateLocked);
  Element debugPreviousBuildTarget;
  assert(() {
    debugPreviousBuildTarget = owner._debugCurrentBuildTarget;
    owner._debugCurrentBuildTarget = this;
    return true;
  }());
  performRebuild();
  assert(() {
    assert(owner._debugCurrentBuildTarget == this);
    owner._debugCurrentBuildTarget = debugPreviousBuildTarget;
    return true;
  }());
  assert(!_dirty);
}
```

最终调到了performRebuild

```
@override
void performRebuild() {
  if (!kReleaseMode && debugProfileBuildsEnabled)
    Timeline.startSync('${widget.runtimeType}',  arguments: timelineWhitelistArguments);

  assert(_debugSetAllowIgnoredCallsToMarkNeedsBuild(true));
  Widget built;
  try {
    built = build();
    debugWidgetBuilderValue(widget, built);
  } catch (e, stack) {
    built = ErrorWidget.builder(
      _debugReportException(
        ErrorDescription('building $this'),
        e,
        stack,
        informationCollector: () sync* {
          yield DiagnosticsDebugCreator(DebugCreator(this));
        },
      )
    );
  } finally {
    // We delay marking the element as clean until after calling build() so
    // that attempts to markNeedsBuild() during build() will be ignored.
    _dirty = false;
    assert(_debugSetAllowIgnoredCallsToMarkNeedsBuild(false));
  }
  try {
    _child = updateChild(_child, built, slot);
    assert(_child != null);
  } catch (e, stack) {
    built = ErrorWidget.builder(
      _debugReportException(
        ErrorDescription('building $this'),
        e,
        stack,
        informationCollector: () sync* {
          yield DiagnosticsDebugCreator(DebugCreator(this));
        },
      )
    );
    _child = updateChild(null, built, slot);
  }

  if (!kReleaseMode && debugProfileBuildsEnabled)
    Timeline.finishSync();
}
```

有调用了调用到updateChild，其中newWidget为StatelessWidget的build方法来生成widget。这样就做到了遍历整个视图树，创建视图了。



## 渲染过程

回到runApp的实现中，当调用完attachRootWidget后，最后一行会调用 WidgetsFlutterBinding 实例的 scheduleWarmUpFrame() 方法，该方法的实现在 SchedulerBinding 中，它被调用后会立即进行一次绘制（而不是等待"Vsync" 信号），在此次绘制结束前，该方法会锁定事件分发，也就是说在本次绘制结束完成之前Flutter将不会响应各种事件，这可以保证在绘制过程中不会再触发新的重绘。下面是scheduleWarmUpFrame() 方法的实现：

```
void scheduleWarmUpFrame() {
  if (_warmUpFrame || schedulerPhase != SchedulerPhase.idle)
    return;

  _warmUpFrame = true;
  Timeline.startSync('Warm-up frame');
  final bool hadScheduledFrame = _hasScheduledFrame;
  // We use timers here to ensure that microtasks flush in between.
  Timer.run(() {
    assert(_warmUpFrame);
    handleBeginFrame(null);
  });
  Timer.run(() {
    assert(_warmUpFrame);
    handleDrawFrame();
    // We call resetEpoch after this frame so that, in the hot reload case,
    // the very next frame pretends to have occurred immediately after this
    // warm-up frame. The warm-up frame's timestamp will typically be far in
    // the past (the time of the last real frame), so if we didn't reset the
    // epoch we would see a sudden jump from the old time in the warm-up frame
    // to the new time in the "real" frame. The biggest problem with this is
    // that implicit animations end up being triggered at the old time and
    // then skipping every frame and finishing in the new time.
    resetEpoch();
    _warmUpFrame = false;
    if (hadScheduledFrame)
      scheduleFrame();
  });

  // Lock events so touch events etc don't insert themselves until the
  // scheduled frame has finished.
  lockEvents(() async {
    await endOfFrame;
    Timeline.finishSync();
  });
}
```

该方法中主要调用了`handleBeginFrame()` 和 `handleDrawFrame()` 两个方法.

Frame 和c 的概念：

Frame: 一次绘制过程，我们称其为一帧。Flutter engine受显示器垂直同步信号"VSync"的趋势不断的触发绘制。我们之前说的Flutter可以实现60fps（Frame Per-Second），就是指一秒钟可以触发60次重绘，FPS值越大，界面就越流畅。

FrameCallback：SchedulerBinding 类中有三个FrameCallback回调队列， 在一次绘制过程中，这三个回调队列会放在不同时机被执行：

transientCallbacks：用于存放一些临时回调，一般存放动画回调。可以通过SchedulerBinding.instance.scheduleFrameCallback 添加回调。
persistentCallbacks：用于存放一些持久的回调，不能在此类回调中再请求新的绘制帧，持久回调一经注册则不能移除。SchedulerBinding.instance.addPersitentFrameCallback()，这个回调中处理了布局与绘制工作。
postFrameCallbacks：在Frame结束时只会被调用一次，调用后会被系统移除，可由 SchedulerBinding.instance.addPostFrameCallback() 注册，注意，不要在此类回调中再触发新的Frame，这可以会导致循环刷新。
handleBeginFrame() 和 handleDrawFrame() 两个方法的源码，可以发现前者主要是执行了transientCallbacks队列，而后者执行了 persistentCallbacks 和 postFrameCallbacks 队列。

## 绘制

渲染和绘制逻辑在RenderBinding 中实现，查看其源发，发现在其`initInstances()`方法中有如下代码：

```
void initInstances() {
  super.initInstances();
  _instance = this;
  _pipelineOwner = PipelineOwner(
    onNeedVisualUpdate: ensureVisualUpdate,
    onSemanticsOwnerCreated: _handleSemanticsOwnerCreated,
    onSemanticsOwnerDisposed: _handleSemanticsOwnerDisposed,
  );
  window
    ..onMetricsChanged = handleMetricsChanged
    ..onTextScaleFactorChanged = handleTextScaleFactorChanged
    ..onPlatformBrightnessChanged = handlePlatformBrightnessChanged
    ..onSemanticsEnabledChanged = _handleSemanticsEnabledChanged
    ..onSemanticsAction = _handleSemanticsAction;
  initRenderView();
  _handleSemanticsEnabledChanged();
  assert(renderView != null);
  addPersistentFrameCallback(_handlePersistentFrameCallback);
  _mouseTracker = _createMouseTracker();
}
```

通过`addPersistentFrameCallback` 向persistentCallbacks队列添加了一个回调 `_handlePersistentFrameCallback`:

```
void _handlePersistentFrameCallback(Duration timeStamp) {
  drawFrame();
}
```

```
void drawFrame() {
  assert(renderView != null);
  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();
  renderView.compositeFrame(); // this sends the bits to the GPU
  pipelineOwner.flushSemantics(); // this also sends the semantics to the OS.
}
```

```
void flushLayout() {
  if (!kReleaseMode) {
    Timeline.startSync('Layout', arguments: timelineWhitelistArguments);
  }
  assert(() {
    _debugDoingLayout = true;
    return true;
  }());
  try {
    // TODO(ianh): assert that we're not allowing previously dirty nodes to redirty themselves
    while (_nodesNeedingLayout.isNotEmpty) {
      final List<RenderObject> dirtyNodes = _nodesNeedingLayout;
      _nodesNeedingLayout = <RenderObject>[];
      for (RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => a.depth - b.depth)) {
        if (node._needsLayout && node.owner == this)
          node._layoutWithoutResize();
      }
    }
  } finally {
    assert(() {
      _debugDoingLayout = false;
      return true;
    }());
    if (!kReleaseMode) {
      Timeline.finishSync();
    }
  }
}
```

该方法主要任务是更新了所有被标记为“dirty”的RenderObject的布局信息。主要的动作发生在`node._layoutWithoutResize()`方法中，该方法中会调用`performLayout()`进行重新布局。 

```
void flushCompositingBits() {
  if (!kReleaseMode) {
    Timeline.startSync('Compositing bits');
  }
  _nodesNeedingCompositingBitsUpdate.sort((RenderObject a, RenderObject b) => a.depth - b.depth);
  for (RenderObject node in _nodesNeedingCompositingBitsUpdate) {
    if (node._needsCompositingBitsUpdate && node.owner == this)
      node._updateCompositingBits();
  }
  _nodesNeedingCompositingBitsUpdate.clear();
  if (!kReleaseMode) {
    Timeline.finishSync();
  }
}
```

检查RenderObject是否需要重绘，然后更新`RenderObject.needsCompositing`属性，如果该属性值被标记为`true`则需要重绘。 

```
void flushPaint() {
  if (!kReleaseMode) {
    Timeline.startSync('Paint', arguments: timelineWhitelistArguments);
  }
  assert(() {
    _debugDoingPaint = true;
    return true;
  }());
  try {
    final List<RenderObject> dirtyNodes = _nodesNeedingPaint;
    _nodesNeedingPaint = <RenderObject>[];
    // Sort the dirty nodes in reverse order (deepest first).
    for (RenderObject node in dirtyNodes..sort((RenderObject a, RenderObject b) => b.depth - a.depth)) {
      assert(node._layer != null);
      if (node._needsPaint && node.owner == this) {
        if (node._layer.attached) {
          PaintingContext.repaintCompositedChild(node);
        } else {
          node._skippedPaintingOnLayer();
        }
      }
    }
    assert(_nodesNeedingPaint.isEmpty);
  } finally {
    assert(() {
      _debugDoingPaint = false;
      return true;
    }());
    if (!kReleaseMode) {
      Timeline.finishSync();
    }
  }
}
```

该方法进行了最终的绘制，可以看出它不是重绘了所有 RenderObject，而是只重绘了需要重绘的 RenderObject。真正的绘制是通过PaintingContext.repaintCompositedChild()来绘制的，该方法最终会调用Flutter engine提供的Canvas API来完成绘制。 

```
void compositeFrame() {
  Timeline.startSync('Compositing', arguments: timelineWhitelistArguments);
  try {
    final ui.SceneBuilder builder = ui.SceneBuilder();
    final ui.Scene scene = layer.buildScene(builder);
    if (automaticSystemUiAdjustment)
      _updateSystemChrome();
    _window.render(scene);
    scene.dispose();
    assert(() {
      if (debugRepaintRainbowEnabled || debugRepaintTextRainbowEnabled)
        debugCurrentRepaintColor = debugCurrentRepaintColor.withHue((debugCurrentRepaintColor.hue + 2.0) % 360.0);
      return true;
    }());
  } finally {
    Timeline.finishSync();
  }
}
```

方法中有一个Scene对象，Scene对象是一个数据结构，保存最终渲染后的像素信息。这个方法将Canvas画好的Scene传给`window.render()`方法，该方法会直接将scene信息发送给Flutter engine，最终又engine将图像画在设备屏幕上。 