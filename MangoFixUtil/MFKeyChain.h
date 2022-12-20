//
//  MFKeyChain.h
//  MangoFixUtil
//
//  Created by xhg on 2021/9/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFKeyChain : NSObject

+ (void)save:(NSString *)key data:(id)data;

+ (id)load:(NSString *)key;

+ (void)delete:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
