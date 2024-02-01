//
//  MFMacrosConstant.h
//  MangoFixUtil
//
//  Created by xhg on 2021/10/9.
//

#ifndef MFMacrosConstant_h
#define MFMacrosConstant_h


NSString * const MFBaseUrl = @"https://patchhub.top/mangofix";

NSString * const MFCheckMangoFileUrl = @"/api/checkmangofile";

NSString * const MFGetMangoFileUrl = @"/api/getmangofile";

NSString * const MFActivatePatchUrl = @"/api/activatepatch";

NSString * const MFActivateDeviceUrl = @"/api/activatedevice";

NSString * const MFInsertUserLogUrl = @"/api/insertUserLog";

#ifdef RELEASE
    #define MFLog(FORMAT, ...) nil
#else
    #define MFLog(FORMAT, ...) NSLog((@"MangoFixUtil：" FORMAT), ##__VA_ARGS__)
#endif

#define MFWeakSelf try{}@finally{} __weak typeof(self) self##Weak = self;

#define MFStrongSelf autoreleasepool{} __strong typeof(self) self = self##Weak;

#endif /* MFMacrosConstant_h */
