
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FspTokenFile : NSObject
+ (NSString *)token:(NSString *)secretKey appid:(NSString *)appid groupID:(NSString *)groupid userid:(NSString *)userid;
@end

NS_ASSUME_NONNULL_END
