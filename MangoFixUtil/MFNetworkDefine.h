//
//  MFNetworkDefine.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/10/9.
//

#ifndef MFNetwork_Define_h
#define MFNetwork_Define_h

#define MF_Url(url) MFStringWithFormat(@"%@%@", @"http://patchhub.top/mangofix", url)

#define MF_Url_ActivateDevice MF_Url(@"/api/activatedevice")

#define MF_Url_CheckMangoFile MF_Url(@"/api/checkmangofile")

#define MF_Url_GetMangoFile MF_Url(@"/api/getmangofile")

#define MF_Url_ActivatePatch MF_Url(@"/api/activatepatch")

#endif /* MFNetwork_Define_h */
