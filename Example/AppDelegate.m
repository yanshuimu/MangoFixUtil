//
//  AppDelegate.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MangoFixUtil.h"

/*
 补丁管理后台：http://patchhub.top/
 
 公私钥在线生成：http://www.metools.info/code/c80.html 密钥长度：1024 bit，密钥格式：PKCS#8
 
 如需帮助，请联系QQ：593692553、微信：hongguixu8131支持
 */

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //初始化建议放在最前面
    [self setupMangoFixUtil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = ctrl;
    [self.window makeKeyAndVisible];
            
    return YES;
}

- (void)setupMangoFixUtil {
    
    MangoFixUtil *mangoFixUtil = [MangoFixUtil sharedUtil];

    [mangoFixUtil startWithAppId:APPID aesKey:aes128Key];
    
    /*
     步骤：
     建议将项目中的demo.mg文件拷贝至自己的项目中，方便调试
     APP发布版本只需打开第②步注释
     */
    
    //① 执行本地未加密补丁，直接在demo.mg中使用MangoFix语法编写代码，执行该方法调试
//    [mangoFixUtil evalLocalUnEncryptedMangoScriptWithKey:aes128Key];
    
//    [mangoFixUtil evalLocalMangoScript];
    
    //② 执行远程补丁，第①步测试正常，即可通过补丁管理后台发布补丁
    [mangoFixUtil evalRemoteMangoScript];
}

@end
