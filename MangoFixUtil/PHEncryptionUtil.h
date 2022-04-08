//
//  PHEncryptionUtil.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2022/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHEncryptionUtil : NSObject

+ (NSData *)AES128ParmEncryptWithData:(NSData*)data key:(NSString *)key iv:(NSString *)iv;

+ (NSData *)AES128ParmDecryptWithData:(NSData*)data key:(NSString *)key iv:(NSString *)iv;

@end

NS_ASSUME_NONNULL_END
