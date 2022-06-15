# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行、设备激活、补丁激活完整流程，具体使用方法请下载Demo参考。

该库在项目中实战已经近2年多，经过多次迭代，比较成熟。

另有自己维护的[补丁管理后台](http://patchhub.top/mangofix/login)，目前已经有40+个已上架AppStore的应用在使用，且有日活1w的应用，欢迎小伙伴们使用。

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

#### V2.1.1
1. 支持通过UserId、BundleId识别唯一应用

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
