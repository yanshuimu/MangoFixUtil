//
//  MangoFixUtil.h
//
//  Created by 许鸿桂 on 2020/4/9.
//  Copyright © 2020 许鸿桂. All rights reserved.
//

/*
 补丁管理后台：http://patchhub.top/
 
 公私钥在线生成：http://www.metools.info/code/c80.html/ 密钥长度：1024 bit，密钥格式：PKCS#8
 
 如需帮助，请联系QQ：593692553、微信：hongguixu8131支持
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoFixUtil : NSObject

+ (instancetype)sharedUtil;

/**
 * 补丁地址
 */
@property (nonatomic, copy) NSString *url;

/**
 * 成功状态码，默认201
 */
@property (nonatomic, assign) NSInteger statusCode;

/**
 * 当检测不到补丁时（如：APP升级新版本），是否自动清除本地旧版本补丁，默认为 YES 自动清理
 * 需重启APP生效
 */
@property (nonatomic, assign) BOOL autoClearLastPath;

/**
 * 是否统计日活量，默认为 YES
 */
@property (nonatomic, assign) BOOL countDailyActiveUser;

/**
 * 扩展字段
 */
@property (nonatomic, strong) NSString *extendField;

/**
 * 初始化
 * debug 默认为 NO 全量下发
 */
- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey;

/**
 * 初始化
 * @param debug YES 开发预览 NO 全量下发
 */
- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey debug:(BOOL)debug;

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
 * @param publicKey 公钥
 */
- (void)evalLocalUnEncryptedMangoScriptWithPublicKey:(NSString*)publicKey;

/**
 * 加密补丁，查找本地文件名为demo.mg的补丁，并加密至Document中
 * @param publicKey 公钥
 * @return 已加密补丁路径
 */
- (NSString*)encryptPlainScirptToDocumentWithPublicKey:(NSString*)publicKey;

/**
 * 删除Document中已拉取的远程补丁或本地生成的加密补丁
 */
- (void)deleteLocalMangoScript;

@end

NS_ASSUME_NONNULL_END
