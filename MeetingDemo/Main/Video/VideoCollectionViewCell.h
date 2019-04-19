//
//  VideoCollectionViewCell.h
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoCollectionViewCellDelegate <NSObject>

- (void)moreBtnClicked:(id)sender;

@end

@interface VideoCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <VideoCollectionViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *renderView;

@property NSString* userId;
@property NSString* videoId;

@property (nonatomic, assign) CGRect theLastFrame;
@property (nonatomic, assign) BOOL isFullScreen;

- (void) onSecondUpdate;

- (void) showVideo:(NSString*)userId videoId:(NSString*)videoId;

- (void) show;

- (void) closeVideo;

- (void) showAudio:(NSString*)userId;

- (void) closeAudio;

@end
