//
//  VideoHorizontalFlowLayout.h
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHorizontalFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat columnSpacing;

@end
