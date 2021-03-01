//
//  AppDelegate.m
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "MangoFixUtil.h"

#define RSAPrivateKey @"-----BEGIN PRIVATE KEY-----MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAN3EuZ7vu3lN0s2067OIM4UR4eaMRthBznA254s8uS2OQ7WEJqhqxKUIszQwVfq3BhjxN/1hslLUwskSljfMfBHob9+FbZMA2YgLZ0Vt4kiOk/RTefuTstjInBoa/XW/IX/YE9q7wGaikHisDfs+8mIvpd7Kedmso2zX3ejWmmHTAgMBAAECgYB8iHY7/B9otP0Fqu0Y+gkEVtBmKKu30OxeM1a+57CNFnCLQ9R5iss2abZIPkRp79EqvHpWfUAoJ3Xid9+HIfsg/1W+FjhTAeyevDGclGHrXeq52/5PPE7utrc7MLUDODf6fmFi0ATE8m8cgbN5QGK2u8nmHtXK5cKh2LexZRtyYQJBAPqeaVeHg0H5pWcrf+FXInGoiN125yePJH6nDRaEOh6TUEVguOw1Y2OM3p8gjeT6cBFzxgtvUAxlxaj3hPpy1msCQQDih7sEfit/tyGzRS9Wi+bh/IwfPWtbIzJA0TakulCq+zYjHDB6eOf0rijsjb7n/9OFdlK6QYVUhP99MAbrmuw5AkEA211VL3w588GkeY2lvYQbbgjq445z/jhY5VMrLY5HoQOou1FSC88fU7+2DOrdyJM9DMmdi9y+4FskjCU7jEyASQJAZW6DNhrMnW5Bv8TN0oHoSu5LS72zsWZMHSvQvOfUMQs1DXmU13IF4tCM8IbzoWwyqUL2/gFSkyrOP57eqmZ/OQJBAJu3/aQ+u6oeetUjKdE+UPV1P1+7tX3EW4aXubRwOZ3RkPp2ZpGdtlooM5AI0t7l+yIe+rRV9HkrvTdKd3hiUOY=-----END PRIVATE KEY-----"

#if RELEASE
#else
#define RSAPublicKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDdxLme77t5TdLNtOuziDOFEeHmjEbYQc5wNueLPLktjkO1hCaoasSlCLM0MFX6twYY8Tf9YbJS1MLJEpY3zHwR6G/fhW2TANmIC2dFbeJIjpP0U3n7k7LYyJwaGv11vyF/2BPau8BmopB4rA37PvJiL6XeynnZrKNs193o1pph0wIDAQAB-----END PUBLIC KEY-----"
#endif

#define MANGOFIXUTIL_APPID @"8c97497aeafe4513bbf830bb0b558f40"

#define Url_MangoFix @"http://1.15.68.8:8080/mangofix/api/getmangofile"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor clearColor];
    
    //建议放在其它方法之前，APP启动后先执行补丁
    [self setupMangoFixUtil];
    
    [self gotoHome];
    
    return YES;
}

- (void)gotoHome {
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (void)setupMangoFixUtil {
    
    MangoFixUtil *mangoFixUtil = [MangoFixUtil sharedUtil];
    mangoFixUtil.url = Url_MangoFix;
    [mangoFixUtil startWithAppId:MANGOFIXUTIL_APPID privateKey:RSAPrivateKey];
    [mangoFixUtil evalRemoteMangoScript];
}

@end
