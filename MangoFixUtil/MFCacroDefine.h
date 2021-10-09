//
//  MFCacroDefine.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/10/9.
//

#ifndef MFCacroDefine_h
#define MFCacroDefine_h

#define MFStringIsEmpty(str) (str && [[NSString stringWithFormat:@"%@", str] length] > 0 ? NO : YES)

#define MFStringWithFormat(string, args...)  [NSString stringWithFormat:string, args]

#ifdef RELEASE
    #define MFLog(FORMAT, ...) nil
#else
    #define MFLog(FORMAT, ...) NSLog((@"MangoFixUtil：" FORMAT), ##__VA_ARGS__)
#endif

#define MFDevicePrefix @"MangoFixUtil:Device:"

#define MFPatchPrefix @"MangoFixUtil:Patch:"

#define MFDeviceKey(appId, version) MFStringWithFormat(@"MFDeviceKey:%@:%@", appId, version);

#define MFPatchKey(fileId) MFStringWithFormat(@"MFPatchKey:%@", fileId);

#endif /* MFCacroDefine_h */
