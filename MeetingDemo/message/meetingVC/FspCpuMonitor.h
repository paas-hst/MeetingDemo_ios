//
//  FspCpuMonitor.h
//  MeetingDemo
//
//  Created by 张涛 on 2019/7/26.
//  Copyright © 2019 hst. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FspCpuMonitor : NSObject

+ (instancetype)shareInstance;

- (void)beginMonitor; //开始监视卡顿
- (void)endMonitor;   //停止监视卡顿
@end

NS_ASSUME_NONNULL_END
