//
//  AppDelegate.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MangoFixUtil.h"

// 注意：本库需搭配补丁管理后台一起使用
// http://patchhub.top
// Github地址：
// https://github.com/yanshuimu/MangoFixUtil
// 脚本语法参考：
// https://github.com/YPLiang19/Mango


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
    
    [[MangoFixUtil startWithAppId:APPID aesKey:AES128KEY] encryptPlainScriptToDocument];
}

@end
