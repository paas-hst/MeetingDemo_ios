//
//  MainViewController.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <FspKit/FspEngine.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "MainViewController.h"
#import "VideoCollectionViewCell.h"
#import "SettingsViewController.h"
#import "FspManager.h"
#import "FspMgrDataType.h"
#import "VideoHorizontalFlowLayout.h"
#import "UIView+Hierarchy.h"

@interface MainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSTimer *secondTimer;
    NSInteger noTouchSecondCount;
}
@property (nonatomic, weak) IBOutlet UIButton *micBtn;
@property (nonatomic, weak) IBOutlet UIButton *cameraBtn;
@property (nonatomic, weak) IBOutlet UIButton *seetingBtn;
@property (weak, nonatomic) IBOutlet UIView *viewToolbarContainer;
@property (weak, nonatomic) IBOutlet UIImageView *ivToolbarBg;
@property (nonatomic, strong) VideoHorizontalFlowLayout *flowLayout;
@property (nonatomic, strong) FspEngine *engine;

@end

static NSString * const reuseIdentifier = @"MainVideoCell";

@implementation MainViewController

#pragma mark - Life Cyle

+ (instancetype)instance {
    static MainViewController *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[MainViewController alloc] init];
    });

    return s_instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _engine = [[FspManager instance] fsp_engine];
    [self setupSubviews];
    [self bindHandles];
    
    self->secondTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(secondTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self->secondTimer forMode:NSDefaultRunLoopMode];    
    
    self->noTouchSecondCount = 0;
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [self.view addGestureRecognizer:singleRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if ([FspManager instance].isOpenLocalVideo) {
        [self updateLocalVideoPreview];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self->secondTimer invalidate];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (void) secondTimerAction
{
    self->noTouchSecondCount++;
    
    if (self->noTouchSecondCount > 5) {
        
        [UIView transitionWithView:_ivToolbarBg
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _ivToolbarBg.hidden = YES;
                        }
                        completion:NULL];
        [UIView transitionWithView:_viewToolbarContainer
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _viewToolbarContainer.hidden = YES;
                        }
                        completion:NULL];        
        
    }
    
    //定时刷新视频ui信息
    for (int i = 0; i < 6 ; i++) {        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
        [cell onSecondUpdate];
    }
}

- (void) handleTapAction:(UITapGestureRecognizer *)gesture
{
    self->noTouchSecondCount = 0;
    
    [UIView transitionWithView:_ivToolbarBg
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _ivToolbarBg.hidden = NO;
                    }
                    completion:NULL];
    [UIView transitionWithView:_viewToolbarContainer
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _viewToolbarContainer.hidden = NO;
                    }
                    completion:NULL]; 
}


- (IBAction)onClickedMicBtn:(id)sender {    
    FspManager* fspM = [FspManager instance];
    if ([fspM isAudioPublishing]) {
        [fspM stopPublishAudio];
        [_micBtn setImage:[UIImage imageNamed:@"toolbar_mic"] forState:UIControlStateNormal];
    } else {
        [fspM startPublishAudio];
        [_micBtn setImage:[UIImage imageNamed:@"toolbar_mic_open"] forState:UIControlStateNormal];
    }    
}

- (IBAction)onClickedCameraBtn:(id)sender {
    FspManager *fspM = [FspManager instance];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择摄像头"
                                                                     message:@""
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *frontAction = [UIAlertAction actionWithTitle:@"前置摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        fspM.isFrontCamera = YES;
        if (fspM.isOpenLocalVideo) {
            [_engine switchCamera];
        } else {
            [self startLocalVideo];
        }
    }];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"后置摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        fspM.isFrontCamera = NO;
        if (fspM.isOpenLocalVideo) {
            [_engine switchCamera];
        } else {
            [self startLocalVideo];            
        }
    }];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self stopLocalVideo];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:frontAction];
    [alertVC addAction:backAction];
    [alertVC addAction:closeAction];
    [alertVC addAction:cancle];
    
    UIPopoverPresentationController *popover = alertVC.popoverPresentationController;    
    if (popover) {        
        popover.sourceView = self.cameraBtn;
        popover.sourceRect = self.cameraBtn.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)onClickedSettingBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    SettingsViewController *settingVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingsIndentity"];
    [self.navigationController pushViewController:settingVC animated:NO];
}

#pragma mark - CallBack Methods

- (void)onRemoteVideoEvent:(NSString *)userID viewID:(NSString *)videoID eventType:(NSInteger)eventType {    
    VideoCollectionViewCell* videoCell = [self getVideoViewCell:userID videoID:videoID];
    if (videoCell == nil) {
        NSLog(@"no more free viewcell");
        return;
    }
    
    if (eventType == FSP_REMOTE_VIDEO_PUBLISH_STARTED) {
        // 打开远端视频
        [_engine setRemoteVideoRender:userID videoId:videoID render:videoCell.renderView];
        
        [videoCell showVideo:userID videoId:videoID];
        
    } else if (eventType == FSP_REMOTE_VIDEO_PUBLISH_STOPED) {
        // 关闭远端视频
        [_engine setRemoteVideoRender:userID videoId:videoID render:nil];   
        
        [videoCell closeVideo];
    }     
}

