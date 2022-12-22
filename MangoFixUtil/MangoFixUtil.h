//
//  MangoFixUtil.h
//
//  Created by xhg on 2020/4/9.
//  Copyright © 2020 xhg. All rights reserved.
//

/**
 * 本库需搭配补丁管理后台一起使用
 * http://patchhub.top
 *
 * Github地址：
 * https://github.com/yanshuimu/MangoFixUtil
 *
 * 语法参考：
 * https://github.com/YPLiang19/Mango
 *
 * 注意：AES128密钥长度需为16的倍数，举个栗子：xWx2TilxtpHlvQrT
 *
 * 如需帮助，请联系QQ：593692553
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoFixUtil : NSObject

/**
 * 控制是否简易模式，默认NO
 * 简易模式 - 不统计日活量、补丁激活数、设备数量等
 */
@property(nonatomic, assign) BOOL isSimpleMode;

/**
 * 控制是否Debug打印模式，默认YES
 */
@property(nonatomic, assign) BOOL isLogModeDebug;

/**
 * 扩展字段，暂未使用
 */
@property (nonatomic, strong) NSString *extend;

/**
 * 单例
 */
+ (instancetype)sharedUtil;

/**
 * 以 AppId 初始化
 * debug  控制分发规则  YES 开发设备  NO 全量设备
 */
+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * 以 UserId 初始化
 * debug  控制分发规则  YES 开发设备  NO 全量设备
 * 注意：以该方式初始化，需登录后台 -> 应用管理 -> 编辑 -> 填写BundleId
 */
+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug;

- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * 执行未加密补丁，查找并执行项目中文件名为<demo.mg>的补丁
 */
- (void)evalLocalUnEncryptedMangoScript;

/**
 * 执行已加密补丁，查找并执行项目中文件名为<encrypted_demo.mg>的补丁
 */
- (void)evalLocalEncryptedMangoScript;

/**
 * 加密补丁，查找项目中文件名为<demo.mg>的补丁，加密后保存至沙盒Documents目录中
 * @result 已加密补丁路径
 */
- (NSString*)encryptPlainScriptToDocument;

/**
 * 执行远程补丁
 */
- (void)evalRemoteMangoScript;

/**
 * 删除沙盒Caches目录中文件名为<demo.mg>的补丁，重启App后生效
 */
- (void)deleteLocalMangoScript;

/**
 *  AES128加密
 */
+ (NSData*)encrypt:(NSString*)string key:(NSString*)key iv:(NSString*)iv;

/**
 * AES128解密
 */
+ (NSString*)decrypt:(NSData*)data key:(NSString*)key iv:(NSString*)iv;

@end

NS_ASSUME_NONNULL_END
