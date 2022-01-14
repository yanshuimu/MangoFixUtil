//
//  MangoFixUtil.m
//
//  Created by 许鸿桂 on 2020/4/9.
//  Copyright © 2020 许鸿桂. All rights reserved.
//

#import "MangoFixUtil.h"
#import "PHKeyChainUtil.h"
#import "PHNetworkDefine.h"
#import "PHCacroDefine.h"
#if __has_include(<MangoFix/MangoFix.h>)
#import <MangoFix/MangoFix.h>
#define Has_Include_MangoFix
#endif

typedef void(^Succ)(id responseObject);

typedef void(^Fail)(NSString *msg);

@interface MangoFixUtil ()

/**
 * 应用id
 */
@property (nonatomic, copy) NSString *appId;

/**
 * 规则 YES 开发设备 NO 全量设备
 */
@property (nonatomic, assign) BOOL debug;

/**
 * 私钥
 */
@property (nonatomic, copy) NSString *privateKey;

/**
 * 公共参数
 */
@property (nonatomic, strong) NSDictionary *baseParams;

@end

@implementation MangoFixUtil

+ (instancetype)sharedUtil {
    static MangoFixUtil *util = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        util = [[self alloc] init];
    });
    return util;
}

- (instancetype)init {
    if (self = [super init]) {
        _statusCode = 201;
        _autoClearLastPath = YES;
        _url = PH_Url_GetMangoFile;
    }
    return self;
}

- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey {
    [self startWithAppId:appId privateKey:privateKey debug:NO];
}

- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey debug:(BOOL)debug {
    
    NSAssert(!MFStringIsEmpty(privateKey), @"The private key is nil or empty!");
    _appId = appId;
    _debug = debug;
    _privateKey = privateKey;
}

- (void)evalRemoteMangoScript {
    
    
    @try {
        //先执行上一次补丁
        [self evalLastPatch];
    }
    @catch (NSException *exception) {
        MFLog(@"%@", exception);
    }
    @finally {
        //激活设备
        [self activateDevice];
        //检测是否有新的补丁
        [self requestCheckRemotePatch];
    }
}

- (void)evalLocalMangoScript {
        
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"encrypted_demo" ofType:@"mg"];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (script && script.length > 0) {
        [self evalMangoScriptWithRSAEncryptedBase64String:script];
        MFLog(@"The local patch is successfully executed!");
    }
    else {
        MFLog(@"The local patch content is empty!");
    }
}

- (void)evalLocalUnEncryptedMangoScriptWithPublicKey:(NSString*)publicKey {
        
    NSString *script = [self encryptScirptWithPublicKey:publicKey];
    if (script && script.length > 0) {
        [self evalMangoScriptWithRSAEncryptedBase64String:script];
        MFLog(@"The local unencrypted patch is successfully executed!");
    }
    else {
        MFLog(@"The local unencrypted patch content is empty!");
    }
}

- (void)deleteLocalMangoScript {
    
    NSError *outErr = nil;
    NSString *filePath= (NSString *)[MFCachesDirectory stringByAppendingPathComponent:@"demo.mg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&outErr];
        if (outErr) goto err;
        {
            MFLog(@"The local patch was successfully deleted! Please restart the device!");
        }
        err:
        if (outErr) MFLog(@"%@",outErr);
    }
}

- (void)evalLastPatch {
    
    NSString *filePath = [MFCachesDirectory stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        if (script && script.length > 0) {
            [self evalMangoScriptWithRSAEncryptedBase64String:script];
            MFLog(@"The last patch is successfully executed!");
        }
        else {
            MFLog(@"The last patch content is empty!");
        }
    }
    else {
        MFLog(@"The last patch does not exist!");
    }
}

- (void)evalRemotePatchWithFileId:(NSString*)fileId {
    
    __weak typeof(self) weakSelf = self;
    
    [self requestPostWithUrl:_url params:nil succ:^(id responseObject) {
        NSData *data = responseObject;
        NSString *filePath = [MFCachesDirectory stringByAppendingPathComponent:@"demo.mg"];
        if ([data writeToFile:filePath atomically:YES]) {
            //存储最新补丁id
            [MFUserDefaults setObject:fileId forKey:MFLocalPatchKey(weakSelf.appId)];
            [MFUserDefaults synchronize];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
                if (script && script.length > 0) {
                    [weakSelf evalMangoScriptWithRSAEncryptedBase64String:script];
                    MFLog(@"The latest patch is successfully executed!");
                    //激活补丁
                    [weakSelf activatePatchWithFileId:fileId];
                }
            }
        }
        else {
            MFLog(@"Failed to save the latest patch!");
        }
    } fail:nil];
}

- (void)activateDevice {
    
    if (_debug) return;
    
    NSString *key = MFDeviceKey(_appId, MFBundleShortVersion);
    NSString *value = [PHKeyChainUtil load:key];
    
    if (value.intValue == 1) {
        //设备已激活
        return;
    }
    
    MFLog(@"Device not activated!");
    
    [self requestPostWithUrl:PH_Url_ActivateDevice params:nil succ:^(id responseObject) {
        [PHKeyChainUtil save:key data:@"1"];
        MFLog(@"Device is activate successfully!");
    } fail:nil];
}

