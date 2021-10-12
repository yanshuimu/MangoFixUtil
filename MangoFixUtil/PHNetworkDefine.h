//
//  PHNetworkDefine.h
//  MangoFixUtil
//
//  Created by 许鸿桂 on 2021/10/9.
//

#ifndef PHNetwork_Define_h
#define PHNetwork_Define_h

#define PH_Url(url) MFStringWithFormat(@"%@%@", @"http://patchhub.top/mangofix", url)

#define PH_Url_ActivateDevice PH_Url(@"/api/activatedevice")

#define PH_Url_CheckMangoFile PH_Url(@"/api/checkmangofile")

#define PH_Url_GetMangoFile PH_Url(@"/api/getmangofile")

#define PH_Url_ActivatePatch PH_Url(@"/api/activatepatch")

#endif /* PHNetwork_Define_h */
