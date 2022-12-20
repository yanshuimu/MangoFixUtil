//
//  AppDelegate.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MangoFixUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupMangoFixUtil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = ctrl;
    [self.window makeKeyAndVisible];
            
    return YES;
}

- (void)setupMangoFixUtil {
    
    [[MangoFixUtil startWithAppId:APPID aesKey:AES128KEY] evalRemoteMangoScript];
}

@end
