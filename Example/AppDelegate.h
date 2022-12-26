//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//APPID，请登录后台新建应用后获取APPID
#define APPID @"330eb766152b4c9a"

#define USERID @"10000"

//AES128秘钥，长度需为16个字节的倍数
#define AES128KEY @"X9t/9zN8Hyw1Nn49"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

