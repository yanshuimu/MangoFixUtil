## Introduce

MangoFixUtil是对[MangoFix](https://github.com/YPLiang19/Mango)进行了简单的封装，该库在OC项目中实战已经近2年多，经过多次迭代，比较成熟。但需要搭配[补丁管理后台](https://patchhub.top/mangofix/login)一起使用，后台由作者开发维护，目前有40+个已上架AppStore的应用在使用，且有日活1w+的应用，欢迎小伙伴们使用。

如果你觉得不错，可以给个小星星，在此表示感谢^_^。

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

## Update

#### v2.1.4
1. 优化

#### v2.1.3
1. 优化

#### v2.1.2
1. 使用MangoFix.framework（v1.5.2）替换CocoaPods依赖以支持Swift项目使用。
2. 支持简易模式、补丁内容打印。
3. 简化代码，优化流程。

#### v2.1.1
1. 支持通过UserId、BundleId识别唯一App。

#### v2.1.0
1. 支持AES加密方式，适配MangoFix 1.5.0以上版本。

#### v2.0.4
1. 支持日活量统计。

#### v2.0.3
1. 优化流程。

#### v2.0.2
1. 支持线上加密补丁。

#### v2.0.1
1. 优化。

#### v2.0.0
1. 支持设备数、激活数统计。

#### v1.0.6
1. 支持开发设备、全量设备。

## Thanks for
[Mango](https://github.com/YPLiang19/Mango)
