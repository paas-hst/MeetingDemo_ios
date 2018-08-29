//
//  FspManager.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>

#include <string>

#import "FspKit/FspEngine.h"

#include "fsp_token.h"

#import "FspManager.h"
#import "FspMgrDataType.h"

#define APP_ID ""
#define APP_SECRET_KEY ""


@interface FspManager () <FspEngineDelegate>
{
    BOOL _isAudioPublishing;
}
@property (nonatomic, strong) FspEngine *fsp_engine;

@end

@implementation FspManager

+ (instancetype)instance {
    static FspManager *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[FspManager alloc] init];
    });
    
    return s_instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _singleLogin = [RACSubject subject];
        _singleRemoteVideo = [RACSubject subject];
        _singleRemoteAudio = [RACSubject subject];
        _isOpenLocalVideo = NO;
        _isFrontCamera = YES;
        _isAudioPublishing = NO;
    }
    
    return self;
}

- (void)dealloc {
    [_singleLogin sendCompleted];
    [_singleRemoteVideo sendCompleted];
    [_singleRemoteAudio sendCompleted];

    _singleLogin = nil;
    _singleRemoteVideo = nil;
    _singleRemoteAudio = nil;
}

- (BOOL)initFsp {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentPaths objectAtIndex:0];
    
    _fsp_engine = [FspEngine sharedEngineWithAppId:@APP_ID
                                           logPath:documentPath
                                        serverAddr:@""
                                          delegate:self];
    
    return _fsp_engine ? YES : NO;
}

- (FspEngine *)fsp_engine {
    return _fsp_engine;
}

#pragma proxy to FspEngine
- (BOOL)joinGroup:(NSString * _Nonnull)grouplId
                 userId:(NSString * _Nonnull)userId
{
    fsp::tools::AccessToken token(APP_SECRET_KEY);
    
    token.app_id = APP_ID;
    token.group_id = [grouplId UTF8String];
    token.user_id = [userId UTF8String];
    token.expire_time = 0;
    
    std::string strToken = token.Build();    
    
    self.myGroupId = grouplId;
    self.myUserId = userId;
    return [self.fsp_engine joinGroup:[NSString stringWithUTF8String:strToken.c_str()] groupId:grouplId userId:userId];
    
    return YES;
}

- (BOOL)startPublishAudio
{
    if ([self.fsp_engine startPublishAudio] == FSP_ERR_OK) {
        _isAudioPublishing = YES;
        return YES;
    }
    
    return NO;
}

- (BOOL)stopPublishAudio
{
    [self.fsp_engine stopPublishAudio];
    _isAudioPublishing = NO;
    return YES;    
}

- (BOOL)isAudioPublishing
{
    return _isAudioPublishing;
}

#pragma mark - FspEngineDelegate

- (void)fspEvent:(FspEventType)eventType errCode:(FspErrCode)errCode {
    NSLog(@"++++++%@", NSStringFromSelector(_cmd));
    FspMgrLogin *temp = [[FspMgrLogin alloc] init];
    temp.eventType = eventType;
    temp.code = errCode;
    [_singleLogin sendNext:temp];
}

- (void)remoteVideoEvent:(NSString * _Nonnull)userId
                 videoId:(NSString * _Nonnull)videoId
               eventType:(FspRemoteVideoEventType)eventType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FspMgrRemoteVideo *temp = [[FspMgrRemoteVideo alloc] init];
        temp.userID = userId;
        temp.videoID = videoId;
        temp.eventType = eventType;
        [_singleRemoteVideo sendNext:temp];
    });
}

- (void)remoteAudioEvent:(NSString * _Nonnull)userId
               eventType:(FspRemoteAudioEventType)eventType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        FspMgrRemoteAudio *temp = [[FspMgrRemoteAudio alloc] init];
        temp.userID = userId;
        temp.eventType = eventType;
        [_singleRemoteAudio sendNext:temp];
    });    
}

@end
