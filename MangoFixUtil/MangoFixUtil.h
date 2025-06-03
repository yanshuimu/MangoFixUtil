//
//  MangoFixUtil.h
//
//  Created by xhg on 2020/4/9.
//  Copyright © 2020 xhg. All rights reserved.
//

/**
 * 平台地址：
 * https://patchhub.top
 *
 * Github：
 * https://github.com/yanshuimu/MangoFixUtil
 *
 * Gitee：
 * https://gitee.com/xhg8131/mango-fix-util
 *
 * 语法参考：
 * https://github.com/YPLiang19/Mango
 *
 * QQ群：1028778036
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MangoFixUtil;

@protocol MangoFixUtilDelegate <NSObject>

@optional

/**
 * @brief  当上一次拉取的补丁执行成功后会回调此方法
 */
- (void)didExecuteLastPatch:(MangoFixUtil *)util;

/**
 * @brief  当远程补丁下载成功后会回调此方法
 */
- (void)didDownloadRemotePatch:(MangoFixUtil *)util;

/**
 * @brief  当远程补丁执行成功后会回调此方法
 *
 * @note   假如启动APP时，需修复的代码在此方法调用前已经被执行，可在此回调方法中进行处理，如更新UI
 */
- (void)didExecuteRemotePatch:(MangoFixUtil *)util;

/**
 * @brief  当捕获到异常时会回调此方法
 */
- (void)mangoFixUtil:(MangoFixUtil *)util didCatchException:(NSException *)exception;

@end

@interface MangoFixUtil : NSObject

/**
 * @brief  设置是否简易模式，默认为NO
 *
 * @note   当为YES时，不会统计日活量、激活量等
 */
@property(nonatomic, assign) BOOL isSimpleMode;

/**
 * @brief  设置是否Debug打印模式，默认为YES
 */
@property(nonatomic, assign) BOOL isLogModeDebug;

/**
 * @brief  扩展字段，暂未使用
 */
@property (nonatomic, strong) NSString *extend;

/**
 * @brief  代理
 */
@property (nonatomic, weak) id<MangoFixUtilDelegate> delegate;

/**
 * @brief  创建实例（单例模式）
 */
+ (instancetype)sharedUtil;

/**
 * @warning  -init方法不支持，请使用单例方法创建实例
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 * @brief  类方法初始化
 *
 * @param  appId  应用ID
 * @param  aesKey  AES Key
 *
 * @return 返回实例
 */
+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

/**
 * @brief  类方法初始化
 *
 * @param  appId     应用ID
 * @param  aesKey   AES Key
 * @param  debug     设置分发规则  YES 开发模式  NO 生产模式
 *
 * @return 返回实例
 */
+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * @brief  实例方法初始化
 *
 * @param  appId  应用ID
 * @param  aesKey  AES Key
 *
 * @return 返回实例
 */
- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

/**
 * @brief  类方法初始化
 *
 * @param  appId     应用ID
 * @param  aesKey   AES Key
 * @param  debug     设置分发规则  YES 开发模式  NO 生产模式
 *
 * @return 返回实例
 */
- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * @brief  类方法初始化
 *
 * @param  userId   用户ID
 * @param  aesKey   AES Key
 *
 * @note   以此方式初始化，需配置Bundle ID，请登录后台 https://patchhub.top，在应用管理，编辑应用，填写Bundle ID
 */
+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

/**
 * @brief  类方法初始化
 *
 * @param  userId   用户ID
 * @param  aesKey   AES Key
 * @param  debug     设置分发规则  YES 开发模式  NO 生产模式
 *
 * @note   以此方式初始化，需配置Bundle ID，请登录后台 https://patchhub.top，在应用管理，编辑应用，填写Bundle ID
 */
+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * @brief  实例方法初始化
 *
 * @param  userId   用户ID
 * @param  aesKey   AES Key
 *
 * @note   以此方式初始化，需配置Bundle ID，请登录后台 https://patchhub.top，在应用管理，编辑应用，填写Bundle ID
 */
- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

/**
 * @brief  类方法初始化
 *
 * @param  userId   用户ID
 * @param  aesKey   AES Key
 * @param  debug     设置分发规则  YES 开发模式  NO 生产模式
 *
 * @note   以此方式初始化，需配置Bundle ID，请登录后台 https://patchhub.top，在应用管理，编辑应用，填写Bundle ID
 */
- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * @brief  执行未加密补丁
 *
 * @note  此方法会查找并执行项目中文件名为[demo.mg]的补丁，用于编写补丁代码后进行调试
 */
- (void)evalLocalUnEncryptedMangoScript;

/**
 * @brief  执行已加密补丁
 *
 * @note  此方法查找并执行项目中文件名为[encrypted_demo.mg]的补丁，用于编写补丁代码后，假如需要上传已加密补丁，可用此方法进行验证已加密的补丁是否有效
 */
- (void)evalLocalEncryptedMangoScript;

/**
 * @brief  加密补丁
 *
 * @note  查找项目中文件名为[demo.mg]的补丁，加密后保存至沙盒Documents目录中，仅用于模拟器环境
 *
 * @result 已加密补丁路径
 */
- (NSString*)encryptPlainScriptToDocument;

/**
 * @brief  执行远程补丁
 *
 * @note  用于App发布后，拉取并执行已发布的补丁，或开发调试时进行验证已发布的补丁是否有效
 */
- (void)evalRemoteMangoScript;

/**
 * @brief  删除沙盒Documents目录中文件名为[demo.mg]的补丁
 *
 * @note  重启App才会生效
 */
- (void)deleteLocalMangoScript;

/**
 * @brief  在线日志
 *
 * @param  object   路径
 * @param  msg   详细信息
 *
 * @note  用于记录您想记录的任意信息，需登录后台 https://patchhub.top， 在应用管理，编辑应用中开启[在线日志]功能，以及在系统设置中开启[在线日志]功能，需同时开启
 * @note  记录成功后，可在后台 https://patchhub.top， 在线日志处查看数据
 */
- (void)log:(id)object msg:(NSString*)msg;

/**
 * @brief  AES128加密
 *
 * @param  string   待加密的字符串
 * @param  key   AES key
 * @param  iv     AES iv
 */
+ (NSData*)encrypt:(NSString*)string key:(NSString*)key iv:(NSString*)iv;

/**
 * @brief  AES128解密
 *
 * @param  data   待解密的二进制数据
 * @param  key   AES key
 * @param  iv     AES iv
 */
+ (NSString*)decrypt:(NSData*)data key:(NSString*)key iv:(NSString*)iv;

@end

NS_ASSUME_NONNULL_END
