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

@interface LoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (weak, nonatomic) IBOutlet UIView *loginingView;
@property (weak, nonatomic) IBOutlet UIView *loginWarningView;
@property (weak, nonatomic) IBOutlet UIButton *reloginBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *TopConstraint;

@end

@implementation LoginViewController

#pragma mark - Life Cyle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

#pragma mark - CallBack Methods

- (void)onLogin:(NSInteger)eventType errCode:(NSInteger)errCode {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (errCode == FSP_ERR_OK) {
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:NO];
            
            _loginingView.hidden = YES;
            _loginView.hidden = NO;
        } else {
            _loginingView.hidden = YES;
            _loginWarningView.hidden = NO;
        }
    });
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
