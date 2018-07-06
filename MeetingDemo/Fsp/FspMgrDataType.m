//
//  FspMgrDataType.m
//  FspClient
//
//  Created by Rachel on 2018/4/20.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "FspMgrDataType.h"

@implementation FspMgrLogin

- (id)init {
    self = [super init];
    if (self) {
        self.eventType = -1;
        self.code = -1;
    }
    
    return self;
}

- (void)dealloc {
    
}

@end

@implementation FspMgrRemoteVideo

- (id)init {
    self = [super init];
    if (self) {
        self.userID = @"";
        self.videoID = @"";
        self.eventType = -1;
    }
    
    return self;
}

- (void)dealloc {
    self.userID = nil;
    self.videoID = nil;
}

@end

@implementation FspMgrRemoteAudio

- (id)init {
    self = [super init];
    if (self) {
        self.userID = @"";
        self.eventType = -1;
    }
    
    return self;
}

- (void)dealloc {
    self.userID = nil;
}

@end
