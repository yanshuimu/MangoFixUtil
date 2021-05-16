//
//  MangoFixUtil.m
//  Easyder
//
//  Created by xuhonggui on 2020/4/9.
//  Copyright © 2020 xuhonggui. All rights reserved.
//

#import "MangoFixUtil.h"
#import <objc/message.h>

#define EDStringIsEmpty(str) (str && [[NSString stringWithFormat:@"%@", str] length] > 0 ? NO : YES)

#ifdef RELEASE
    #define MFLog(FORMAT, ...) nil
#else
    #define MFLog(FORMAT, ...) fprintf(stderr,"MangoFixUtil：%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#endif

typedef void(^CompleteBlock)(NSDictionary *dict, BOOL isLastTime);

@interface MangoFixUtil ()
//
@property (nonatomic, copy) NSString *appId;
//
@property (nonatomic, assign) BOOL debug;
//
@property (nonatomic, copy) NSString *privateKey;
@end

@implementation MangoFixUtil

+ (instancetype)sharedUtil
{
    static MangoFixUtil *mangoFixUtil = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        mangoFixUtil = [[self alloc] init];
    });
    return mangoFixUtil;
}

- (instancetype)init {
    if (self = [super init]) {
        _statusCode = 201;
    }
    return self;
}

- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey {
    
    [self startWithAppId:appId privateKey:privateKey debug:NO];
}

- (void)startWithAppId:(NSString*)appId privateKey:(NSString*)privateKey debug:(BOOL)debug {
    
    _appId = appId;
    _debug = debug;
    _privateKey = privateKey;
}

- (void)evalRemoteMangoScript {
    
    if (EDStringIsEmpty(_privateKey)) {
        MFLog(@"privateKey is null or empty");
        return;
    }
        
    [self checkRemoteFixWithCompletion:^(NSDictionary *dict, BOOL isLastTime) {
        
        NSString *fileName = @"demo.mg";
        NSString *fileDirectory = [self fixFileDirectory];
        NSString *filePath = [fileDirectory stringByAppendingPathComponent:fileName];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            
            NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            if (script && script.length > 0) {
                [self evalMangoScriptWithRSAEncryptedBase64String:script context:[self context]];
                MFLog(@"eval %@remote script success!", isLastTime ? @"last time " : @"");
            }
            else {
                MFLog(@"script is null or empty");
            }
        }
        else {
            MFLog(@"local file not exist!");
        }
    }];
}

- (void)evalLocalMangoScript {
        
    if (EDStringIsEmpty(_privateKey)) {
        MFLog(@"privateKey is null or empty");
        return;
    }
        
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"encrypted_demo" ofType:@"mg"];
    NSString *script = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (!EDStringIsEmpty(script)) {
        
        [self evalMangoScriptWithRSAEncryptedBase64String:script context:[self context]];
        MFLog(@"eval local script success!");
    }
    else {
        MFLog(@"script is null or empty");
    }
}

- (void)evalLocalUnEncryptedMangoScriptWithPublicKey:(NSString*)publicKey {
        
    if (EDStringIsEmpty(_privateKey)) {
        MFLog(@"privateKey is null or empty");
        return;
    }
        
    NSString *script = [self encryptScirptWithPublicKey:publicKey];
    if (!EDStringIsEmpty(script)) {
        
        [self evalMangoScriptWithRSAEncryptedBase64String:script context:[self context]];
        MFLog(@"eval local script success!");
    }
    else {
        MFLog(@"script is null or empty");
    }
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
        MFLog(@"encrypted file path: %@", encryptedPath);
        writeResult = [encryptedScriptString writeToFile:encryptedPath atomically:YES encoding:NSUTF8StringEncoding error:&outErr];
    }
    
    err:
    if (outErr) MFLog(@"%@",outErr);
    return encryptedPath;
}

- (NSString*)fixFileDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString*)bundleShortVersion {
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict valueForKey:@"CFBundleShortVersionString"];
}

- (void)deleteLocalMangoScript {
    
    NSError *outErr = nil;
    NSString *filePath= [(NSString *)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"encrypted_demo.mg"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {
        [fileManager removeItemAtPath:filePath error:&outErr];
    }
    if (outErr) goto err;
    {
        MFLog(@"delete local mango script success!");
    }
    err:
    if (outErr) MFLog(@"%@",outErr);
}

#pragma mark - objc

- (id)context {
    
    id context = ((id (*) (id, SEL))objc_msgSend)(objc_getClass("MFContext"), sel_registerName("alloc"));
    if (!context) {
        return nil;
    }
    ((void (*) (id, SEL, id))objc_msgSend)(context, sel_registerName("initWithRSAPrivateKey:"), _privateKey);
    
    return context;
}

- (void)evalMangoScriptWithRSAEncryptedBase64String:(NSString*)script context:(id)context {
    
    if (!context) {
        return;
    }
    ((void (*) (id, SEL, id))objc_msgSend)(context, sel_registerName("evalMangoScriptWithRSAEncryptedBase64String:"), script);
}

- (id)encryptString:(NSString*)string publicKey:(NSString*)publicKey {
    
    return ((id (*)(id, SEL, id, id))objc_msgSend)(objc_getClass("MFRSA"), sel_registerName("encryptString:publicKey:"), string, publicKey);
}

#pragma mark - 网络请求

- (void)checkRemoteFixWithCompletion:(CompleteBlock)completion {
        
    @try {
        if (completion) {
            completion(nil, YES);
        }
    }
    @catch (NSException *exception) {
        MFLog(@"%@", exception.reason);
    }
    @finally {
        [self remoteMangoFixFileWithCompletion:completion];
    }
}

- (void)remoteMangoFixFileWithCompletion:(CompleteBlock)completion
{
    __weak typeof(self) weakSelf = self;
    
    if (EDStringIsEmpty(_url)) {
        MFLog(@"url is null or empty");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:_url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *bodyString = [NSString stringWithFormat:@"appid=%@&version=%@&debug=%@", _appId, [self bundleShortVersion], @(_debug)];
    request.HTTPBody = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (data && httpResponse.statusCode == weakSelf.statusCode) {
            
            NSString *cachesPath = [self fixFileDirectory];
            NSString *filePath = [cachesPath stringByAppendingPathComponent:@"demo.mg"];
            if ([data writeToFile:filePath atomically:YES]) {
                MFLog(@"remote file save success!");
                if (completion) {
                    completion(nil, NO);
                }
            }
            else {
                MFLog(@"remote file save fail!");
            }
        }
        if (error) {
            MFLog(@"fetch remote file fail, error:%@", error);
        }
    }];
    [task resume];
}

@end
