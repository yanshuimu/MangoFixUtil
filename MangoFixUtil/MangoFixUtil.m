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
#import <MangoFix/MangoFix.h>

typedef void(^Succ)(id resp);

typedef void(^Fail)(NSString *msg);

@interface MangoFixUtil ()

@property(nonatomic, strong) MFInterpreter *interpreter;

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
 * AES128密钥，长度需为16的倍数，举个栗子：xWx2TilxtpHlvQrT
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

@end

@implementation MangoFixUtil

+ (instancetype)sharedUtil
{
    static MangoFixUtil *util = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        util = [[self alloc] init];
    });
    return util;
}

- (instancetype)init
{
    if (self = [super init]) {
        _interpreter = [[MFInterpreter alloc] init];
        _clearLastPathAfterVersionUpdateEnabled = YES;
        _dailyActiveUserEnabled = YES;
        _uuid = [MFKeyChainUtil load:MFUUIDKey(MFBundleIdentifier)];
        if (_uuid.length == 0) {
            _uuid = [self createUUID];
            [MFKeyChainUtil save:MFUUIDKey(MFBundleIdentifier) data:_uuid];
        }
    }
    return self;
}

+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey
{
    MangoFixUtil *util = [self sharedUtil];
    [util startWithAppId:appId aesKey:aesKey debug:NO];
    return util;
}

+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey
{
    MangoFixUtil *util = [self sharedUtil];
    [util startWithUserId:userId aesKey:aesKey debug:NO];
    return util;
}

- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey
{
    return [self startWithAppId:appId aesKey:aesKey debug:NO];
}

- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey
{
    return [self startWithUserId:userId aesKey:aesKey debug:NO];
}

- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug
{
    NSAssert(appId.length != 0, @"The appId is nil or empty!");
    NSAssert(aesKey.length % 16 == 0, @"The aesKey is not a multiple of 16 bytes!");
    _appId = appId;
    _userId = @"";
    _debug = debug;
    _aesKey = aesKey;
    return self;
}

- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug
{
    NSAssert(userId.length != 0, @"The userId is nil or empty!");
    NSAssert(aesKey.length % 16 == 0, @"The aesKey is not a multiple of 16 bytes!");
    _appId = @"";
    _userId = userId;
    _debug = debug;
    _aesKey = aesKey;
    return self;
}

- (void)evalRemoteMangoScript
{
    @try {
        [self evalLastPatch];
    }
    @catch (NSException *exception) {
        MFLog(@"%@", exception);
    }
    @finally {
        [self requestCheckRemotePatch];
    }
}

- (void)evalLocalUnEncryptedMangoScript
{
    NSError *error = nil;
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *scriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        MFLog(@"%@", error.localizedDescription);
        return;
    }
    if (scriptString.length > 0) {
        [self startInterpret:scriptString];
        MFLog(@"The local unencrypted patch is successfully executed!");
    }
    else {
        MFLog(@"The local unencrypted patch content is empty!");
    }
}

- (void)evalLocalEncryptedMangoScript
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"encrypted_demo" ofType:@"mg"];
    NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    if (scriptData && scriptData.length > 0) {
        NSString *scriptString = [self decryptData:scriptData];
        if (scriptString.length == 0) {
            MFLog(@"Decrypt error!");
            return;
        }
        [self startInterpret:scriptString];
        MFLog(@"The local encrypted patch is successfully executed!");
    }
    else {
        MFLog(@"The local encrypted patch content is empty!");
    }
}

- (NSString*)encryptPlainScriptToDocument
{
    NSError *error = nil;
    NSString * scriptPath = nil;
    NSURL *scriptUrl = [[NSBundle mainBundle] URLForResource:@"demo" withExtension:@"mg"];
    NSString *scriptString = [NSString stringWithContentsOfURL:scriptUrl encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        MFLog(@"%@", error.localizedDescription);
        return scriptPath;
    }
    NSData *scriptData = [self encryptString:scriptString];
    scriptPath = [[self documentsPath] stringByAppendingPathComponent:@"encrypted_demo.mg"];
    [scriptData writeToFile:scriptPath options:NSDataWritingAtomic error:&error];
    if (error) {
        MFLog(@"%@", error.localizedDescription);
        return scriptPath;
    }
    MFLog(@"The encrypted patch path: %@", scriptPath);
    return scriptPath;
}

- (void)deleteLocalMangoScript
{
    NSError *error = nil;
    NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            MFLog(@"%@", error.localizedDescription);
            return;
        }
        MFLog(@"The local patch was successfully deleted! Please restart the app!");
    }
}

