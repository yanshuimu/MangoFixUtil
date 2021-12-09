# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行、设备激活、补丁激活完整流程，具体使用方法请下载Demo参考。

欢迎使用作者维护的[补丁管理后台](http://patchhub.top/mangofix/login)。

MangoFixUtil在公司项目中实战已经近1年多，很稳定，也会不断继续完善。第一个补丁诞生于2020-03-09，最初是用PostMan操作，后来有了界面，也是比较简陋，一直处于自用状态。最近才加上登录、注册功能，开放出来供有需要的小伙伴使用。

[公私钥在线生成](http://www.metools.info/code/c80.html)，密钥长度：1024 bit，密钥格式：PKCS#8

## Example

```objc
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupMangoFixUtil];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyAndVisible];
            
    return YES;
}

- (void)setupMangoFixUtil {
    
    MangoFixUtil *mangoFixUtil = [MangoFixUtil sharedUtil];
    [mangoFixUtil startWithAppId:APPID privateKey:RSAPrivateKey];
    [mangoFixUtil evalRemoteMangoScript];
}

@end
```
## Installation

### CocoaPods

```ruby
# Your Podfile
pod 'MangoFix'
pod 'MangoFixUtil'
```

### Manually

Copy `MangoFixUtil.m` `MangoFixUtil.h` in `MangoFixUtil/` to your project.

## Usage

### Objective-C
1. `#import "MangoFixUtil.h"`

```objc
MangoFixUtil *mangoFixUtil = [MangoFixUtil sharedUtil];
[mangoFixUtil startWithAppId:MANGOFIXUTIL_APPID privateKey:RSAPrivateKey];

// exec mangofix file from network
[mangoFixUtil evalRemoteMangoScript];

// exec local mangofix file
[mangoFixUtil evalLocalMangoScript];

// exec local unEncrypted mangofix file
[mangoFixUtil evalLocalUnEncryptedMangoScriptWithPublicKey:RSAPublicKey];

// encrypt plain mangofix file to documentDirectory
[mangoFixUtil encryptPlainScirptToDocumentWithPublicKey:RSAPublicKey];

```
## Update

#### V1.0.6
1. 增加开发预览、全量下发模式

#### V2.0.0
1. 增加激活设备、激活补丁统计

#### V2.0.1
1. 优化

## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
