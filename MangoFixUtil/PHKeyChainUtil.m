//
//  PHKeyChainUtil.m
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/9/18.
//

#import "PHKeyChainUtil.h"
#import <Security/Security.h>

@implementation PHKeyChainUtil

+ (NSMutableDictionary *)keychainQuery:(NSString *)key
{
    if (key) {
        NSMutableDictionary *keychains = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         (__bridge_transfer id)kSecClassGenericPassword, (__bridge_transfer id)kSecClass,
                                         key, (__bridge_transfer id)kSecAttrService,
                                         key, (__bridge_transfer id)kSecAttrAccount,
                                         (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock, (__bridge_transfer id)kSecAttrAccessible,
                                         nil];
        return keychains;
    }
    
    return nil;
}
 
+ (void)save:(NSString *)key data:(id)data
{
    if (key && data != nil) {
        //Get search dictionary
        NSMutableDictionary *keychainQuery = [self keychainQuery:key];
        //Delete old item before add new item
        SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
        //Add new object to search dictionary(Attention:the data format)
        [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
        //Add item to keychain with the search dictionary
        SecItemAdd((__bridge_retained CFDictionaryRef)keychainQuery, NULL);
    }
}

+ (id)load:(NSString *)key
{
    id ret = nil;
    
    if (key) {
        NSMutableDictionary *keychainQuery = [self keychainQuery:key];
        //Configure the search setting
        [keychainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
        [keychainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
        CFDataRef keyData = NULL;
        if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
            @try {
                ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
            }
            @catch (NSException *e) {
                NSLog(@"Unarchive of %@ failed: %@", key, e);
            }
            @finally {
            }
        }
    }
    return ret;
}

+ (void)delete:(NSString *)key
{
    NSMutableDictionary *keychainQuery = [self keychainQuery:key];
    SecItemDelete((__bridge_retained CFDictionaryRef)keychainQuery);
}

@end
