//
//  FspManager.h
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CONFIG_KEY_USECONFIG @"fspuseconfig_key"
#define CONFIG_KEY_APPID @"fspappid_key"
#define CONFIG_KEY_SECRECTKEY @"fspsecretkey_key"
#define CONFIG_KEY_SERVETADDR @"fspserveraddr_key"

@class FspEngine;
@class RACSubject;

@interface FspManager : NSObject

@property (nonatomic, strong) RACSubject *singleLogin;
@property (nonatomic, strong) RACSubject *singleRemoteVideo;
@property (nonatomic, strong) RACSubject *singleRemoteAudio;
@property (nonatomic, assign) BOOL isOpenLocalVideo;
@property (nonatomic, assign) BOOL isFrontCamera;

@property NSString* myGroupId;
@property NSString* myUserId;

+ (instancetype)instance;
- (BOOL)initFsp;
- (FspEngine *)fsp_engine;

#pragma proxy to FspEngine
- (BOOL) joinGroup:(NSString * _Nonnull)grouplId
                  userId:(NSString * _Nonnull)userId;

- (BOOL)startPublishAudio;

- (BOOL)stopPublishAudio;

- (BOOL)isAudioPublishing;

@end
