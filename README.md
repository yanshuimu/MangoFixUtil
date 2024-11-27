[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MangoFixUtil.svg)](https://img.shields.io/cocoapods/v/MangoFixUtil.svg)
[![Platform](https://img.shields.io/cocoapods/p/MangoFixUtil.svg?style=flat)](http://cocoadocs.org/docsets/MangoFixUtil)

## Introduce

MangoFixUtil是一个iOS平台的热更新库，基于[MangoFix](https://github.com/YPLiang19/Mango)，拓展增加了统计激活数、应用日活量、在线日志等功能。该库在项目中经过多年实战并多次迭代，已可以满足线上应用的日常问题修复。

注意：模拟器运行需用Rosetta方式

热更新补丁的分发管理由[PatchHub](https://patchhub.top/mangofix/login)提供技术支持，截至24年8月，AppStore中使用MangoFixUtil的有效应用数量已达140+，该平台已稳定运营3年，且会一直坚持不会有任何形式的收费。如果你觉得不错，可以给个小星星支持！

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
    
    [[MangoFixUtil startWithAppId:APPID aesKey:AES128KEY] evalRemoteMangoScript];
}

@end
```
## Installation

### CocoaPods

```ruby
# Your Podfile
pod 'MangoFixUtil'
```

## Usage

### Objective-C
`#import <MangoFixUtil/MangoFixUtil.h>`

```objc
MangoFixUtil *util = [MangoFixUtil startWithAppId:APPID aesKey:AES128KEY];

// exec local unEncrypted mangofix file
[util evalLocalUnEncryptedMangoScript];

// encrypt plain mangofix file to document directory
[util encryptPlainScriptToDocument];

// exec local encrypted mangofix file
[util evalLocalEncryptedMangoScript];

// exec mangofix file from network
[util evalRemoteMangoScript];

```

### Swift
`import MangoFixUtil`

```swift
let util = MangoFixUtil.start(withAppId: kAppId, aesKey: kAesKey)

// exec local unEncrypted mangofix file
util.evalLocalUnEncryptedMangoScript()

// encrypt plain mangofix file to document directory
util.encryptPlainScriptToDocument()

// exec local encrypted mangofix file
util.evalLocalEncryptedMangoScript()

// exec mangofix file from network
util.evalRemoteMangoScript()

```

## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
