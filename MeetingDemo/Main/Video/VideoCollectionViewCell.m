//
//  VideoCollectionViewCell.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "FspKit/FspEngine.h"
#import "FspManager.h"

#import "VideoCollectionViewCell.h"

@interface VideoCollectionViewCell ()
{
    BOOL isAudioOpening;
}
@property (weak, nonatomic) IBOutlet UIProgressView *pvAudioEnergy;
@property (nonatomic, weak) IBOutlet UIImageView *videoBg;
@property (nonatomic, weak) IBOutlet UILabel *videoInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
@property (nonatomic, weak) IBOutlet UIImageView *micImageView;
@end

@implementation VideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self->isAudioOpening = NO;
    
    self.micImageView.hidden = YES;
    self.videoInfoLabel.hidden = YES;
    self.pvAudioEnergy.hidden = YES;
}

- (IBAction)onClickedMoreBtn:(id)sender {
    if ([_delegate performSelector:@selector(moreBtnClicked:)]) {
        [_delegate moreBtnClicked:sender];
    }
}

- (void) onSecondUpdate
{
    if (self.userId == nil) {
        return;
    }
    
    FspManager* fspM = [FspManager instance];
    
    FspVideoStatsInfo* statsInfo = [fspM.fsp_engine getVideoStats:self.userId videoId:self.videoId];
    self.videoInfoLabel.text = [NSString stringWithFormat:@"%@: %@", self.userId, [statsInfo description]];
    
    if (self->isAudioOpening) {
        self.pvAudioEnergy.progress = [fspM.fsp_engine getRemoteAudioEnergy:self.userId] / 100.0f;
    }
}

- (void) showVideo:(NSString*)userId videoId:(NSString*)videoId
{
    self.videoBg.hidden = YES;
    self.videoInfoLabel.hidden = NO;
    
    self.userId = userId;
    self.videoId = videoId;
}

- (void) closeVideo
{    
    self.videoBg.hidden = NO;    
    self.videoId = nil;
    
    self.videoInfoLabel.hidden = YES;
    
    [self checkUserId];
    
    [self setNeedsLayout];
}

- (void) showAudio:(NSString*)userId
{
    self->isAudioOpening = YES;    
    self.userId = userId;
    
    self.videoInfoLabel.hidden = NO;
    self.micImageView.hidden = NO;
    self.pvAudioEnergy.hidden = NO;
}

- (void) closeAudio
{
    self->isAudioOpening = NO;
    
    self.micImageView.hidden = YES;
    self.pvAudioEnergy.hidden = YES;
    
    [self checkUserId];
}

- (void) checkUserId
{
    if (!self->isAudioOpening && self.videoId != nil) {
        self.userId = nil;
        self.videoInfoLabel.hidden = YES;
    }
}

@end
