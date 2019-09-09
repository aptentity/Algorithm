#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import <flutter_boost/FlutterBoost.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:<#(id<FLBPlatform>)#> onStart:^(FlutterEngine *fvc){
        
    }];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}

-(void)applicationWillTerminate:(UIApplication *)application{
    
}
@end
