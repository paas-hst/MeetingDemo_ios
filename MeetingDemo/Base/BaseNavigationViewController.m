//
//  BaseNavigationViewController.m
//  FspClient
//
//  Created by Rachel on 2018/4/20.
//  Copyright © 2018年 hst. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    [self setNavigationBarHidden:NO animated:YES];
}

@end
