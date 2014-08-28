//
//  MessageGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MessageGuideViewController.h"
#import "AudioMessageListViewController.h"
#import "TeaseMeListViewController.h"
#import "ReplyMessageListViewController.h"

@interface MessageGuideViewController ()

@end

@implementation MessageGuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    CGFloat totalWidth = self.view.frame.size.width;

    NSMutableArray *tabBarConfig = [NSMutableArray array];
    NSDictionary *audioMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"对话",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:audioMsgItem];
    
    NSDictionary *replyMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"评论我的",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:replyMsgItem];
    
    NSDictionary *teaseMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"挑逗我的",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:teaseMsgItem];
    
    _menuBar = [[MessageGuideTabBar alloc]initWithFrame:CGRectMake(0,0,totalWidth,44) withConfigArray:tabBarConfig];
    _menuBar.layer.borderWidth = 1.0f;
    _menuBar.layer.borderColor = [XXCommonStyle xxThemeGrayTitleColor].CGColor;
    [self.view addSubview:_menuBar];
    
    //tagLine
    _selectTagView = [[UIImageView alloc]init];
    _selectTagView.backgroundColor = rgb(0,197,181,1);
    _selectTagView.frame = CGRectMake(0,42,self.view.frame.size.width/3,2);
    [self.view addSubview:_selectTagView];
    
    //view controllers
    _viewControllers = [[NSMutableArray alloc]init];
    AudioMessageListViewController *audioListVC = [[AudioMessageListViewController alloc]init];
    audioListVC.superNav = self.navigationController;
    [_viewControllers addObject:audioListVC];

    ReplyMessageListViewController *replyList = [[ReplyMessageListViewController alloc]init];
    replyList.superNav = self.navigationController;
    [_viewControllers addObject:replyList];
    //默认
    audioListVC.view.frame = CGRectMake(0,44,totalWidth,totalHeight);
    [self.view addSubview:audioListVC.view];
    
    TeaseMeListViewController *teaseMeList = [[TeaseMeListViewController alloc]init];
    teaseMeList.superNav = self.navigationController;
    [_viewControllers addObject:teaseMeList];
    
    WeakObj(_viewControllers) weakViewControllers = _viewControllers;
    WeakObj(self) weakSelf = self;
    WeakObj(_selectTagView) weakTagView = _selectTagView;
    [_menuBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
       
        UIViewController *selectVC = [weakViewControllers objectAtIndex:index];
        if ([selectVC isKindOfClass:[XXMessageListViewController class]]) {
            XXMessageListViewController *selectListVC = (XXMessageListViewController*)selectVC;
            [selectListVC refresh];
            
            if ([selectListVC isKindOfClass:[ReplyMessageListViewController class]]) {
                //tell you i has know
                XXConditionModel *condition = [[XXConditionModel alloc]init];
                condition.type = @"comment";
                [[XXMainDataCenter shareCenter]requestIKnowNewRemindWithCondition:condition WithSuccess:^(NSString *successMsg) {
                    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
                    cUser.commentNewCount = @"0";
                    [XXUserDataCenter loginThisUser:cUser];
                    [weakSelf updateBadgeViewState];
                } withFaild:^(NSString *faildMsg) {
                    
                }];
                
            }
        }
        if ([selectVC isKindOfClass:[TeaseMeListViewController class]]) {
            TeaseMeListViewController *teaseMeVC = (TeaseMeListViewController*)selectVC;
            [teaseMeVC refresh];
            //tell you i has know
            XXConditionModel *condition = [[XXConditionModel alloc]init];
            condition.type = @"tease";
            [[XXMainDataCenter shareCenter]requestIKnowNewRemindWithCondition:condition WithSuccess:^(NSString *successMsg) {
                XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
                cUser.teaseNewCount = @"0";
                [XXUserDataCenter loginThisUser:cUser];
                [weakSelf updateBadgeViewState];
            } withFaild:^(NSString *faildMsg) {
                
            }];
        }
        if ([weakSelf.view.subviews containsObject:selectVC.view]) {
            
            [weakSelf.view bringSubviewToFront:selectVC.view];
        }else{
            
            selectVC.view.frame = CGRectMake(0,44,totalWidth,totalHeight);
            [weakSelf.view addSubview:selectVC.view];
        }
        weakTagView.frame = CGRectMake(index*(weakSelf.view.frame.size.width/3),42,weakSelf.view.frame.size.width/3,2);
        
    }];
    
    //seprator
    UIImageView *middleSepLine = [[UIImageView alloc]init];
    middleSepLine.frame = CGRectMake(self.view.frame.size.width/3-1,0,1,44);
    middleSepLine.backgroundColor = [XXCommonStyle xxThemeGrayTitleColor];
    [self.view addSubview:middleSepLine];
    
    //seprator
    UIImageView *middleSepLine1 = [[UIImageView alloc]init];
    middleSepLine1.frame = CGRectMake(self.view.frame.size.width*2/3-1,0,1,44);
    middleSepLine1.backgroundColor = [XXCommonStyle xxThemeGrayTitleColor];
    [self.view addSubview:middleSepLine1];
    
    //observe noti
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBadgeViewState) name:XXUserHasGetRemindCountNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateBadgeViewState) name:XXUserHasRecievedNewMsgNoti object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBadgeViewState];
}
- (void)updateBadgeViewState
{
    NSString *commentNewCount = [XXUserDataCenter currentLoginUser].commentNewCount;
    NSString *teaseNewCount = [XXUserDataCenter currentLoginUser].teaseNewCount;
    
    DDLogVerbose(@"update badge state +++++!  commentCount:%@",commentNewCount);
    if ([commentNewCount intValue]>0) {
        if (!_commentBadgeView) {
            CGSize titleSize = [commentNewCount sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103,15)];
            _commentBadgeView = [[XXBadgeView alloc]initWithFrame:CGRectMake(103*2-titleSize.width-8,0,titleSize.width+8,15)];
            _commentBadgeView.titleLabel.text = commentNewCount;
            [_menuBar addSubview:_commentBadgeView];
        }
    }else{
        if (_commentBadgeView) {
            [_commentBadgeView removeFromSuperview];
        }
    }
    if ([teaseNewCount intValue]>0) {
        if (!_teaseMeBageView) {
            CGSize titleSize = [teaseNewCount sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103,15)];
            _teaseMeBageView = [[XXBadgeView alloc]initWithFrame:CGRectMake(103*3-titleSize.width-8,0,titleSize.width+8,15)];
            _teaseMeBageView.titleLabel.text = teaseNewCount;
            [_menuBar addSubview:_teaseMeBageView];
        }
    }else{
        if (_teaseMeBageView) {
            [_teaseMeBageView removeFromSuperview];
        }
    }
    
    DDLogVerbose(@"msgCount ++ :%d",[[XXChatCacheCenter shareCenter]getTotalUnReadMsgCount]);

    if ([[XXChatCacheCenter shareCenter]getTotalUnReadMsgCount]>0) {
        if (!_msgBadgeView) {
            
            NSString *msgCount = [NSString stringWithFormat:@"%d",[[XXChatCacheCenter shareCenter]getTotalUnReadMsgCount]];
            DDLogVerbose(@"msgCount :%@",msgCount);
            CGSize titleSize = [msgCount sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103,15)];
            _msgBadgeView = [[XXBadgeView alloc]initWithFrame:CGRectMake(103-titleSize.width-8,0,titleSize.width+8,15)];
            _msgBadgeView.titleLabel.text = msgCount;
            [_menuBar addSubview:_msgBadgeView];
            
        }else{
            NSString *msgCount = [NSString stringWithFormat:@"%d",[[XXChatCacheCenter shareCenter]getTotalUnReadMsgCount]];
            DDLogVerbose(@"msgCount :%@",msgCount);
            CGSize titleSize = [msgCount sizeWithFont:[UIFont systemFontOfSize:10] constrainedToSize:CGSizeMake(103,15)];
            _msgBadgeView.frame = CGRectMake(103-titleSize.width-8,0,titleSize.width+8,15);
            _msgBadgeView.titleLabel.text = msgCount;
            [_menuBar bringSubviewToFront:_msgBadgeView];
            _msgBadgeView.hidden = NO;
        }
        
    }else{
        if (_msgBadgeView) {
            _msgBadgeView.hidden = YES;
        }
    }
    
}

@end
