//
//  MangoFixUtil.h
//
//  Created by 许鸿桂 on 2020/4/9.
//  Copyright © 2020 许鸿桂. All rights reserved.
//

/*
 补丁管理后台：http://patchhub.top/
  
 如需帮助，请联系QQ：593692553、微信：hongguixu8131支持
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoFixUtil : NSObject

+ (instancetype)sharedUtil;

/**
 * APP更新版本后是否清除本地旧版本补丁
 * 需重启APP生效
 * 默认为 YES
 */
@property (nonatomic, assign) BOOL clearLastPathAfterVersionUpdateEnabled;

/**
 * 是否统计日活量，默认为 YES
 */
@property (nonatomic, assign) BOOL dailyActiveUserEnabled;

/**
 * 扩展字段
 */
@property (nonatomic, strong) NSString *extend;

/**
 * 初始化
 */
- (void)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

/**
 * 初始化
 * 通过UserId、BundleId识别唯一应用
 */
- (void)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

/**
 * 初始化
 * @param debug YES 开发预览 NO 全量下发
 */
- (void)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * 初始化
 * @param debug YES 开发预览 NO 全量下发
 * 通过UserId、BundleId识别唯一应用
 */
- (void)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * 执行远程补丁
 */
- (void)evalRemoteMangoScript;

/**
 * 执行本地补丁（已加密），查找本地文件名为encrypted_demo.mg的补丁并执行
 */
- (void)evalLocalMangoScript;

/**
 * 执行本地补丁（未加密），查找本地文件名为demo.mg的补丁并执行
 */
- (void)evalLocalUnEncryptedMangoScript;

/**
 * 加密补丁，查找本地文件名为demo.mg的补丁，并加密至Document中
 * @return 已加密补丁路径
 */
- (NSString*)encryptPlainScriptToDocument;

/**
 * 删除Document中已拉取的远程补丁或本地生成的加密补丁
 */
- (void)deleteLocalMangoScript;

@end

NS_ASSUME_NONNULL_END
