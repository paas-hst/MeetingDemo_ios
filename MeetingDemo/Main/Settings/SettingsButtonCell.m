//
//  SettingsButtonCell.m
//  FspClient
//
//  Created by Rachel on 2018/4/21.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "SettingsButtonCell.h"

@interface SettingsButtonCell ()

@property (weak, nonatomic) IBOutlet UIButton *sBtn;

@end

@implementation SettingsButtonCell

- (IBAction)onClickedCellBtn:(id)sender {
    if ([_delegate performSelector:@selector(clickButtonAtTag:)]) {
        [_delegate clickButtonAtTag:_sBtn.tag];
    }
}

- (void)setBtnTitle:(NSString *)btnTitle {
    [_sBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)setBtnTag:(NSInteger)btnTag {
    _sBtn.tag = btnTag;
}

@end
