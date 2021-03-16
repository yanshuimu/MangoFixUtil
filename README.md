# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行完整流程，另外提供本地加密或未加密补丁执行、生成加密补丁等方法。。

欢迎使用作者维护的[补丁管理后台](http://1.15.68.8:8080/mangofix/login)。

MangoFixUtil在公司项目中实战已经近1年，第一个补丁诞生于2020-05-09，一直都很稳定，最初是用PostMan操作，后台管理界面也是比较简陋，一直处于自用状态。最近才加上登录、注册功能，开放出来供有需要的同学使用。

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
