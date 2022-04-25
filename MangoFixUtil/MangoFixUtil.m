//
//  MangoFixUtil.m
//
//  Created by 许鸿桂 on 2020/4/9.
//  Copyright © 2020 许鸿桂. All rights reserved.
//

#import "MangoFixUtil.h"
#import "MFKeyChainUtil.h"
#import "MFNetworkDefine.h"
#import "MFMacroDefine.h"
#if __has_include(<MangoFix/MangoFix.h>)
#import <MangoFix/MangoFix.h>
#import "create.h"
#import "execute.h"
#define HAS_INCLUDE_MANGOFIX
#endif

typedef void(^Succ)(id resp);

typedef void(^Fail)(NSString *msg);

@interface MangoFixUtil ()

/**
 * 应用id
 */
@property (nonatomic, copy) NSString *appId;

/**
 * 用户id
 */
@property (nonatomic, copy) NSString *userId;

/**
 * 规则 YES 开发设备 NO 全量设备
 */
@property (nonatomic, assign) BOOL debug;

/**
 * AES秘钥
 */
@property (nonatomic, copy) NSString *aesKey;

/**
 * uuid
 */
@property (nonatomic, copy) NSString *uuid;

/**
 * 公共参数
 */
@property (nonatomic, strong) NSMutableDictionary *baseParams;

#ifdef HAS_INCLUDE_MANGOFIX
@property(nonatomic, strong) MFInterpreter *interpreter;
#endif

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
        _clearLastPathAfterVersionUpdateEnabled = YES;
        _dailyActiveUserEnabled = YES;
#ifdef HAS_INCLUDE_MANGOFIX
        _interpreter = [[MFInterpreter alloc] init];
#endif
        _uuid = [MFKeyChainUtil load:MFUUIDKey(MFBundleIdentifier)];
        if (MFStringIsEmpty(_uuid)) {
            _uuid = [self createUUID];
            [MFKeyChainUtil save:MFUUIDKey(MFBundleIdentifier) data:_uuid];
        }
    }
    return self;
}

- (void)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey {
    
    [self startWithAppId:appId aesKey:aesKey debug:NO];
}

- (void)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey {
    
    [self startWithUserId:userId aesKey:aesKey debug:NO];
}

- (void)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug {
    
    NSAssert(!MFStringIsEmpty(aesKey), @"The aesKey is nil or empty!");
    NSAssert(aesKey.length % 16 == 0, @"The aesKey is not a multiple of 16 bytes!");
    _appId = appId;
    _userId = @"";
    _debug = debug;
    _aesKey = aesKey;
}

- (void)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug {
    
    NSAssert(!MFStringIsEmpty(userId), @"The userId is nil or empty!");
    NSAssert(aesKey.length % 16 == 0, @"The aesKey is not a multiple of 16 bytes!");
    _appId = @"";
    _userId = userId;
    _debug = debug;
    _aesKey = aesKey;
}

- (void)evalRemoteMangoScript {
    
    @try {
        [self evalLastPatch];
    }
    @catch (NSException *exception) {
        MFLog(@"%@", exception);
    }
    @finally {
        [self activateDevice];
        [self requestCheckRemotePatch];
    }
}

- (void)evalLocalMangoScript {
        
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"encrypted_demo" ofType:@"mg"];
    NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    if (scriptData && scriptData.length > 0) {
        NSString *scriptString = [self decryptAES128Data:scriptData];
        if (!scriptString.length) {
            MFLog(@"AES128 decrypt error!");
            return;
        }
        [self evalMangoScriptString:scriptString];
        MFLog(@"The local patch is successfully executed!");
    }
    else {
        MFLog(@"The local patch content is empty!");
    }
}

