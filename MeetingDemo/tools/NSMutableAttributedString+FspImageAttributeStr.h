//
//  NSMutableAttributedString+FspImageAttributeStr.h
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/22.
//  Copyright © 2019 hst. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (FspImageAttributeStr)

#pragma mark 图片转化成纯文本
- (NSString *)getPlainString;
@end

NS_ASSUME_NONNULL_END
