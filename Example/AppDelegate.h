//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//APPID，请登录后台新建应用后获取APPID
#define APPID @"5cdf2ac2520f450d"

#define USERID @"10000"

//AES128秘钥，长度需为16个字节的倍数
#define AESKEY @"2C85rbObk2EoDinV"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

