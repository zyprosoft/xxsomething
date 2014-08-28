//
//  LonelyShootViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LonelyShootViewController.h"
#import "SettingMyProfileGuideViewController.h"

@interface LonelyShootViewController ()

@end

@implementation LonelyShootViewController

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
    self.view.backgroundColor = rgb(30,42,49,1);
    
    CGFloat totalWidth = self.view.frame.size.width;
    
    CGFloat totalHeight = XXNavContentHeight-49;
    
    CGFloat originY = (totalHeight-356)/2;
    _arrowView = [[ArrowView alloc]initWithFrame:CGRectMake(0,originY,totalWidth,356)];
    _arrowView.delegate = self;
    [self.view addSubview:_arrowView];
    
 
    resultVC = [[LonelyShootResultListViewController alloc]init];
    resultVC.delegate = self;

    _indcatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indcatorView.frame = CGRectMake(140,(totalHeight-40)/2,40,40);
    [self.view addSubview:_indcatorView];
    _indcatorView.hidden = YES;
    
    _loadingLabel = [[UILabel alloc]init];
    _loadingLabel.frame = CGRectMake(50,_indcatorView.frame.origin.y+_indcatorView.frame.size.height+10,220,40);
    _loadingLabel.text = @"正在查找和你一起射的人...";
    _loadingLabel.font = [UIFont boldSystemFontOfSize:17.5];
    _loadingLabel.textColor = [UIColor whiteColor];
    _loadingLabel.backgroundColor = [UIColor clearColor];
    _loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_loadingLabel];
    _loadingLabel.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - arrow Delegate
- (void)arrowMoveFinished:(ArrowView *)arrowView
{
    if (![XXUserDataCenter checkLoginUserInfoIsWellDone]) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您需要完善资料才可使用射孤独" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        [self showLoading];
        [self performSelector:@selector(delayFindResultAction) withObject:nil afterDelay:2];
  
    }
}
#pragma mark  - alert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[XXCommonUitil appMainTabController] shouldSelectAtIndex:3];
    }
}

- (void)showLoading
{
    _loadingLabel.hidden = NO;
    _indcatorView.hidden = NO;
    [_indcatorView startAnimating];
}
- (void)hideLoading
{
    [_indcatorView stopAnimating];
    _loadingLabel.hidden = YES;
    _indcatorView.hidden = YES;
}
#pragma mark - shoot result 
-(void)delayFindResultAction
{
    [resultVC refresh];
}
- (void)shootFinishWithResult:(BOOL)result
{
    
    if (result) {
        [XXSimpleAudio playShootFindEffect];
        [self hideLoading];
        [self.navigationController pushViewController:resultVC animated:YES];
        
    }else{
        [XXSimpleAudio playShootNoneEffect];
        [self hideLoading];
        [SVProgressHUD showErrorWithStatus:@"没有人和你同时射!"];
        
    }
    
}

@end
