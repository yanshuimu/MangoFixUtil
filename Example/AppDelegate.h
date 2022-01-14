//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//APPID，请登录后台新建应用后获取APPID
#define APPID @"def068fe489546ae"

//私钥
#define RSAPrivateKey @"-----BEGIN PRIVATE KEY-----MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALsa0hCIw9SmULHfdS8JmSBN+N6QTiEDg/wFe7UZHTX6N6Ertm/yf6XWVAZq1Ur1YZZv3PhU8hpGicmskzhAAKu3oAm/h/iVdvlzdwIG3HfLcly4VYTyOE59CKPQCLxFbEo/70O3xZjDMIaM5CvOl2Jzv2LEyM0KYW/9l+gyYugvAgMBAAECgYAFPSQCmIG7M4jw4gva7E7gS66bNLkrTXjllpW3JWPe/gmOtrWd/tE6KH0jzNv6BFLeLnWmcmJw/+adwfpBSfF60Rxj//dYG1Zh1nwMs4VKIhW8zaIiHCm9407EGHbBo6izXA/L2Ksl/dGoGMSP/lCNA5itAneckukGiexY+/I6AQJBAObd3CyRmIlf3iUsCkNXPQJHglpb3/ajLA0emTftvdKrLYPJ/cZW21IDxj69mFFblXC1DvKDTDoApQ1XpSZB+S8CQQDPeVat+rCWscxcrZM8wWgS/Glzv12DNN2m7eQybHP/MWoyJh+DXDuQMey/5gQ65ADjjfCcMdOcHi8dDKgC5EEBAkAGlmIH64ecs92U1fLdBQo6nGu9xE1ZrkI9hZf9no0CC9xanFLfa+8KIg1wENzdxW04MBJjHRf5t7b98HhH5S4FAkAofj8rr6z9jHAdeoctKXZdlkQioivnKs9EAFQ0fzRYj1Vxuj0WT08Uwpm5jnQu5kdCInbelV7+rml1mv3DqrcBAkEAnKH2C2KlDLZ5TOK1DcgF0/bavPqgq94Hfk4pyfQaK7L/T2MoiL+h4pRzJFJ75NqZ30JDbP+chIFS7APXcTlv3A==-----END PRIVATE KEY-----"

//公钥
#if RELEASE
#else
#define RSAPublicKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7GtIQiMPUplCx33UvCZkgTfjekE4hA4P8BXu1GR01+jehK7Zv8n+l1lQGatVK9WGWb9z4VPIaRonJrJM4QACrt6AJv4f4lXb5c3cCBtx3y3JcuFWE8jhOfQij0Ai8RWxKP+9Dt8WYwzCGjOQrzpdic79ixMjNCmFv/ZfoMmLoLwIDAQAB-----END PUBLIC KEY-----"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

