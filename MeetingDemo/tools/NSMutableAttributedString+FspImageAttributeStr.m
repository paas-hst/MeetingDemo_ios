//
//  NSMutableAttributedString+FspImageAttributeStr.m
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/22.
//  Copyright © 2019 hst. All rights reserved.
//

#import "NSMutableAttributedString+FspImageAttributeStr.h"
#import "FspEmojiTextAttachment.h"
#import <UIKit/UIKit.h>

@implementation NSMutableAttributedString (FspImageAttributeStr)

- (NSString *)getPlainString {
    
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      if (value && [value isKindOfClass:[FspEmojiTextAttachment class]]) {
                          
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((FspEmojiTextAttachment *) value).emojiTag];
                          
                          base += ((FspEmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
