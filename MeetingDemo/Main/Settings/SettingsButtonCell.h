//
//  SettingsButtonCell.h
//  FspClient
//
//  Created by Rachel on 2018/4/21.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingButtonCellDelegate <NSObject>

- (void)clickButtonAtTag:(NSInteger)tag;

@end

@interface SettingsButtonCell : UITableViewCell

@property (nonatomic, weak) id <SettingButtonCellDelegate>delegate;
@property (nonatomic, weak) IBOutlet UILabel *sTextLabel;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) NSInteger btnTag;

@end
