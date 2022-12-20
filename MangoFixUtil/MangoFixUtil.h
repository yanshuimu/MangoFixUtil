//
//  MangoFixUtil.h
//
//  Created by xhg on 2020/4/9.
//  Copyright © 2020 xhg. All rights reserved.
//

// 注意：本库需搭配补丁管理后台一起使用
// http://patchhub.top
// Github地址：
// https://github.com/yanshuimu/MangoFixUtil
// 脚本语法参考：
// https://github.com/YPLiang19/Mango
// 如需帮助，请联系QQ：593692553

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MangoFixUtil : NSObject

/**
 * YES  简易模式 - 不统计日活量、补丁激活数、设备数量等
 * NO    完整模式 - 默认该方式
 */
@property(nonatomic, assign) BOOL isSimpleMode;

/**
 * 扩展字段，暂未使用
 */
@property (nonatomic, strong) NSString *extend;

/**
 * 单例
 */
+ (instancetype)sharedUtil;

/**
 * 初始化
 */
+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

/**
 * 初始化
 * 通过UserId、BundleId可识别唯一App
 */
+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

/**
 * 初始化
 */
- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey;

/**
 * 初始化
 * 通过UserId、BundleId可识别唯一App
 */
- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey;

/**
 * 初始化
 * @param debug  分发规则 - YES 开发设备  NO 全量设备
 */
- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug;

/**
 * 初始化
 * 通过UserId、BundleId可识别唯一应用
 * @param debug  分发规则 - YES 开发设备  NO 全量设备
 */
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
 * @return 已加密补丁路径
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

@end

NS_ASSUME_NONNULL_END
