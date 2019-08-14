

#import "FspTokenFile.h"
#import "fsp_token.h"

@implementation FspTokenFile
+ (NSString *)token:(NSString *)secretKey appid:(NSString *)appid groupID:(NSString *)groupid userid:(NSString *)userid{
    fsp::tools::AccessToken token([secretKey UTF8String]);
    token.app_id = [appid UTF8String];
    token.group_id = [groupid UTF8String];
    token.user_id = [userid UTF8String];
    token.expire_time = 0;
    std::string strToken = token.Build();
    NSString *tokenStr = [NSString stringWithUTF8String:strToken.c_str()];
    return tokenStr;
}
@end