- (void)evalLastPatch
{
    NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        if (scriptData && scriptData.length > 0) {
            NSString *scriptString = [self decryptData:scriptData];
            if (!scriptString.length) {
                MFLog(@"Decrypt error!");
                return;
            }
            [self startInterpret:scriptString];
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

#pragma mark - MangoFix

- (void)startInterpret:(NSString*)scriptString
{
    @autoreleasepool {
        mf_set_current_compile_util(self.interpreter);
        mf_add_built_in(self.interpreter);
        [self.interpreter compileSourceWithString:scriptString];
        mf_set_current_compile_util(nil);
        mf_interpret(self.interpreter);
    }
}

- (NSString*)decryptData:(NSData*)data
{
    NSData *scriptData = [data AES128ParmDecryptWithKey:_aesKey iv:@""];
    NSString *scriptString = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
    return scriptString;
}

- (id)encryptString:(NSString*)string
{
    NSData *scriptData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [scriptData AES128ParmEncryptWithKey:_aesKey iv:@""];
}

#pragma mark - Other

- (NSString*)documentsPath
{
    return (NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString*)cachesPath
{
    return (NSString *)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSDictionary *)jsonString2Dictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        return nil;
    }
    return dict;
}

- (NSString*)createUUID
{
    NSString *string = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if(string.length > 16) string = [string substringToIndex:16];
    return string;
}

- (NSString*)userDefaultsGet:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

- (void)userDefaultsSave:(NSString*)key value:(id)value
{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)userDefaultsRemove:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Network

- (void)requestCheckRemotePatch
{
    NSString *fileId = [self userDefaultsGet:MFLocalPatchKey(MFBundleIdentifier)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileid"] = fileId;
    if (_isSimpleMode == NO) {
        params[@"uuid"] = _uuid;
        params[@"extend"] = _extend;
    }
    
    __weak typeof(self) weakSelf = self;
    [self requestPostWithUrl:MF_Url_CheckMangoFile params:params succ:^(NSDictionary *dict) {
        NSDictionary *rows = dict[@"rows"];
        NSInteger code = [dict[@"code"] intValue];
        MFLog(@"%@", dict[@"msg"]);
        if (code == 202) {
            //The current patch is up to date...
            [weakSelf requestActivateDevice:fileId];
        }
        else if (code == 500) {
            //No new patch was detected...
            [weakSelf deleteLocalMangoScript];
            [weakSelf userDefaultsRemove:MFLocalPatchKey(MFBundleIdentifier)];
        }
        else if (code == 200){
            //A new patch was detected...
            [weakSelf requestActivateDevice:fileId];
            [weakSelf requestGetRemotePatch:MFStringWithFormat(@"%@", rows[@"fileid"])];
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestGetRemotePatch:(NSString*)fileId
{
    __weak typeof(self) weakSelf = self;
    [self requestPostWithUrl:MF_Url_GetMangoFile params:nil succ:^(NSData *scriptData) {
        NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
        if ([scriptData writeToFile:filePath atomically:YES]) {
            [weakSelf userDefaultsSave:fileId value:MFLocalPatchKey(MFBundleIdentifier)];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                if (scriptData && scriptData.length > 0) {
                    NSString *scriptString = [weakSelf decryptData:scriptData];
                    if (!scriptString.length) {
                        MFLog(@"Decrypt error!");
                        return;
                    }
                    [weakSelf startInterpret:scriptString];
                    MFLog(@"The latest patch is successfully executed!");
                    [weakSelf requestActivatePatch:fileId];
                }
            }
        }
        else {
            MFLog(@"Failed to save the latest patch!");
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestActivateDevice:(NSString*)fileId
{
    if (_debug) return;
    if (_isSimpleMode) return;
    if (fileId.length == 0) return;
    
    NSString *key = MFDeviceKey(MFBundleIdentifier, MFBundleShortVersion);
    NSString *value = [MFKeyChainUtil load:key];
    if (value.intValue == 1) return;
    MFLog(@"Device not activated!");
    [self requestPostWithUrl:MF_Url_ActivateDevice params:@{@"fileid": fileId} succ:^(NSDictionary *dict) {
        if ([dict[@"code"] intValue] == 500) {
            MFLog(@"%@", dict[@"msg"]);
        }
        else {
            [MFKeyChainUtil save:key data:@"1"];
            MFLog(@"Device is activate successfully!");
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestActivatePatch:(NSString*)fileId
{
    if (_debug) return;
    if (_isSimpleMode) return;
    if (fileId.length == 0) return;
    
    NSString *key = MFPatchKey(fileId);
    NSString *value = [MFKeyChainUtil load:key];
    if (value.intValue == 1) return;
    MFLog(@"Patch not activated!");
    
    [self requestPostWithUrl:MF_Url_ActivatePatch params:@{@"fileid": fileId} succ:^(NSDictionary *dict) {
        if ([dict[@"code"] intValue] == 500) {
            MFLog(@"%@", dict[@"msg"]);
        }
        else {
            [MFKeyChainUtil save:key data:@"1"];
            MFLog(@"Patch is activate successfully!");
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestPostWithUrl:(NSString*)url params:(NSDictionary*)params succ:(Succ)succ fail:(Fail)fail {
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableDict addEntriesFromDictionary:self.baseParams];
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSString *key in mutableDict.allKeys) {
        [mutableArray addObject:[NSString stringWithFormat:@"%@=%@", key, [mutableDict valueForKey:key]]];
    }
    NSString *bodyStr = [mutableArray componentsJoinedByString:@"&"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (data && httpResponse.statusCode == 201) {
                if (succ) succ(data);
            }
            else if (httpResponse.statusCode == 200) {
                NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [weakSelf jsonString2Dictionary:jsonStr];
                if (succ) succ(dict);
            }
            else {
                if (fail) fail(error.localizedDescription);
            }
        });
    }] resume];
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