- (void)onRemoteAudioEvent:(NSString *)userID eventType:(NSInteger)eventType {
    VideoCollectionViewCell* videoCell = [self getVideoViewCell:userID videoID:nil];
    if (videoCell == nil) {
        NSLog(@"no more free viewcell");
        return;
    }
    
    if (eventType == FSP_REMOTE_AUDIO_PUBLISH_STARTED) {
        [videoCell showAudio:userID];
        
    } else if (eventType == FSP_REMOTE_VIDEO_PUBLISH_STOPED) {
        [videoCell closeAudio];
    }
}

#pragma mark common
- (VideoCollectionViewCell*) getVideoViewCell:(NSString*) userID videoID:(NSString*)videoID
{
    //找到一个对应的videoview, 同一用户的音频和视频用同一个view
    VideoCollectionViewCell* firstFreeView = nil;
    VideoCollectionViewCell* firstUserView = nil;
    //左上角第一个video cell的index是5， 
    for (int i = 0; i < 6 ; i++) {        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
        if ([userID isEqualToString:cell.userId]) {
            if ([videoID isEqualToString:cell.videoId] && 
                (videoID.length <= 0 || cell.videoId.length <= 0)) {
                return cell;
            } else if (firstUserView == nil){
                firstUserView = cell;
            }
        }
        if (firstFreeView == nil && (cell.userId == nil || cell.userId.length == 0)) {
            firstFreeView = cell;
        }
    }
    
    if (firstUserView != nil) {
        return firstUserView;
    }
    
    return firstFreeView;
}

#pragma mark - 视频

- (void) startLocalVideo {
    FspManager* fspM = [FspManager instance];
    VideoCollectionViewCell* videoCell = [self getVideoViewCell:fspM.myUserId videoID:nil];
    if (videoCell == nil) {
        NSLog(@"no more free viewcell");
        return;
    }
    
    FspErrCode errCode = [fspM.fsp_engine setVideoPreview:videoCell.renderView];
    if (errCode != FSP_ERR_OK) {
        NSLog(@"setVideoPreview fail");
        return;
    }    
    
    [FspManager instance].isOpenLocalVideo = YES;
    [FspManager instance].isFrontCamera = YES;
    
    [videoCell showVideo:fspM.myUserId videoId:nil]; 
    
    [_engine startPublishVideo];
    
    [_cameraBtn setImage:[UIImage imageNamed:@"toolbar_cam_open"] forState:UIControlStateNormal];
}

- (void)stopLocalVideo {
    [FspManager instance].isOpenLocalVideo = NO;
    
    FspManager* fspM = [FspManager instance];
    VideoCollectionViewCell* videoCell = [self getVideoViewCell:fspM.myUserId videoID:nil];
    if (videoCell == nil) {
        NSLog(@"no releative viewcell");
        return;
    }
        
    // 停止广播本地视频
    [_engine stopPublishVideo];
        
    // 删除本地视频预览
    [_engine stopVideoPreview];
        
    [videoCell closeVideo];
    
    [_cameraBtn setImage:[UIImage imageNamed:@"toolbar_cam"] forState:UIControlStateNormal];
}

- (void)updateLocalVideoPreview {
    if ([FspManager instance].isOpenLocalVideo) {
        FspManager* fspM = [FspManager instance];
        VideoCollectionViewCell* videoCell = [self getVideoViewCell:fspM.myUserId videoID:nil];
        if (videoCell == nil) {
            NSLog(@"no releative viewcell");
            return;
        }
        
        // 添加预览窗口
        [_engine setVideoPreview:videoCell];
    }
}

#pragma mark -

- (VideoCollectionViewCell *)cellWithIndexPath:(NSIndexPath *)indexPath {
    return (VideoCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];;
}

- (void)reloadItemsAtIndexPaths:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [UIView  performWithoutAnimation:^{
        [weakSelf.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - Bind RAC

- (void)bindHandles {
    @weakify(self);
    [[FspManager instance].singleRemoteVideo subscribeNext:^(FspMgrRemoteVideo *x) {
        @strongify(self);
        [self onRemoteVideoEvent:x.userID
                          viewID:x.videoID
                       eventType:x.eventType];
    }];
    
    [[FspManager instance].singleRemoteAudio subscribeNext:^(FspMgrRemoteAudio *x) {
        @strongify(self);
        [self onRemoteAudioEvent:x.userID
                       eventType:x.eventType];
    }];
}

#pragma mark - UI

- (void)setupSubviews {
    [self.view addSubview:self.collectionView];
    [self.collectionView sentToBack];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _flowLayout = [[VideoHorizontalFlowLayout alloc] init];
        
        // 根据横竖屏设置布局行与列
        _flowLayout.row = 2;
        _flowLayout.column = 3;
        _flowLayout.lineSpacing = 1;
        _flowLayout.columnSpacing = 1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"VideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
        [self.view addSubview:self.collectionView];
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSLayoutConstraint *constraintW = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
        NSLayoutConstraint *constraintH = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
        
        [self.view addConstraint:constraintW];
        [self.view addConstraint:constraintH];
    }
    
    return _collectionView;
}

@end
