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
 
 公私钥在线生成：http://www.metools.info/code/c80.html/ 密钥长度：1024 bit，密钥格式：PKCS#8
 
 如需帮助，请联系QQ：593692553、微信：hongguixu8131支持
 */

//在后台创建应用后获取APPID
#define APPID @"8c97497aeafe4513bbf830bb0b558f40"

//拉取补丁接口
#define Url_MangoFile @"http://patchhub.top/mangofix/api/getmangofile"

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
    mangoFixUtil.url = Url_MangoFile;
    [mangoFixUtil startWithAppId:APPID privateKey:RSAPrivateKey debug:NO];
    
    /*
     步骤：
     建议将项目中的demo.mg、encrypted_demo文件拷贝至自己的项目中，方便调试
     APP发布版本只需打开第④步注释
     */
    
    //① 执行本地未加密补丁，直接在demo.mg中使用MangoFix语法编写代码，执行该方法调试
    //[mangoFixUtil evalLocalUnEncryptedMangoScriptWithPublicKey:RSAPublicKey];
    
    //② 生成加密补丁，第①步调试完成后，执行改方法生成加密补丁，复制路径，在Finder中ctrl+shift+g进入目录中拿到加密补丁，替换项目中encrypted_demo.mg文件
    [mangoFixUtil encryptPlainScirptToDocumentWithPublicKey:RSAPublicKey];
    
    //③ 执行加密补丁，执行第②步生成的加密补丁，测试补丁是否正常，一般跑一遍即可
    //[mangoFixUtil evalLocalMangoScript];
    
    //④ 执行远程补丁，第③步测试正常，即可通过补丁管理后台发布补丁
    //[mangoFixUtil evalRemoteMangoScript];
}

@end
