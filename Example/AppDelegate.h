//
//  AppDelegate.h
//  MangoFixUtil
//
//  Created by mac on 2021/2/26.
//

#import <UIKit/UIKit.h>

//私钥
#define RSAPrivateKey @"-----BEGIN PRIVATE KEY-----MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAM1oh0iGVrMqiq1pURvfPTnvdAeMvzoskx3SizqHIKfxYhOFC2qaAD1EJoGKqFQx3NrOqpWV3oT2+9zVb4jR0FHkaE+3e+rW5+Y5amP2jzDBgzFjN9rJXDPl8b8PKA9g6om6iMeZlK0HPDAo9uE8VB+11/6FXIgI+9xdaQ7K3wkfAgMBAAECfz3IMuidf3ZkVVHTW5IGk2PZogyjSOE2hwlxSm9QNYJOGDHG0qg9qdTDqtFL41Vvqf4mKyjS6xsTLq49hE6izQVKCPwx/y0hp9aMvDgmC0q9PlHRcvdeoM4C/NB9ZTUrcc7yvWRFvXYX5mOEHTQWnureqh8yZ8fqnHtZLzgDXUkCQQD9lY0aT2GYZxhmUnRPdBjM2iGTXlpMs5XuCiadeBoPQxgUm98yJN3KoFbDI8xMK9FQvPj2ETJwK6JadgKZW7Y1AkEAz118B5+qEIQ62ylTx3oLYJg+Jw9p0R+5w2aC6K2jpe1VvrNCIS4zh+AQiLlqtOXLGgcZ9+5RM8TtrZ4LiVccgwJBAI/lflVwuDvoPLNLlM7FXZFZMnZSs0EVIz4ZqoHu9jK06wQ+0y+8NdNWmwVO2g5bSwLayRew+IMob4+PqbfmkAUCQCVFFRy9qrBLQ9TOKbupiM/0rP8SOx+WBypCi3bMdqRE8utShqk2B5b9Q5t/T9lxj75+1kEEeV3HoDxbMpGdsYcCQQCB3qOi+PazZqL6Ao73coTMsEPHOg8DZvkYo6rztwQ1jCP0C/D7sjRP8hYJOjYODtILtd0r/IYrSGL3JvD9s/9X-----END PRIVATE KEY-----"

//公钥
#if RELEASE
#else
#define RSAPublicKey @"-----BEGIN PUBLIC KEY-----MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDNaIdIhlazKoqtaVEb3z0573QHjL86LJMd0os6hyCn8WIThQtqmgA9RCaBiqhUMdzazqqVld6E9vvc1W+I0dBR5GhPt3vq1ufmOWpj9o8wwYMxYzfayVwz5fG/DygPYOqJuojHmZStBzwwKPbhPFQftdf+hVyICPvcXWkOyt8JHwIDAQAB-----END PUBLIC KEY-----"
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow * window;

@end

