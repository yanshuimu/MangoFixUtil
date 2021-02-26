//
//  EDMangoFix.h
//  Easyder
//
//  Created by xuhonggui on 2020/4/9.
//  Copyright © 2020 xuhonggui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EDMangoFixUtil : NSObject

+ (instancetype)sharedUtil;

//url
@property (nonatomic, copy) NSString *url;
//成功状态码，默认201
@property (nonatomic, assign) NSInteger statusCode;

/**
 * 初始化
 */
- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey;

/**
 * 初始化
 */
- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey debug:(BOOL)debug;

/**
 * 执行步骤：
 * 1、如果沙盒中存在旧补丁，执行1次
 * 2、拉取远程补丁，并保存至沙盒中
 * 3、执行1次新补丁
 * 补丁名称：demo.mg
 */
- (void)evalRemoteMangoScript;

/**
 * 执行本地补丁
 * 补丁名称：encrypted_demo.mg
 */
- (void)evalLocalMangoScript;

/**
 * 获取本地名称为demo.mg的补丁内容，传入publicKey进行加密后执行
 * publicKey必须与privateKey相对应
 */
- (void)evalLocalUnEncryptedMangoScriptWithPublicKey:(NSString*)publicKey;

/**
 * 获取本地名称为demo.mg的补丁内容，传入publicKey进行加密后保存至沙盒，保存名称为encrypted_demo.mg
 * 返回值为encrypted_demo.mg在沙盒中的路径
 * publicKey必须与privateKey相对应
 */
- (NSString*)encryptPlainScirptToDocumentWithPublicKey:(NSString*)publicKey;

@end

NS_ASSUME_NONNULL_END
