//
//  MainTabViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXCustomTabBar.h"
#import "SquareGuideViewController.h"
#import "MessageGuideViewController.h"
#import "MyHomeGuideViewController.h"
#import "LonelyShootViewController.h"

@interface MainTabViewController : UITabBarController
{
    XXCustomTabBar *customTabBar;
}

- (void)setTabBarHidden:(BOOL)state;

- (void)updateMsgAction;

- (void)updateMainTabBarForNewMessage;
- (void)showMsgRemind;

- (void)shouldSelectAtIndex:(NSInteger)index;

- (void)userHasFinishUpdateInfo;

@end
