//
//  MainTabViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MainTabViewController.h"
#import "InSchoolSearchUserListViewController.h"
#import "SettingMyProfileGuideViewController.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //custom tab bar
    [self initCustomTabBar];
    
    [self updateMsgAction];
    
    //init view controllers
    NSMutableArray *subVCArray = [NSMutableArray array];
    UIImage *navigationImage = nil;
    if (IS_IOS_7) {
        navigationImage = [[UIImage imageNamed:@"nav_bar_ios7.png"]makeStretchForNavigationBar];
    }else{
        navigationImage = [[UIImage imageNamed:@"nav_bar.png"]makeStretchForNavigationBar];
    }
    
    InSchoolSearchUserListViewController *squareGuideVC = [[InSchoolSearchUserListViewController alloc]init];
    squareGuideVC.title = @"校偷瞄";
    UINavigationController *squareNav = [[UINavigationController alloc]initWithRootViewController:squareGuideVC];
    [squareNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
    [subVCArray addObject:squareNav];
    
    LonelyShootViewController *lonelyShootVC = [[LonelyShootViewController alloc]init];
    UINavigationController *lonelyShootNav = [[UINavigationController alloc]initWithRootViewController:lonelyShootVC];
    [lonelyShootNav setNavigationBarHidden:YES animated:NO];
    [subVCArray addObject:lonelyShootNav];
    
    MessageGuideViewController *messageGuideVC = [[MessageGuideViewController alloc]init];
    messageGuideVC.title = @"消息";
    UINavigationController *messageNav = [[UINavigationController alloc]initWithRootViewController:messageGuideVC];
    [messageNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
    [subVCArray addObject:messageNav];
    [XXCommonUitil setCommonNavigationTitle:@"消息" forViewController:messageGuideVC];

    if ([XXUserDataCenter checkLoginUserInfoIsWellDone]) {
        MyHomeGuideViewController *myHomeGuideVC = [[MyHomeGuideViewController alloc]init];
        UINavigationController *myHomeNav = [[UINavigationController alloc]initWithRootViewController:myHomeGuideVC];
        [myHomeNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
        [subVCArray addObject:myHomeNav];
    }else{
        SettingMyProfileGuideViewController *settingVC = [[SettingMyProfileGuideViewController alloc]init];
        UINavigationController *settingNav = [[UINavigationController alloc]initWithRootViewController:settingVC];
        [settingNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
        [subVCArray addObject:settingNav];
        [settingVC setFinishBlock:^(BOOL resultState) {
            if (resultState) {
                NSMutableArray *oldVCArray = [NSMutableArray arrayWithArray:self.viewControllers];
                [oldVCArray removeLastObject];
                
                UIImage *navigationImage = nil;
                if (IS_IOS_7) {
                    navigationImage = [[UIImage imageNamed:@"nav_bar_ios7.png"]makeStretchForNavigationBar];
                }else{
                    navigationImage = [[UIImage imageNamed:@"nav_bar.png"]makeStretchForNavigationBar];
                }
                MyHomeGuideViewController *myHomeGuideVC = [[MyHomeGuideViewController alloc]init];
                UINavigationController *myHomeNav = [[UINavigationController alloc]initWithRootViewController:myHomeGuideVC];
                [myHomeNav.navigationBar setBackgroundImage:navigationImage forBarMetrics:UIBarMetricsDefault];
                [oldVCArray addObject:myHomeNav];

                self.viewControllers = oldVCArray;
            }
        }];
    }

    self.viewControllers = subVCArray;
    
    
    //build xmpp
    [[ZYXMPPClient shareClient]clientDefaultConfig];
    [[ZYXMPPClient shareClient]  setJabbredServerAddress:@"112.124.37.183"];
    [[ZYXMPPClient shareClient] setJabbredServerPort:@"5222"];
    [[ZYXMPPClient shareClient]  setConnectToServerErrorAction:^(NSString *errMsg) {
        DDLogVerbose(@"connect xmpp server error :%@",errMsg);
    }];
    [[ZYXMPPClient shareClient]setStartClientFaildAction:^(NSString *faildMsg) {
        DDLogVerbose(@"start client faild:%@",faildMsg);
    }];
    [[ZYXMPPClient shareClient]setStartClientSuccessAction:^(NSString *successMsg) {
        DDLogVerbose(@"start client success:%@",successMsg);
    }];
    [[XXChatCacheCenter shareCenter]readLatestMessageListToCacheDict];//初始化存储
    [[ZYXMPPClient shareClient]startClientWithJID:[XXUserDataCenter currentLoginUser].userId withPassword:@"123456"];
    
}
- (void)setTabBarHidden:(BOOL)state
{
    customTabBar.hidden = state;
    // Custom code to hide TabBar
    if ( [self.view.subviews count] < 2 ) {
        return;
    }

    UIView *contentView;
    if ( [[self.view.subviews objectAtIndex:0] isKindOfClass:[UITabBar class]] ) {
        contentView = [self.view.subviews objectAtIndex:1];
    } else {
        contentView = [self.view.subviews objectAtIndex:0];
    }
    
    if (state) {
        contentView.frame = self.view.bounds;
    } else {
        contentView.frame = CGRectMake(self.view.bounds.origin.x,
                                       self.view.bounds.origin.y,
                                       self.view.bounds.size.width,
                                       self.view.bounds.size.height -
                                       self.tabBar.frame.size.height);
    }
    self.tabBar.hidden = state;
}
- (void)updateMsgAction
{
    //get new remind
    [[XXMainDataCenter shareCenter]requestGetRemindNewCountWithSuccess:^(XXUserModel *detailUser) {
        
        XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
        cUser.friendHasNewShareCount = detailUser.friendHasNewShareCount;
        cUser.commentNewCount = detailUser.commentNewCount;
        cUser.visitUserNewCount = detailUser.visitUserNewCount;
        cUser.teaseNewCount = detailUser.teaseNewCount;
        [XXUserDataCenter loginThisUser:cUser];
        
        DDLogVerbose(@"get remind success!!!");
        [self updateMainTabBarForNewMessage];
        [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasGetRemindCountNoti object:nil];
        
    } withFaild:^(NSString *faildMsg) {
        DDLogVerbose(@"get remind fiald:%@",faildMsg);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMainTabBarForNewMessage
{
#define XXNewMsgRemidTag 222333
#define XXNewHomeRemidTag 222334
    
    if (![customTabBar viewWithTag:XXNewMsgRemidTag]) {
        UIImage *remindImage = [UIImage imageNamed:@"home_tab_msg_remind.png"];
        
        UIImageView *newMsgRemid = [[UIImageView alloc]initWithFrame:CGRectMake(210,8,9.5,9.5)];
        newMsgRemid.image = remindImage;
        newMsgRemid.tag = XXNewMsgRemidTag;
        [customTabBar addSubview:newMsgRemid];
    }
    
    if ([[XXUserDataCenter currentLoginUser].teaseNewCount intValue]>0 || [[XXUserDataCenter currentLoginUser].commentNewCount  intValue]>0 || [[XXChatCacheCenter shareCenter]getTotalUnReadMsgCount]>0) {
         [[customTabBar viewWithTag:XXNewMsgRemidTag]setHidden:NO];
    }else{
        if ([customTabBar viewWithTag:XXNewMsgRemidTag]) {
            [[customTabBar viewWithTag:XXNewMsgRemidTag]setHidden:YES];
            
        }
    }
//    if ([[XXUserDataCenter currentLoginUser].careMeNew intValue] != 0 || [[XXUserDataCenter currentLoginUser].meCareNew intValue]!=0) {
//        hasNewHome = YES;
//    }else{
//        if ([customTabBar viewWithTag:XXNewHomeRemidTag]) {
//            [[customTabBar viewWithTag:XXNewHomeRemidTag]removeFromSuperview];
//        }
//    }
    
//    UIImageView *newHomeRemid = [[UIImageView alloc]initWithFrame:CGRectMake(185,8,9.5,9.5)];
//    newHomeRemid.tag = XXNewHomeRemidTag;
//    newHomeRemid.image = remindImage;
//    [customTabBar addSubview:newHomeRemid];
}
- (void)showMsgRemind
{
    if (![customTabBar viewWithTag:XXNewMsgRemidTag]) {
        UIImage *remindImage = [UIImage imageNamed:@"home_tab_msg_remind.png"];
        
        UIImageView *newMsgRemid = [[UIImageView alloc]initWithFrame:CGRectMake(205,8,9.5,9.5)];
        newMsgRemid.image = remindImage;
        newMsgRemid.tag = XXNewMsgRemidTag;
        [customTabBar addSubview:newMsgRemid];
    }else{
         [[customTabBar viewWithTag:XXNewMsgRemidTag]setHidden:NO];
    }
}

#pragma mark - 初始化TabBar
- (void)initCustomTabBar
{
    self.tabBar.hidden = YES;
    NSMutableArray *tabBarConfigArray = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        
        NSString *iconNormal = [NSString stringWithFormat:@"home_tab_%d",i];
        NSString *iconSelected = [NSString stringWithFormat:@"home_tab_%d_selected",i];
        NSString *title = @"";
        
        NSDictionary *itemDict = @{XXBarItemNormalIconKey:iconNormal,XXBarItemSelectIconKey:iconSelected,XXBarItemTitleKey:title,XXBarItemTitleNormalColorKey:@"",XXBarItemTitleSelectColorKey:@""};
        [tabBarConfigArray addObject:itemDict];
    }
    
    customTabBar = [[XXCustomTabBar alloc]initWithFrame:self.tabBar.frame withConfigArray:tabBarConfigArray];
    [self.view addSubview:customTabBar];
    //set select action
    __weak typeof(self) weakSelf = self;
    [customTabBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
        weakSelf.selectedIndex = index;
        if (index==2) {
            [weakSelf updateMsgAction];
        }
        [weakSelf performSelector:@selector(updateMainTabBarForNewMessage) withObject:nil afterDelay:4];
    }];
}
- (void)shouldSelectAtIndex:(NSInteger)index
{
    self.selectedIndex = index;
    [customTabBar setSelectAtIndex:index];
}

- (void)userHasFinishUpdateInfo
{
    
}

@end
