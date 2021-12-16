//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//私钥
#define RSAPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANTrw+drTSE80JYi9WFzZwk7ySZhnzvsgkAyTfr5OLLNsJ8WwR/JuiURIfvC4S1ekTGdiZeK1Fa0pTMezpNEEPu+8hKM0eQ79qhrDbnHyUryMWN1RDVBM8QWhXoCyLl92c+ADZAcLWw+VJQyAP4QPmQnavIJpVhu/bX5mjdCc0+5AgMBAAECgYEAyedv88jacQQ8P8KSsYA/WpAo5I558tcJhFqve6hMzbEjJRjstXoTXAbtFNHtuZoNUOE0klGBnV7bsKgr95X6CyOwPZbHiiT/+PjrTUXsIleeuFuN6vs7CUECAnoPzGuROQMhOUrXAuFJPtUzFkyvTWWoRsnchEsjrK8sHJOkhAECQQD3lS+0+Z1sr4wSeCXkwDwge7fx2nm0Fe0e893+vwHlDXF/j5vGWnWn5jMGOhTRSvT4AOAAk3qQcwYU2Su3Ng/BAkEA3CjnMnthwZFyxBTMX9QwdWpvQS5nX0B5GpHVgT9/R6x02sIJebPDuqfzbAOh02vocBsNNP4zSggfGHcDdF09+QJAK0BjwjDtQIR2au+UZx7yIhaa7uRk6IIAF60wtgU2VoZ/snIrG37IGRnNBiR1aI64tu6oM1GQUtXVVSUPTwVhwQJBANjVhFfJA0/lU/ZhUaT0VMHgETFOZct/sYcEqRbCFjbeWLz4LOLrtVPKhMoWjbSwa962FfzifFtmwlGTLhjWmOkCQGV8U3E0oXDeDTmqvybaygL1Ifgk0PH4jYIKFa939nds6ocwkN/G2gVxFIaxQrdflIrTYdHnvR+95dp7A5v4uZU="

//公钥
#if RELEASE
#else
#define RSAPublicKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDU68Pna00hPNCWIvVhc2cJO8kmYZ877IJAMk36+TiyzbCfFsEfybolESH7wuEtXpExnYmXitRWtKUzHs6TRBD7vvISjNHkO/aoaw25x8lK8jFjdUQ1QTPEFoV6Asi5fdnPgA2QHC1sPlSUMgD+ED5kJ2ryCaVYbv21+Zo3QnNPuQIDAQAB-----END PUBLIC KEY-----"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

