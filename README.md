# MangoFixUtil

依赖[MangoFix](https://github.com/YPLiang19/Mango)，封装补丁拉取、执行完整流程，提供拉取补丁、执行远程补丁、执行本地补丁、执行本地未加密补丁、生成加密补丁等方法。

补丁发布欢迎使用作者维护的[后台](http://1.15.68.8:8080/mangofix/login)

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
