//
//  MFCacroDefine.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/10/9.
//

#ifndef MFMacroDefine_h
#define MFMacroDefine_h

#define MFCachesDirectory [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define MFBundleShortVersion [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#define MFBundleIdentifier [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleIdentifier"]

#define MFBundleDisplayName [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"]

#define MFStringIsEmpty(str) (str && [[NSString stringWithFormat:@"%@", str] length] > 0 ? NO : YES)

#define MFStringWithFormat(string, args...)  [NSString stringWithFormat:string, args]

#define MFUserDefaults [NSUserDefaults standardUserDefaults]

#define MFDeviceKey(bundleId, version) MFStringWithFormat(@"MFDeviceKey:%@:%@", bundleId, version);

#define MFPatchKey(fileId) MFStringWithFormat(@"MFPatchKey:%@", fileId);

#define MFLocalPatchKey(bundleId) MFStringWithFormat(@"MFLocalPatchKey:%@", bundleId)

#define MFUUIDKey(bundleId) MFStringWithFormat(@"MFUUIDKey:%@", bundleId)

#ifdef RELEASE
    #define MFLog(FORMAT, ...) nil
#else
    #define MFLog(FORMAT, ...) NSLog((@"MangoFixUtil：" FORMAT), ##__VA_ARGS__)
#endif

#endif /* MFMacroDefine_h */
