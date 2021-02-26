//
//  AppDelegate.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    [self gotoHome];
    
    return YES;
}

- (void)gotoHome {
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

@end
