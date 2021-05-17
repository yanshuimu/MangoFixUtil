# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行完整流程，另外提供本地加密或未加密补丁执行、生成加密补丁等方法。具体使用方法请下载MangoFixUtil项目参考里面的demo。

欢迎使用作者维护的[补丁管理后台](http://patchhub.top/mangofix/login)。

MangoFixUtil在公司项目中实战已经近1年，基本很稳定，也会不断继续完善。第一个补丁诞生于2020-03-09，最初是用PostMan操作，后来有了界面，也是比较简陋，一直处于自用状态。最近才加上登录、注册功能，开放出来供有需要的同学使用。

如遇CocoaPods方式报错（1.0.3版本及以下），请用手动导入方式。

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
    mangoFixUtil.url = Url_MangoFile;
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
mangoFixUtil.url = Url_MangoFix;
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
## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
