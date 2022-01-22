//
//  PHCacroDefine.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/10/9.
//

#ifndef PHCacroDefine_h
#define PHCacroDefine_h

#define MFCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define MFBundleShortVersion [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#define MFStringIsEmpty(str) (str && [[NSString stringWithFormat:@"%@", str] length] > 0 ? NO : YES)

#define MFStringWithFormat(string, args...)  [NSString stringWithFormat:string, args]

#define MFUserDefaults [NSUserDefaults standardUserDefaults]

#ifdef RELEASE
    #define MFLog(FORMAT, ...) nil
#else
    #define MFLog(FORMAT, ...) NSLog((@"MangoFixUtil：" FORMAT), ##__VA_ARGS__)
#endif

#define MFDevicePrefix @"MangoFixUtil:Device:"

#define MFPatchPrefix @"MangoFixUtil:Patch:"

#define MFDeviceKey(appId, version) MFStringWithFormat(@"MFDeviceKey:%@:%@", appId, version);

#define MFPatchKey(fileId) MFStringWithFormat(@"MFPatchKey:%@", fileId);

#define MFLocalPatchKey(appId) MFStringWithFormat(@"MFLocalPatchKey:%@", appId)

#define MFUUIDKey(appId) MFStringWithFormat(@"MFUUIDKey:%@", appId)

#endif /* PHCacroDefine_h */
