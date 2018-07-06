//
//  MainViewController.h
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class VideoCollectionViewController;

@interface MainViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic) IBOutlet UICollectionView *collectionView;

+ (instancetype)instance;

- (void)stopLocalVideo;
- (void)displayRemoteVideo:(NSString *)userID videoID:(NSString *)videoID eventType:(NSInteger)eventType;

- (void)muteRemoteAudioWithUserID:(NSString *)userID eventType:(NSInteger)eventType;

@end
