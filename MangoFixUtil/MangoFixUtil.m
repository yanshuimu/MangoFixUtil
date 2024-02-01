//
//  MangoFixUtil.m
//
//  Created by xhg on 2020/4/9.
//  Copyright © 2020 xhg. All rights reserved.
//

#import "MangoFixUtil.h"
#import "MFKeyChain.h"
#import "MFMacrosConstant.h"
#import "MangoFix.h"
#import "MFInterpreter.h"
#import "execute.h"
#import "create.h"

typedef void(^Succ)(id resp);

typedef void(^Fail)(NSString *msg);

@interface MangoFixUtil ()

@property(nonatomic, strong) MFInterpreter *interpreter;

/**
 * appId
 */
@property (nonatomic, copy) NSString *appId;

/**
 * userId
 */
@property (nonatomic, copy) NSString *userId;

/**
 * 控制分发规则  YES 开发模式  NO 生产模式
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
        _uuid = [self loadUUID];
        _isLogModeDebug = YES;
    }
    return self;
}

+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey
{
    return [[self sharedUtil] startWithAppId:appId aesKey:aesKey debug:NO];
}

+ (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey debug:(BOOL)debug
{
    return [[self sharedUtil] startWithAppId:appId aesKey:aesKey debug:debug];
}

- (instancetype)startWithAppId:(NSString*)appId aesKey:(NSString *)aesKey
{
    return [self startWithAppId:appId aesKey:aesKey debug:NO];
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

+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey
{
    return [[self sharedUtil] startWithUserId:userId aesKey:aesKey debug:NO];
}

+ (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey debug:(BOOL)debug
{
    return [[self sharedUtil] startWithUserId:userId aesKey:aesKey debug:debug];
}

- (instancetype)startWithUserId:(NSString*)userId aesKey:(NSString *)aesKey
{
    return [self startWithUserId:userId aesKey:aesKey debug:NO];
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
        NSString *scriptString = [self decrypt:scriptData];
        if (scriptString.length == 0) {
            MFLog(@"AES decrypt error!");
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
    NSData *scriptData = [self encrypt:scriptString];
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
        MFLog(@"The local patch was successfully deleted! Please restart app!");
    }
}

- (void)evalLastPatch
{
    NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *scriptData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
        if (scriptData && scriptData.length > 0) {
            NSString *scriptString = [self decrypt:scriptData];
            if (!scriptString.length) {
                MFLog(@"AES decrypt error!");
                return;
            }
            [self startInterpret:scriptString];
            MFLog(@"The last patch is successfully executed!");
            [self requestActivatePatch:[self userDefaultsGet:[self fileIdKey]]];
        }
        else {
            MFLog(@"The last patch content is empty!");
        }
    }
    else {
        MFLog(@"The last patch does not exist!");
    }
}

- (void)log:(id)object msg:(NSString*)msg 
{
    [self requestLog:object msg:msg];
}

#pragma mark - MangoFix

- (void)startInterpret:(NSString*)scriptString
{
    if (_isLogModeDebug) MFLog(@"The patch content: %@", scriptString);
    @autoreleasepool {
        mf_set_current_compile_util(self.interpreter);
        mf_add_built_in(self.interpreter);
        [self.interpreter compileSourceWithString:scriptString];
        mf_set_current_compile_util(nil);
        mf_interpret(self.interpreter);
    }
}

- (NSData*)encrypt:(NSString*)string
{
    NSData *scriptData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [scriptData AES128ParmEncryptWithKey:_aesKey iv:@""];
}

- (NSString*)decrypt:(NSData*)data
{
    NSData *scriptData = [data AES128ParmDecryptWithKey:_aesKey iv:@""];
    NSString *scriptString = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
    return scriptString;
}

+ (NSData*)encrypt:(NSString*)string key:(NSString*)key iv:(NSString*)iv
{
    NSData *scriptData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [scriptData AES128ParmEncryptWithKey:key iv:iv];
}

+ (NSString*)decrypt:(NSData*)data key:(NSString*)key iv:(NSString*)iv
{
    NSData *scriptData = [data AES128ParmDecryptWithKey:key iv:iv];
    NSString *scriptString = [[NSString alloc] initWithData:scriptData encoding:NSUTF8StringEncoding];
    return scriptString;
}

#pragma mark - Other

- (NSString*)loadUUID
{
    NSString *uuid = [MFKeyChain load:[self UUIDKey]];
    if (uuid.length == 0) {
        uuid = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if(uuid.length > 16) uuid = [uuid substringToIndex:16];
        [MFKeyChain save:[self UUIDKey] data:uuid];
    }
    return uuid;
}

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

- (NSString*)UUIDKey
{
    return [NSString stringWithFormat:@"%@.mfu.uuid", [self bundleIdentifier]];
}

- (NSString*)fileIdKey
{
    return [NSString stringWithFormat:@"%@.mfu.fileid", [self bundleIdentifier]];
}

- (NSString*)deviceKey:(NSString*)fileId
{
    return [NSString stringWithFormat:@"%@.device", fileId];
}

- (NSString*)patchKey:(NSString*)fileId
{
    return [NSString stringWithFormat:@"%@.patch", fileId];
}

- (NSString*)bundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"];
}

- (NSString*)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

- (NSString*)bundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

#pragma mark - Network

- (void)requestCheckRemotePatch
{
    NSString *fileId = [self userDefaultsGet:[self fileIdKey]];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileid"] = fileId;
    if (_isSimpleMode == NO) {
        params[@"uuid"] = _uuid;
        params[@"extend"] = _extend;
    }
    
    @MFWeakSelf
    [self postWithUrl:MFCheckMangoFileUrl params:params succ:^(NSDictionary *dict) {
        @MFStrongSelf
        NSInteger code = [dict[@"code"] intValue];
        MFLog(@"%@", dict[@"msg"]);
        if (code == 202) {
            //The current patch is up to date...
            [self requestActivateDevice:fileId];
        }
        else if (code == 500) {
            //No new patch was detected...
            [self deleteLocalMangoScript];
            [self userDefaultsRemove:[self fileIdKey]];
        }
        else if (code == 200){
            //A new patch was detected...
            NSDictionary *rows = dict[@"rows"];
            NSString *fileId = [NSString stringWithFormat:@"%@", rows[@"fileid"]];
            [self requestActivateDevice:fileId];
            [self requestGetRemotePatch:fileId];
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestGetRemotePatch:(NSString*)fileId
{
    @MFWeakSelf
    [self postWithUrl:MFGetMangoFileUrl params:nil succ:^(NSData *scriptData) {
        @MFStrongSelf
        NSString *filePath = [[self cachesPath] stringByAppendingPathComponent:@"demo.mg"];
        if (![scriptData writeToFile:filePath atomically:YES]) {
            MFLog(@"Failed to save the latest patch!");
            return;
        }
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            return;
        }
        [self userDefaultsSave:[self fileIdKey] value:fileId];
        if (scriptData && scriptData.length > 0) {
            NSString *scriptString = [self decrypt:scriptData];
            if (!scriptString.length) {
                MFLog(@"AES decrypt error!");
                return;
            }
            [self startInterpret:scriptString];
            MFLog(@"The latest patch is successfully executed!");
            [self requestActivatePatch:fileId];
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
    
    NSString *key = [self deviceKey:fileId];
    NSString *value = [MFKeyChain load:key];
    if (value.intValue == 1) return;
    MFLog(@"Device not activated!");
    
    [self postWithUrl:MFActivateDeviceUrl params:@{@"fileid": fileId} succ:^(NSDictionary *dict) {
        if ([dict[@"code"] intValue] == 500) {
            MFLog(@"%@", dict[@"msg"]);
        }
        else {
            [MFKeyChain save:key data:@"1"];
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
    
    NSString *key = [self patchKey:fileId];
    NSString *value = [MFKeyChain load:key];
    if (value.intValue == 1) return;
    MFLog(@"Patch not activated!");
    
    [self postWithUrl:MFActivatePatchUrl params:@{@"fileid": fileId} succ:^(NSDictionary *dict) {
        if ([dict[@"code"] intValue] == 500) {
            MFLog(@"%@", dict[@"msg"]);
        }
        else {
            [MFKeyChain save:key data:@"1"];
            MFLog(@"Patch is activate successfully!");
        }
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)requestLog:(id)sender msg:(NSString*)msg {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([sender isKindOfClass:NSString.class]) {
        params[@"path"] = sender;
    } else if ([sender isKindOfClass:NSObject.class]){
        NSObject *object = sender;
        params[@"path"] = NSStringFromClass(object.class);
    } else {
        params[@"path"] = sender;
    }
    params[@"detailMsg"] = msg;
    [[MangoFixUtil sharedUtil] postWithUrl:MFInsertUserLogUrl params:params succ:^(NSDictionary *dict) {
        MFLog(@"%@", dict[@"msg"]);
    } fail:^(NSString *msg) {
        MFLog(@"%@", msg);
    }];
}

- (void)postWithUrl:(NSString*)url params:(NSDictionary*)params succ:(Succ)succ fail:(Fail)fail
{
    @MFWeakSelf
    url = [NSString stringWithFormat:@"%@%@", MFBaseUrl, url];
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
        @MFStrongSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
            if (data && httpResponse.statusCode == 201) {
                if (succ) succ(data);
            }
            else if (httpResponse.statusCode == 200) {
                NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *dict = [self jsonString2Dictionary:jsonStr];
                if (succ) succ(dict);
            }
            else {
                if (fail) fail(error.localizedDescription);
            }
        });
    }] resume];
}

- (NSMutableDictionary*)baseParams
{
    if (!_baseParams) {
        _baseParams = [NSMutableDictionary dictionary];
        _baseParams[@"appid"] = _appId;
        _baseParams[@"userid"] = _userId;
        _baseParams[@"debug"] = @(_debug);
        _baseParams[@"encrypt"] = @"1";
        _baseParams[@"sdk"] = @"2.1.5";
        _baseParams[@"bundleid"] = [self bundleIdentifier];
        _baseParams[@"version"] = [self bundleVersion];
        _baseParams[@"appname"] = [self bundleDisplayName];
    }
    return _baseParams;
}

@end
