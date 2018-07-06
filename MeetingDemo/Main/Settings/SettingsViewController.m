//
//  SettingsViewController.m
//  FspClient
//
//  Created by Rachel on 2018/4/19.
//  Copyright © 2018年 hst. All rights reserved.
//

#import <FspKit/FspEngine.h>

#import "SettingsViewController.h"
#import "SettingsTextCell.h"
#import "SettingsSliderCell.h"
#import "SettingsButtonCell.h"
#import "SettingsStateCell.h"
#import "SettingsVideoCell.h"
#import "FspManager.h"
#import "MainViewController.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate, SettingButtonCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSArray *headerTitles;
@property (nonatomic, strong) FspEngine *engine;

@end

static NSString * const kSettingTextCell = @"kSettingTextCell";
static NSString * const kSettingStateCell = @"kSettingStateCell";

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _engine = [[FspManager instance] fsp_engine];
    _headerTitles = @[@"基本信息", @"麦克风", @"扬声器"];
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsTextCell" bundle:nil] forCellReuseIdentifier:kSettingTextCell];
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsStateCell" bundle:nil] forCellReuseIdentifier:kSettingStateCell];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self updateLocalVideoPreview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)updateLocalVideoPreview {
    if ([FspManager instance].isOpenLocalVideo) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:2];
        SettingsVideoCell *cell = (SettingsVideoCell *)[_tableView cellForRowAtIndexPath:indexPath];
 
        
        [_engine setVideoPreview:cell.videoPreview];
        
        [_tableView reloadData];
    }
}

#pragma mark - <SettingButtonCellDelegate>

- (void)clickButtonAtTag:(NSInteger)tag {

}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headerTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SettingsTextCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingTextCell forIndexPath:indexPath];
        cell.sTextLabel.text = @"登录信息";
        cell.sDetailLabel.text = [NSString stringWithFormat:@"%@:%@", [FspManager instance].myGroupId, [FspManager instance].myUserId];
        
        return cell;
    }
    
    if (indexPath.section == 1 )  {
        SettingsStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingStateCell forIndexPath:indexPath];
        cell.sTextLabel.text = @"状态";
        
        return cell;
    }
    
    if (indexPath.section == 2) {
        SettingsStateCell *cell = [tableView dequeueReusableCellWithIdentifier:kSettingStateCell forIndexPath:indexPath];
        cell.sTextLabel.text = @"状态";
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <UITableViewDelegate>

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _headerTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 208;
    }
    
    return 42;
}

@end