- (void)activatePatchWithFileId:(NSString*)fileId {
        
    if (_debug || MFStringIsEmpty(fileId)) {
        return;
    }
    
    NSString *key = MFPatchKey(fileId);
    NSString *value = [PHKeyChainUtil load:key];
    
    if (value.intValue == 1) {
        //已激活
        return;
    }
    
    MFLog(@"Patch not activated!");
    
    [self requestPostWithUrl:PH_Url_ActivatePatch params:@{@"fileid": fileId} succ:^(id responseObject) {
        [PHKeyChainUtil save:key data:@"1"];
        MFLog(@"Patch is activate successfully!");
    } fail:nil];
}

- (NSString*)encryptScirptWithPublicKey:(NSString*)publicKey {
    
    NSString *result = nil;
    NSError *outErr = nil;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *planScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    {
        NSString *encodePublicKey = [NSString stringWithCString:[publicKey UTF8String] encoding:NSUTF8StringEncoding];
        if (outErr) goto err;
        result = [self encryptString:planScriptString publicKey:encodePublicKey];
    }
    
    err:
    if (outErr) MFLog(@"%@",outErr);
    return result;
}

- (NSString*)encryptPlainScirptToDocumentWithPublicKey:(NSString*)publicKey {
    
    NSError *outErr = nil;
    BOOL writeResult = NO;
    NSString * encryptedPath = nil;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *planScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    
    {
        NSString *encodePublicKey = [NSString stringWithCString:[publicKey UTF8String] encoding:NSUTF8StringEncoding];
        if (outErr) goto err;
        NSString *encryptedScriptString = [self encryptString:planScriptString publicKey:encodePublicKey];;
        
        encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:encryptedPath]) {
            [fileManager createFileAtPath:encryptedPath contents:nil attributes:nil];
        }
        MFLog(@"The encrypted patch path: %@", encryptedPath);
        writeResult = [encryptedScriptString writeToFile:encryptedPath atomically:YES encoding:NSUTF8StringEncoding error:&outErr];
    }
    
    err:
    if (outErr) MFLog(@"%@",outErr);
    return encryptedPath;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

#pragma mark - MangoFix

- (id)context {
    
#ifdef Has_Include_MangoFix
    return [[MFContext alloc] initWithRSAPrivateKey:_privateKey];
#endif
    return nil;
}

- (void)evalMangoScriptWithRSAEncryptedBase64String:(NSString*)script {
    
#ifdef Has_Include_MangoFix
    [[self context] evalMangoScriptWithRSAEncryptedBase64String:script];
#endif
}

- (id)encryptString:(NSString*)string publicKey:(NSString*)publicKey {

#ifdef Has_Include_MangoFix
    return [MFRSA encryptString:string publicKey:publicKey];
#else
    return nil;
#endif
}

#pragma mark - Network

- (void)requestCheckRemotePatch {
    
    NSString *currentFileId = [MFUserDefaults valueForKey:MFLocalPatchKey(_appId)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileid"] = currentFileId;
    
    __weak typeof(self) weakSelf = self;
    [self requestPostWithUrl:PH_Url_CheckMangoFile params:params succ:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSDictionary *rows = dict[@"rows"];
        NSString *msg = dict[@"msg"];
        if ([dict[@"code"] intValue] == 202) {
            //当前补丁已是最新
            MFLog(@"%@", msg);
            [weakSelf activatePatchWithFileId:currentFileId];
        }
        else if ([dict[@"code"] intValue] == 500) {
            MFLog(@"%@", msg);
            if (weakSelf.autoClearLastPath) {
                //检测不到补丁，则清理本地旧版本补丁
                [weakSelf deleteLocalMangoScript];
            }
            [MFUserDefaults removeObjectForKey:MFLocalPatchKey(weakSelf.appId)];
        }
        else {
            NSString *fileId = MFStringWithFormat(@"%@", rows[@"fileid"]);
            MFLog(@"A new patch was detected!");
            [weakSelf evalRemotePatchWithFileId:fileId];
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestPostWithUrl:(NSString*)url params:(NSDictionary*)params succ:(Succ)succ fail:(Fail)fail {
    
    __weak typeof(self) weakSelf = self;
    
    NSString *bodyString = @"";
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict addEntriesFromDictionary:self.baseParams];
    [dict addEntriesFromDictionary:params];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict valueForKey:key];
        bodyString = [NSString stringWithFormat:@"%@%@=%@&", bodyString, key, value];
    }
    bodyString = [bodyString substringWithRange:NSMakeRange(0, bodyString.length-1)];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (data && httpResponse.statusCode == weakSelf.statusCode) {
                if (succ) succ(data);
            }
            else if (httpResponse.statusCode == 200) {
                NSString *resultStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [weakSelf dictionaryWithJsonString:resultStr];
                if (succ) succ(dict);
            }
            else {
                if (fail) fail(error.localizedDescription);
                MFLog(@"%@", error.localizedDescription);
            }
        });
    }];
    [task resume];
}

- (NSDictionary*)baseParams {
    if (!_baseParams) {
        _baseParams = @{@"appid": _appId, @"version": MFBundleShortVersion, @"debug": @(_debug)};
    }
    return _baseParams;
}

@end
