//
//  FspEmojiTextAttachment.m
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/22.
//  Copyright © 2019 hst. All rights reserved.
//

#import "FspEmojiTextAttachment.h"

@implementation FspEmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    return CGRectMake(0, 0, _emojiSize.width, _emojiSize.height);
}
@end
