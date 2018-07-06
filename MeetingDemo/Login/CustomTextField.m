//
//  CustomTextField.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 22, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 22, 0);
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 22, 0);
}

- (void)drawPlaceholderInRect:(CGRect)rect {
    [super drawPlaceholderInRect:rect];
}

@end
