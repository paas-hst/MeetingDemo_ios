//
//  LoginConfigViewController.m
//  MeetingDemo
//
//  Created by admin on 2019/1/23.
//  Copyright © 2019年 hst. All rights reserved.
//

#import "LoginConfigViewController.h"
#include "FspManager.h"

@interface LoginConfigViewController ()
{
    BOOL _is_details_input;
    


}
@property (weak, nonatomic) IBOutlet UITextField *textAppid;
@property (weak, nonatomic) IBOutlet UITextField *textSecrectKey;
@property (weak, nonatomic) IBOutlet UITextField *textServerAddr;
@property (weak, nonatomic) IBOutlet UISwitch *switchUseConfig;

@end

@implementation LoginConfigViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addKeyBoardEvents];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self removeKeyBoardEvents];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _is_details_input = NO;
    //判断是否使用自定义配置
    BOOL useConfigVal = [[NSUserDefaults standardUserDefaults] boolForKey:CONFIG_KEY_USECONFIG];
    if(useConfigVal){
        self.switchUseConfig.on = YES;
        //填充好数据
        _textAppid.text = [[NSUserDefaults standardUserDefaults] stringForKey:CONFIG_KEY_APPID];
        _textSecrectKey.text = [[NSUserDefaults standardUserDefaults] stringForKey:CONFIG_KEY_SECRECTKEY];
        _textServerAddr.text = [[NSUserDefaults standardUserDefaults] stringForKey:CONFIG_KEY_SERVETADDR];
    }else{
        self.switchUseConfig.on = NO;
    }
    if (self.switchUseConfig.isOn) {
        //使用自定义配置
        self.textAppid.enabled = YES;
        self.textSecrectKey.enabled = YES;
        self.textServerAddr.enabled = YES;
    }else{
        //使用默认配置
        self.textAppid.enabled = NO;
        self.textSecrectKey.enabled = NO;
        self.textServerAddr.enabled = NO;
    }

    // Do any additional setup after loading the view from its nib.
    [self loadSavedConfig:NO];
    
    [_textAppid addTarget:self
                            action:@selector(textFieldDidChange:)
                  forControlEvents:UIControlEventEditingChanged];
    [_textSecrectKey addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    [_textServerAddr addTarget:self
                           action:@selector(textFieldDidChange:)
                 forControlEvents:UIControlEventEditingChanged];
    

}

- (void)addKeyBoardEvents{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)removeKeyBoardEvents{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

 - (void)keyBoardWillShow:(NSNotification *)aNotification
{
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int deltaY = keyboardRect.size.height;
        int key_board_width = keyboardRect.size.width;
        NSLog(@"键盘高度是  %d",deltaY);
        NSLog(@"键盘宽度是  %d",key_board_width);
    

    //一共的高度
    CGFloat height = self.view.bounds.size.height;
    
    if ([self.textAppid isFirstResponder]) {
        NSLog(@"self.textAppid");
        //在父视图的位置
        CGRect frame = self.textAppid.frame;
        //在Y轴的位置下方
        CGFloat appid_height = frame.origin.y + frame.size.height;
        if (deltaY + appid_height > height) {
            //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
            [UIView animateWithDuration:0.25f animations:^{
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY + appid_height - height, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
    }
    
    if ([self.textSecrectKey isFirstResponder]) {
        NSLog(@"self.textSecrectKey");
        //在父视图的位置
        CGRect frame = self.textSecrectKey.frame;
        //在Y轴的位置下方
        CGFloat appid_height = frame.origin.y + frame.size.height;
        if (deltaY + appid_height > height) {
            //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
            [UIView animateWithDuration:0.25f animations:^{
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - deltaY - appid_height + height - 20, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
    }
    
    if ([self.textServerAddr isFirstResponder]) {
        NSLog(@"self.textServerAddr");
        //在父视图的位置
        CGRect frame = self.textServerAddr.frame;
        //在Y轴的位置下方
        CGFloat appid_height = frame.origin.y + frame.size.height;
        if (deltaY + appid_height > height) {
            //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
            [UIView animateWithDuration:0.25f animations:^{
                [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - deltaY - appid_height + height - 20, self.view.frame.size.width, self.view.frame.size.height)];
            }];
        }
    }
}


- (void)keyBoardWillHide:(NSNotification *)noti{
    [UIView animateWithDuration:0.25f animations:^{
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(id)sender {
    BOOL isGroupNameEmpty = [_textAppid.text isEqualToString:@""];
    BOOL isUserNameEmpty = [_textSecrectKey.text isEqualToString:@""];
    BOOL isAddrNameEmpty = [_textServerAddr.text isEqualToString:@""];
    _is_details_input = (!isGroupNameEmpty && !isUserNameEmpty && !isAddrNameEmpty) ? YES : NO;
    _textAppid.background = [UIImage imageNamed:!isGroupNameEmpty ? @"login_input_focused" : @"login_input"];
    _textSecrectKey.background = [UIImage imageNamed:!isUserNameEmpty ? @"login_input_focused" : @"login_input"];
    _textServerAddr.background = [UIImage imageNamed:!isAddrNameEmpty ? @"login_input_focused" : @"login_input"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (_textAppid.isFirstResponder) {
        [_textAppid resignFirstResponder];
    }
    
    if (_textSecrectKey.isFirstResponder) {
        [_textSecrectKey resignFirstResponder];
    }
    
    if (_textServerAddr.isFirstResponder) {
        [_textServerAddr resignFirstResponder];
    }
}

- (void) loadSavedConfig:(BOOL)isFromUi
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (isFromUi == NO) {
        BOOL useConfigVal = [userDefaults boolForKey:CONFIG_KEY_USECONFIG];
        _switchUseConfig.on = useConfigVal;
    }
    
    if (_switchUseConfig.on) {
        _textAppid.text = [userDefaults stringForKey:CONFIG_KEY_APPID];
        _textSecrectKey.text = [userDefaults stringForKey:CONFIG_KEY_SECRECTKEY];
        _textServerAddr.text = [userDefaults stringForKey:CONFIG_KEY_SERVETADDR];
    }
}

- (IBAction)onBtnConfirm:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:_switchUseConfig.on forKey:CONFIG_KEY_USECONFIG];
    
    if (_switchUseConfig.on) {
        [userDefaults setObject:_textAppid.text forKey:CONFIG_KEY_APPID];
        [userDefaults setObject:_textSecrectKey.text forKey:CONFIG_KEY_SECRECTKEY];
        [userDefaults setObject:_textServerAddr.text forKey:CONFIG_KEY_SERVETADDR];
    }
    [userDefaults synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onBtnCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onDefaultOptChange:(id)sender {
    if (_switchUseConfig.on) {
        _textAppid.enabled = YES;
        _textSecrectKey.enabled = YES;
        _textServerAddr.enabled = YES;
        
        [self loadSavedConfig:YES];
    } else {
        _textAppid.text = @"";
        _textAppid.enabled = NO;
        
        _textSecrectKey.text = @"";
        _textSecrectKey.enabled = NO;
        
        _textServerAddr.text = @"";
        _textServerAddr.enabled = NO;
    }
}

- (IBAction)onAppIdDbClick:(id)sender {
    /*
    _nDbClickCount++;
    if (_nDbClickCount >= 2) {
        _textServerAddr.hidden = NO;
    }
     */
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
