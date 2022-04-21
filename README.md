# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行、设备激活、补丁激活完整流程，具体使用方法请下载Demo参考。

MangoFixUtil在公司项目中实战已经近1年多，很稳定，也会不断继续完善。

欢迎使用作者维护的[补丁管理后台](http://patchhub.top/mangofix/login)，第一个补丁诞生于2020-03-09，最初是用PostMan操作，后来有了界面，也是比较简陋，一直都是自己和朋友在使用，目前已经有30+个已上架AppStore的应用在使用，现开放出来给有需要的小伙伴使用。

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
    [mangoFixUtil startWithAppId:APPID aesKey:AES128KEY];
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
[mangoFixUtil startWithAppId:APPID aesKey:AES128KEY];

// exec mangofix file from network
[mangoFixUtil evalRemoteMangoScript];

// exec local mangofix file
[mangoFixUtil evalLocalMangoScript];

// exec local unEncrypted mangofix file
[mangoFixUtil evalLocalUnEncryptedMangoScript];

// encrypt plain mangofix file to documentDirectory
[mangoFixUtil encryptPlainScriptToDocument];

```
## Update

#### V2.1.0
1. 增加AES加密方式，支持MangoFix 1.5.0版本

#### V2.0.4
1. 支持统计日活量

#### V2.0.3
1. 优化流程

#### V2.0.2
1. 支持线上加密补丁

#### V2.0.1
1. 优化

#### V2.0.0
1. 增加激活设备、激活补丁统计

#### V1.0.6
1. 增加开发预览、全量下发模式

## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
