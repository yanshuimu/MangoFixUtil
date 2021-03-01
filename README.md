# MangoFixUtil

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
    mangoFixUtil.url = Url_MangoFix;
    [mangoFixUtil startWithAppId:MANGOFIXUTIL_APPID privateKey:RSAPrivateKey];
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
