//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//APPID，请登录后台新建应用后获取APPID
#define APPID @"def068fe489546ae"

//AES128秘钥，长度需为16个字节的倍数
#define AES128KEY @"1234123412341234"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

