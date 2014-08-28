//
//  XiaoXiaoAppDelegate.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XiaoXiaoAppDelegate.h"
#import "UITestViewController.h"
#import "MainTabViewController.h"
#import "TestViewController.h"
#import "GuideViewController.h"

@implementation XiaoXiaoAppDelegate

#pragma mark DDLogConfig
- (void)configDDLogSettings
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void)loginOut
{
    //stop xmpp
    [[ZYXMPPClient shareClient]loginOutCurrentClient];
    [XXUserDataCenter currentUserLoginOut];//loginOut
    [[XXChatCacheCenter shareCenter]clearLastUserDataNow];
    self.mainTabController = nil;
    GuideViewController *guideVC = [[GuideViewController alloc]init];
    self.loginGuideNavController = [[UINavigationController alloc]initWithRootViewController:guideVC];
    [self.loginGuideNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [guideVC setLoginGuideFinish:^(BOOL loginResult) {
        if (loginResult) {
            //MainUI
            self.mainTabController = [[MainTabViewController alloc]init];
            self.window.rootViewController = self.mainTabController;
            self.mainTabController.view.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.mainTabController.view.alpha = 1;
            }];
            [self.loginGuideNavController.view removeFromSuperview];
            self.loginGuideNavController = nil;
            
            //build xmpp ,relogin
            [[ZYXMPPClient shareClient]startClientWithJID:[XXUserDataCenter currentLoginUser].userId withPassword:@"123456"];
        }
    }];
    self.window.rootViewController = self.loginGuideNavController;
    self.loginGuideNavController.view.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.loginGuideNavController.view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
-  (void)loginNow
{
    self.mainTabController = [[MainTabViewController alloc]init];
    self.window.rootViewController = self.mainTabController;
    self.mainTabController.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.mainTabController.view.alpha = 1;
    }];
    [self.loginGuideNavController.view removeFromSuperview];
    self.loginGuideNavController = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
        
    //config DDLog
    [self configDDLogSettings];
    
    //testUI
//    UITestViewController *testVC = [[UITestViewController alloc]init];
//    self.window.rootViewController = testVC;
//    TestViewController *testVC = [[TestViewController alloc]init];
//    UINavigationController *testNav = [[UINavigationController alloc]initWithRootViewController:testVC];
//    self.window.rootViewController = testNav;
    
    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    if (cUser) {
        self.guideImageView = [[UIImageView alloc]initWithFrame:self.window.bounds];
        NSString *guideImageName = IS_PHONE_5? @"Default-568h.png":@"Default.png";
        self.guideImageView.image = [UIImage imageNamed:guideImageName];
        [self.window addSubview:self.guideImageView];

        [[XXMainDataCenter shareCenter]requestLoginWithNewUser:cUser withSuccessLogin:^(XXUserModel *detailUser) {
            //MainUI
            self.mainTabController = [[MainTabViewController alloc]init];
            self.window.rootViewController = self.mainTabController;
            self.mainTabController.view.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                self.mainTabController.view.alpha = 1;
            }];
            [self.guideImageView removeFromSuperview];
            
        } withFaildLogin:^(NSString *faildMsg) {
            //login Guide
            GuideViewController *guideVC = [[GuideViewController alloc]init];
            self.loginGuideNavController = [[UINavigationController alloc]initWithRootViewController:guideVC];
            [self.loginGuideNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
            [guideVC setLoginGuideFinish:^(BOOL loginResult) {
                
                if (loginResult) {
                    [self.loginGuideNavController.view removeFromSuperview];
                    self.loginGuideNavController = nil;
                    
                    //MainUI
                    self.mainTabController = [[MainTabViewController alloc]init];
                    self.window.rootViewController = self.mainTabController;
                    self.mainTabController.view.alpha = 0;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.mainTabController.view.alpha = 1;
                    }];
                    
                }
            }];
            self.window.rootViewController = self.loginGuideNavController;
            [self.guideImageView removeFromSuperview];
        }];
        
    }else{
        //login Guide
        GuideViewController *guideVC = [[GuideViewController alloc]init];
        self.loginGuideNavController = [[UINavigationController alloc]initWithRootViewController:guideVC];
        [self.loginGuideNavController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
        [guideVC setLoginGuideFinish:^(BOOL loginResult) {
            
            if (loginResult) {
                [self.loginGuideNavController.view removeFromSuperview];
                self.loginGuideNavController = nil;
                
                //MainUI
                self.mainTabController = [[MainTabViewController alloc]init];
                self.window.rootViewController = self.mainTabController;
                self.mainTabController.view.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    self.mainTabController.view.alpha = 1;
                }];
                
            }
        }];
        self.window.rootViewController = self.loginGuideNavController;
    }
    
    //root
    self.appHUD = [[MBProgressHUD alloc]initWithWindow:self.window];
    [self.window addSubview:self.appHUD];
    [self.appHUD hide:YES];
    
    [self.window makeKeyAndVisible];
    
    //后台更新学校数据库
    [[XXCacheCenter shareCenter]updateSchoolDataBaseNow];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //同步一次经纬度
    if (!self.locationManager) {
        self.locationManager = [[BFLocationManager alloc]init];
    }
    [self.locationManager startGetLocationInfoWithDelegate:self withUpdateBlock:^(long lat, long lng) {
        XXConditionModel *condition = [[XXConditionModel alloc]init];
        condition.longtitude = lng;
        condition.latitude = lat;
        [[XXMainDataCenter shareCenter]requestSyncLocationWithCondition:condition withSuccess:^(NSArray *resultList) {
            DDLogVerbose(@"sync location while resign succes!");
        } withFaild:^(NSString *faildMsg) {
            DDLogVerbose(@"sync location while resign faild");
        }];
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //同步一次经纬度
    if (!self.locationManager) {
        self.locationManager = [[BFLocationManager alloc]init];
    }
    [self.locationManager startGetLocationInfoWithDelegate:self withUpdateBlock:^(long lat, long lng) {
        XXConditionModel *condition = [[XXConditionModel alloc]init];
        condition.longtitude = lng;
        condition.latitude = lat;
        [[XXMainDataCenter shareCenter]requestSyncLocationWithCondition:condition withSuccess:^(NSArray *resultList) {
            DDLogVerbose(@"sync location while resign succes!");
        } withFaild:^(NSString *faildMsg) {
            DDLogVerbose(@"sync location while resign faild");
        }];
    }];
    
    //刷新消息
    if ([XXCommonUitil appMainTabController]) {
        [[XXCommonUitil appMainTabController]updateMsgAction];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
