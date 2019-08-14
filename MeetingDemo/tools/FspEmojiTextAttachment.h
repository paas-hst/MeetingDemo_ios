//
//  FspEmojiTextAttachment.h
//  MeetingDemo
//
//  Created by 张涛 on 2019/5/22.
//  Copyright © 2019 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FspEmojiTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *emojiTag;
@property(assign, nonatomic) CGSize emojiSize;  //For emoji image size
@end

NS_ASSUME_NONNULL_END
