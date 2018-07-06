//
//  FspMgrDataType.h
//  FspClient
//
//  Created by Rachel on 2018/4/20.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FspKit/FspEngine.h>

@interface FspMgrLogin : NSObject

@property (nonatomic, assign) FspEventType eventType;
@property (nonatomic, assign) FspErrCode code;

@end

@interface FspMgrRemoteVideo : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *videoID;
@property (nonatomic, assign) FspRemoteVideoEventType eventType;

@end

@interface FspMgrRemoteAudio : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) FspRemoteAudioEventType eventType;

@end
