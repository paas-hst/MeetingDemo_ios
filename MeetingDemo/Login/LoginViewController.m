//
//  LoginViewController.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <FspKit/FspEngine.h>
#import <ReactiveObjC/ReactiveObjC.h>

#import "LoginViewController.h"
#import "MainViewController.h"
#import "FspManager.h"
#import "AppDelegate.h"
#import "FspMgrDataType.h"
#import "LoginConfigViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *loginingView;
@property (weak, nonatomic) IBOutlet UIView *loginWarningView;
@property (weak, nonatomic) IBOutlet UIButton *reloginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *versionInfoLabel;

@property (nonatomic, strong) MainViewController *mainVC;

@end

@implementation LoginViewController

#pragma mark - Life Cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self checkAudioStatus];
    [self checkVideoStatus];
    
    _joinBtn.enabled = NO;
    
    [self bindHandles];
    
    UITapGestureRecognizer *singleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:singleGesture];
    
    [_groupNameTextField addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    [_userNameTextField addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [_versionInfoLabel setText:[NSString stringWithFormat:@"SdkVersion:  %@", [FspEngine getVersionInfo]]];
}

- (void)checkAudioStatus{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启麦克风
            [self requestMic];
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            
            break;
        case AVAuthorizationStatusDenied:
            //玩家未授权
            
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            
            break;
        default:
            break;
    }
    
    
}

- (void)requestMic{
    
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
        if (granted) {
            NSLog(@"******麦克风准许");
        }else{
            NSLog(@"******麦克风不准许");
        }
    }];
    
}

//授权相机
- (void)videoAuthAction
{
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        NSLog(@"%@",granted ? @"相机准许":@"相机不准许");
    }];
    
}


- (void) checkVideoStatus
{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (authStatus) {
        case AVAuthorizationStatusNotDetermined:
            //没有询问是否开启相机
            [self videoAuthAction];
            break;
        case AVAuthorizationStatusRestricted:
            //未授权，家长限制
            
            break;
        case AVAuthorizationStatusDenied:
            //未授权
            
            break;
        case AVAuthorizationStatusAuthorized:
            //玩家授权
            
            break;
        default:
            break;
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)joinBtnClicked:(id)sender {
    _loginView.hidden = YES;
    _loginingView.hidden = NO;
    [[FspManager instance] joinGroup:_groupNameTextField.text userId:_userNameTextField.text];
}

- (IBAction)onBtnAppConfig:(id)sender {
    LoginConfigViewController* loginConfigCv = [[LoginConfigViewController alloc] initWithNibName:@"LoginConfig" bundle:nil];
    [self.navigationController presentViewController:loginConfigCv animated:YES completion:nil];
}

#pragma mark - CallBack Methods

- (void)onLogin:(NSInteger)eventType errCode:(NSInteger)errCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (errCode == FSP_ERR_OK) {
            if (!_mainVC) {
                [self.navigationController pushViewController:self.mainVC animated:NO];
            }
            _loginingView.hidden = YES;
            _loginView.hidden = NO;
        } else {
            _loginingView.hidden = YES;
            _loginWarningView.hidden = NO;
        }
    });
}

- (MainViewController *)mainVC{
    if (!_mainVC) {
        _mainVC = [[MainViewController alloc] init];
    }
    return _mainVC;
}

#pragma mark - Bind RAC

- (void)bindHandles {
    @weakify(self);
    [[FspManager instance].singleLogin subscribeNext:^(FspMgrLogin *x) {
        @strongify(self);
        [self onLogin:x.eventType errCode:x.code];
    }];
}

#pragma mark - TexiField Methods

- (void)textFieldDidChange:(id)sender {
    BOOL isGroupNameEmpty = [_groupNameTextField.text isEqualToString:@""];
    BOOL isUserNameEmpty = [_userNameTextField.text isEqualToString:@""];
    _joinBtn.enabled = (!isGroupNameEmpty && !isUserNameEmpty) ? YES : NO;
    _groupNameTextField.background = [UIImage imageNamed:!isGroupNameEmpty ? @"login_input_focused" : @"login_input"];
    _userNameTextField.background = [UIImage imageNamed:!isUserNameEmpty ? @"login_input_focused" : @"login_input"];
}

- (void)keyboardWillShow:(NSNotification *)sender {
    NSDictionary *info = [sender userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    CGFloat keyboardY = keyboardRect.origin.y;
    
    if (_userNameTextField.isFirstResponder && keyboardY <= CGRectGetMaxY(_userNameTextField.frame)) {
        CGFloat offset = CGRectGetMaxY(_userNameTextField.frame) - keyboardY;
        _TopConstraint.constant -= offset;
    }
    
    if (_groupNameTextField.isFirstResponder && keyboardY <= CGRectGetMaxY(_groupNameTextField.frame)) {
        CGFloat offset = CGRectGetMaxY(_groupNameTextField.frame) - keyboardY;
        _TopConstraint.constant -= offset;
    }
}

- (void)keyboardWillHide:(NSNotification *)sender {
    
}

- (void)hideKeyboard {
    if (_groupNameTextField.isFirstResponder) {
        [_groupNameTextField resignFirstResponder];
    }
    
    if (_userNameTextField.isFirstResponder) {
        [_userNameTextField resignFirstResponder];
    }
}

@end
