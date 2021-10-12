//
//  MangoFixUtil.h
//  Easyder
//
//  Created by xuhonggui on 2020/4/9.
//  Copyright © 2020 xuhonggui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoFixUtil : NSObject

+ (instancetype)sharedUtil;

/**
 * 补丁下载地址
 */
@property (nonatomic, copy) NSString *url;

/**
 * 成功状态码，默认201
 */
@property (nonatomic, assign) NSInteger statusCode;

/**
 * 初始化
 * debug 默认为NO
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
 * 执行本地补丁（已加密），默认查找本地文件名为encrypted_demo.mg的补丁并执行
 */
- (void)evalLocalMangoScript;

/**
 * 执行本地补丁（未加密），默认查找本地文件名为demo.mg的补丁并执行
 * @param publicKey 公钥
 */
- (void)evalLocalUnEncryptedMangoScriptWithPublicKey:(NSString*)publicKey;

/**
 * 加密补丁，默认查找本地文件名为demo.mg的补丁，并加密至Document
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
