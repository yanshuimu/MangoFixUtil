[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/MangoFixUtil.svg)](https://img.shields.io/cocoapods/v/MangoFixUtil.svg)
[![Platform](https://img.shields.io/cocoapods/p/MangoFixUtil.svg?style=flat)](http://cocoadocs.org/docsets/MangoFixUtil)

## Introduce

MangoFixUtil是一个iOS平台的热更新库，基于[MangoFix](https://github.com/YPLiang19/Mango)，拓展增加了统计激活数、应用日活量、在线日志等功能。该库在项目中经过多年实战并多次迭代，已可以满足线上应用的日常问题修复。

注意：模拟器运行需用Rosetta方式

需搭配补丁管理后台[PatchHub](https://patchhub.top/mangofix/login)使用，目前AppStore中使用MangoFixUtil的有效应用数量已达140+，尚未出现因此库导致审核被拒的情况，平台已稳定运行4年，且会一直坚持不会有任何形式的收费。

## Example

```objc
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    // 我们把初始化放在最前面，这样的好处是在该方法后面执行的代码都可以被修复
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

推荐使用[CocoaPods](http://cocoapods.org)方式添加MangoFixUtil到您的项目中

```ruby
# Podfile
pod 'MangoFixUtil', '~> 2.1.6'
```

## Usage

### Objective-C

1、在发布补丁前我们需要在项目根目录下`demo.mg`文件中编写补丁代码并运行项目进行调试，直至补丁执行成功并能有效修复某个方法。

```objc
MangoFixUtil *util = [MangoFixUtil startWithAppId:APPID aesKey:AES128KEY];
// 执行未加密补丁
[util evalLocalUnEncryptedMangoScript];
```

2、补丁文件开发完成后，需登录[补丁管理后台](https://patchhub.top/mangofix/login)发布补丁，并运行项目执行远程补丁进行验证是否有效。假如远程补丁能够有效修复某个方法，则整个流程已完成，用户打开app会自动拉取该补丁进行修复。
假如远程补丁未起作用，则需撤回补丁进行原因排查。

```objc
MangoFixUtil *util = [MangoFixUtil startWithAppId:APPID aesKey:AES128KEY];
// 执行远程补丁
[util evalRemoteMangoScript];
```

发布补丁时默认选择自动加密补丁，后台会使用您在平台配置的AES Key对补丁进行加密，如果需要上传已加密的补丁，则上传前需要验证已加密补丁是否有效，将已加密补丁拖入项目根目录中，名称需为`encrypted_demo.mg`，运行项目进行验证。

```objc
MangoFixUtil *util = [MangoFixUtil startWithAppId:APPID aesKey:AES128KEY];
// 执行已加密补丁
[util evalLocalEncryptedMangoScript];
```

SDK 提供了在线日志功能，可以记录您需要记录的信息，如可以用来记录审核时访问的页面，点击的按钮，也可以用于记录难以重现的线上问题用户的操作行为，访问接口提交的参数，甚至用于远程开发等等。

```objc
MangoFixUtil *util = [MangoFixUtil startWithAppId:APPID aesKey:AES128KEY];
[util log:@"xxx" msg:@"xxx"];
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

## 最新 2.1.6 @2024.11.27
### SDK
- 新增代理方法
- 修复偶现补丁激活数大于设备数的问题
- 修复偶现补丁失效的问题

## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
