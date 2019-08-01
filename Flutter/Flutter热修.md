# Android

Flutter 页面显示到 Android 端，实际就是用的 FlutterView 填充到 Activity或者 Fragment上的。

public static FlutterView createView(@NonNull final Activity activity, @NonNull final Lifecycle lifecycle, final String initialRoute) {
    FlutterMain.startInitialization(activity.getApplicationContext());
    FlutterMain.ensureInitializationComplete(activity.getApplicationContext(), null);
    final FlutterNativeView nativeView = new FlutterNativeView(activity);
    final FlutterView flutterView = new FlutterView(activity, null, nativeView);
    ......
    return flutterView;
  }

FlutterMain.startInitialization 主要做了初始化配置信息、初始化AOT编译和初始化资源，最后一部分则是加载Flutter的Native环境。跟热修复相关的主要是第三步，初始化资源 initResources()

public class FlutterMain {
   ......
   private static final String SHARED_ASSET_DIR = "flutter_shared";
   private static final String SHARED_ASSET_ICU_DATA = "icudtl.dat";
   private static String sAotVmSnapshotData = "vm_snapshot_data";
   private static String sAotVmSnapshotInstr = "vm_snapshot_instr";
   private static String sAotIsolateSnapshotData = "isolate_snapshot_data";
   private static String sAotIsolateSnapshotInstr = "isolate_snapshot_instr";
   private static String sFlutterAssetsDir = "flutter_assets";
   public static void startInitialization(Context applicationContext, FlutterMain.Settings settings) {
       ......
       // 初始化配置信息
       initConfig(applicationContext);
       // 初始化AOT编译
       initAot(applicationContext);
       // 初始化资源
       initResources(applicationContext);
       // 加载Flutter的Native环境
       System.loadLibrary("flutter");
       ......
   }
   private static void initResources(Context applicationContext) {
       ......
       sResourceExtractor = new ResourceExtractor(applicationContext);
       String icuAssetPath = "flutter_shared" + File.separator + "icudtl.dat";
       sResourceExtractor.addResource(icuAssetPath);
       sIcuDataPath = PathUtils.getDataDirectory(applicationContext) + File.separator + icuAssetPath;
       sResourceExtractor.addResource(fromFlutterAssets(sFlx)).addResource(fromFlutterAssets(sAotVmSnapshotData)).addResource(fromFlutterAssets(sAotVmSnapshotInstr)).addResource(fromFlutterAssets(sAotIsolateSnapshotData)).addResource(fromFlutterAssets(sAotIsolateSnapshotInstr)).addResource(fromFlutterAssets("kernel_blob.bin"));
       if (sIsPrecompiledAsSharedLibrary) {
           sResourceExtractor.addResource(sAotSharedLibraryPath);
       } else {
           sResourceExtractor.addResource(sAotVmSnapshotData).addResource(sAotVmSnapshotInstr).addResource(sAotIsolateSnapshotData).addResource(sAotIsolateSnapshotInstr);
       }
       sResourceExtractor.start();
   }
}