- (void)evalLocalUnEncryptedMangoScript {
        
    NSData *scriptData = nil;
    NSError *outErr = nil;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *plainScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    {
        scriptData = [self encryptString:plainScriptString];
    }
    err:
    if (outErr) MFLog(@"%@",outErr);
    if (scriptData && scriptData.length > 0) {
        NSString *scriptString = [self decryptAES128Data:scriptData];
        if (!scriptString.length) {
            MFLog(@"AES128 decrypt error!");
            return;
        }
        [self evalMangoScriptString:scriptString];
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
        NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        if (scriptData && scriptData.length > 0) {
            NSString *scriptString = [self decryptAES128Data:scriptData];
            if (!scriptString.length) {
                MFLog(@"AES128 decrypt error!");
                return;
            }
            [self evalMangoScriptString:scriptString];
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
    
    [self requestPostWithUrl:MF_Url_GetMangoFile params:nil succ:^(id resp) {
        NSData *data = resp;
        NSString *filePath = [MFCachesDirectory stringByAppendingPathComponent:@"demo.mg"];
        if ([data writeToFile:filePath atomically:YES]) {
            [MFUserDefaults setObject:fileId forKey:MFLocalPatchKey(MFBundleIdentifier)];
            [MFUserDefaults synchronize];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
                if (scriptData && scriptData.length > 0) {
                    NSString *scriptString = [weakSelf decryptAES128Data:scriptData];
                    if (!scriptString.length) {
                        MFLog(@"AES128 decrypt error!");
                        return;
                    }
                    [weakSelf evalMangoScriptString:scriptString];
                    MFLog(@"The latest patch is successfully executed!");
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
    
    NSString *key = MFDeviceKey(MFBundleIdentifier, MFBundleShortVersion);
    NSString *value = [MFKeyChainUtil load:key];
    
    if (value.intValue == 1) {
        return;
    }
    
    MFLog(@"Device not activated!");
    
    [self requestPostWithUrl:MF_Url_ActivateDevice params:nil succ:^(id resp) {
        NSDictionary *dict = resp;
        NSString *msg = dict[@"msg"];
        NSInteger code = [dict[@"code"] intValue];
        if (code == 500) {
            MFLog(@"%@", msg);
        }
        else {
            [MFKeyChainUtil save:key data:@"1"];
            MFLog(@"Device is activate successfully!");
        }
    } fail:nil];
}

- (void)activatePatchWithFileId:(NSString*)fileId {
        
    if (_debug || MFStringIsEmpty(fileId)) {
        return;
    }
    
    NSString *key = MFPatchKey(fileId);
    NSString *value = [MFKeyChainUtil load:key];
    
    if (value.intValue == 1) {
        return;
    }
    
    MFLog(@"Patch not activated!");
    
    [self requestPostWithUrl:MF_Url_ActivatePatch params:@{@"fileid": fileId} succ:^(id resp) {
        NSDictionary *dict = resp;
        NSString *msg = dict[@"msg"];
        NSInteger code = [dict[@"code"] intValue];
        if (code == 500) {
            MFLog(@"%@", msg);
        }
        else {
            [MFKeyChainUtil save:key data:@"1"];
            MFLog(@"Patch is activate successfully!");
        }
    } fail:nil];
}

- (NSString*)encryptPlainScriptToDocument {
    
    NSError *outErr = nil;
    BOOL writeResult = NO;
    NSString * encryptedPath = nil;
    
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *plainScriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&outErr];
    if (outErr) goto err;
    
    {
        NSData *encryptedScriptData = [self encryptString:plainScriptString];
        encryptedPath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:encryptedPath]) {
            [fileManager createFileAtPath:encryptedPath contents:nil attributes:nil];
        }
        MFLog(@"The encrypted patch path: %@", encryptedPath);
        writeResult = [encryptedScriptData writeToFile:encryptedPath options:NSDataWritingAtomic error:&outErr];
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

- (NSString*)createUUID {
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef stringRef = CFUUIDCreateString(NULL, uuidRef);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)stringRef];
    CFRelease(uuidRef);
    CFRelease(stringRef);
    uuid = [uuid lowercaseString];
    uuid = [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if(uuid.length > 16) uuid = [uuid substringToIndex:16];
    return uuid;
}

#pragma mark - MangoFix

- (void)evalMangoScriptString:(NSString*)scriptString {

#ifdef HAS_INCLUDE_MANGOFIX
    @autoreleasepool {
        mf_set_current_compile_util(self.interpreter);
        mf_add_built_in(self.interpreter);
        [self.interpreter compileSourceWithString:scriptString];
        mf_set_current_compile_util(nil);
        mf_interpret(self.interpreter);
    }
#else
#endif
    
}

- (NSString*)decryptAES128Data:(NSData*)data {

#ifdef HAS_INCLUDE_MANGOFIX
    NSData *scriptData = [data AES128ParmDecryptWithKey:_aesKey iv:@""];
    NSString *scriptString = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
    return scriptString;
#else
    return @"";
#endif
    
}

- (id)encryptString:(NSString*)string {

#ifdef HAS_INCLUDE_MANGOFIX
    NSData *scriptData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [scriptData AES128ParmEncryptWithKey:_aesKey iv:@""];
#else
    return nil;
#endif
    
}


#pragma mark - Network

- (void)requestCheckRemotePatch {
    
    NSString *currentFileId = [MFUserDefaults valueForKey:MFLocalPatchKey(MFBundleIdentifier)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileid"] = currentFileId;
    if (_dailyActiveUserEnabled) {
        params[@"uuid"] = _uuid;
        params[@"extend"] = _extend;
    }
    
    __weak typeof(self) weakSelf = self;
    [self requestPostWithUrl:MF_Url_CheckMangoFile params:params succ:^(id resp) {
        NSDictionary *dict = resp;
        NSDictionary *rows = dict[@"rows"];
        NSString *msg = dict[@"msg"];
        NSInteger code = [dict[@"code"] intValue];
        if (code == 202) {
            MFLog(@"%@", msg);
            [weakSelf activatePatchWithFileId:currentFileId];
        }
        else if (code == 500) {
            MFLog(@"%@", msg);
            if (weakSelf.clearLastPathAfterVersionUpdateEnabled) {
                [weakSelf deleteLocalMangoScript];
            }
            [MFUserDefaults removeObjectForKey:MFLocalPatchKey(MFBundleIdentifier)];
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
            if (data && httpResponse.statusCode == 201) {
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

- (NSMutableDictionary*)baseParams {
    if (!_baseParams) {
        _baseParams = [NSMutableDictionary dictionary];
        _baseParams[@"appid"] = _appId;
        _baseParams[@"userid"] = _userId;
        _baseParams[@"version"] = MFBundleShortVersion;
        _baseParams[@"debug"] = @(_debug);
        _baseParams[@"encrypt"] = @"1";
        _baseParams[@"bundleid"] = MFBundleIdentifier;
    }
    return _baseParams;
}

@end
