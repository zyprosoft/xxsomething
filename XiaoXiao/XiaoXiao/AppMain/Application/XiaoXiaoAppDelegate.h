//
//  XiaoXiaoAppDelegate.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainTabViewController.h"
#import "BFLocationManager.h"

@interface XiaoXiaoAppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MBProgressHUD *appHUD;
@property (strong, nonatomic) UINavigationController *loginGuideNavController;
@property (strong, nonatomic) MainTabViewController *mainTabController;
@property (strong, nonatomic) UIImageView *guideImageView;
@property (strong, nonatomic) BFLocationManager *locationManager;


- (void)loginOut;
- (void)loginNow;

@end
