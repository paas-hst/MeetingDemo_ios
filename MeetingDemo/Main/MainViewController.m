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
    
    BOOL _is_open_local_camera;
    
    BOOL _cur_camera_position_front;
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
    
    [self addApplicationNotification];
    
    _is_open_local_camera = false;
    
    //默认摄像头为前置
    _cur_camera_position_front = YES;
}


- (void) addApplicationNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicaitionWillEnterBackGround) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackGround) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeGround) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)applicaitionWillEnterBackGround{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidEnterBackGround{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if ([[FspManager instance] isOpenLocalVideo]) {
        [self stopLocalVideo];
    }
    self->secondTimer.fireDate = [NSDate distantFuture];
}

- (void)applicationWillEnterForeGround{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)applicationDidBecomeActive{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    if (_is_open_local_camera == true) {
        __weak MainViewController *weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf startLocalVideo];
        });
        
    }
    
    self->secondTimer.fireDate = [NSDate distantFuture];
    
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
    [super viewWillDisappear:animated];
    _is_open_local_camera = false;
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

        if (fspM.isOpenLocalVideo) {
            if (_cur_camera_position_front == YES) {
                return;
            }
            [_engine switchCamera];
            _cur_camera_position_front = YES;
        } else {
            [self startLocalVideo];
        }
   
        _is_open_local_camera = true;
        
    }];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"后置摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        if (fspM.isOpenLocalVideo) {
            if (_cur_camera_position_front == NO) {
                return;
            }
            [_engine switchCamera];
            _cur_camera_position_front = NO;
        } else {
            [self startLocalVideo];
            [_engine switchCamera];
            _cur_camera_position_front = NO;
        }

        _is_open_local_camera = true;
    }];
    UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"关闭摄像头" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self stopLocalVideo];
        
        _is_open_local_camera = false;
        
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
        [_engine setRemoteVideoRender:userID videoId:videoID render:videoCell.renderView mode:FSP_RENDERMODE_FIT_CENTER];
        [videoCell showVideo:userID videoId:videoID];
    } else if (eventType == FSP_REMOTE_VIDEO_PUBLISH_STOPED) {
        // 关闭远端视频
        [_engine setRemoteVideoRender:userID videoId:videoID render:nil mode:FSP_RENDERMODE_FIT_CENTER];
        
        VideoCollectionViewCell *cell = [self getCellWithUserId:userID videoId:videoID];
        [cell closeVideo];
  
    } else if (eventType == FSP_REMOTE_VIDEO_FIRST_RENDERED){
        
    }
}

- (VideoCollectionViewCell *)getCellWithUserId:(NSString *)userid videoId:(NSString *)videoid
{
    VideoCollectionViewCell *cur_cell = nil;
    for (int i = 0; i< 6; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
        if ((([cell.userId isEqualToString:userid] && [cell.videoId isEqualToString:videoid]) || ([cell.userId isEqualToString:userid] && videoid.length <= 0))) {
            cur_cell = cell;
            break;
        }
        
    }
    return cur_cell;
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
        VideoCollectionViewCell *cell = [self getCellWithUserId:userID videoId:nil];
        [cell closeAudio];
    }
}

#pragma mark common
- (VideoCollectionViewCell*) getVideoViewCell:(NSString*) userID videoID:(NSString*)videoID
{
    //找到一个对应的videoview, 同一用户的音频和视频用同一个view
    VideoCollectionViewCell* firstFreeView = nil;
    VideoCollectionViewCell* firstUserView = nil;
    VideoCollectionViewCell *secondRemoteScreenView = nil;
    
    if (videoID.length <= 0) {
        for (int i = 0; i < 6; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
            if ([cell.userId isEqualToString:userID]) {
                return cell;
            }
        }
    }
    
    //左上角第一个video cell的index是5，
    if (![videoID isEqualToString:@"reserved_videoid_screenshare"]) {
        for (int i = 0; i < 6 ; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
            /*
            if ([userID isEqualToString:cell.userId] && ![cell.videoId isEqualToString:@"reserved_videoid_screenshare"])
            {
                if ([videoID isEqualToString:cell.videoId] &&
                    (videoID.length <= 0 || cell.videoId.length <= 0)) {
                    return cell;
                } else if (firstUserView == nil){
                    firstUserView = cell;
                }
            }
            */
            //得到与userID相同的非投屏流的cell
            if ([userID isEqualToString:cell.userId] && ![cell.videoId isEqualToString:@"reserved_videoid_screenshare"]) {
                if ( videoID.length > 0 && ![cell.videoId isEqualToString:videoID]) {
                    for (int i = 0; i < 6; i ++) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                        VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
                        if (firstFreeView == nil && (cell.userId == nil || cell.userId.length == 0)) {
                            firstFreeView = cell;
                            return firstFreeView;
                        }
                    }
       
                }
                return cell;
                
            }
            
            if (firstFreeView == nil && (cell.userId == nil || cell.userId.length == 0)) {
                firstFreeView = cell;
                return firstFreeView;
            }
            
        }
    }


    //当传过来要一个remoteScreenView的时候
    if ([videoID isEqualToString:@"reserved_videoid_screenshare"]) {
        for (int i = 0; i< 6; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            VideoCollectionViewCell *cell = [self cellWithIndexPath:indexPath];
            if ([cell.userId isEqualToString:userID] && [cell.videoId isEqualToString:@"reserved_videoid_screenshare"]) {
                return cell;
            }
            if (secondRemoteScreenView == nil && (cell.userId == nil || cell.userId.length == 0) && (cell.videoId == nil || cell.videoId.length == 0)) {
                secondRemoteScreenView = cell;
                return secondRemoteScreenView;
            }
            
        }
        
        return secondRemoteScreenView;
    }

    
    if (firstUserView != nil) {
        return firstUserView;
    }
    
    return nil;
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
    VideoCollectionViewCell *videoCell = [self getCellWithUserId:fspM.myUserId videoId:nil];
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    tap.numberOfTapsRequired = 2;
    [cell addGestureRecognizer:tap];
    return cell;
}

- (void)doubleTap:(UITapGestureRecognizer *)tap{
    VideoCollectionViewCell *cell = (VideoCollectionViewCell *)tap.view;
    if (cell.isFullScreen) {
        cell.isFullScreen = NO;
        cell.frame = cell.theLastFrame;
        cell.renderView.frame = cell.bounds;
        for (CALayer *layer in cell.renderView.layer.sublayers) {
            layer.frame = cell.bounds;
        }
        for (VideoCollectionViewCell *allCells in self.collectionView.visibleCells) {
            allCells.hidden = NO;
        }
        
    }else{
    
        CGRect old = cell.frame;
        CGRect new = self.view.bounds;
        cell.frame = new;
        cell.theLastFrame = old;
        cell.isFullScreen = YES;
        
        cell.renderView.frame = new;
        for (CALayer *layer in cell.renderView.layer.sublayers) {
            layer.frame = new;
        }

        for (VideoCollectionViewCell *allCells in self.collectionView.visibleCells) {
            if (allCells == cell) {
            
            }else{
                allCells.hidden = true;
            }
            
        }
    
    }
    
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
        
        _flowLayout.row = 2;
        _flowLayout.column = 3;
        _flowLayout.lineSpacing = 1;
        _flowLayout.columnSpacing = 1;
        
        // 根据横竖屏设置布局行与列
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.scrollEnabled = NO;
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
