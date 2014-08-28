//
//  OtherUserSendTeaseViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserSendTeaseViewController.h"

@interface OtherUserSendTeaseViewController ()

@end

@implementation OtherUserSendTeaseViewController

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
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _teaseImageView = [[UIImageView alloc]init];
    _teaseImageView.frame = CGRectMake(110,70,100,100);
    NSString *teaseGif = [_teaseEmoji stringByAppendingString:@".gif"];
    _teaseImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:teaseGif]];
    [self.view addSubview:_teaseImageView];
    
    //
    //tease button
    _teaseButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _teaseButton.frame = CGRectMake(62,190,196, 46);
    [_teaseButton teaseStyle];
    [_teaseButton setNormalIconImage:@"other_tease.png" withSelectedImage:@"other_tease.png" withFrame:CGRectMake(63,14,22.5,18)];
    _teaseButton.titleEdgeInsets = UIEdgeInsetsMake(0,30,0,0);
    [_teaseButton setTitle:@"挑逗" withFrame:CGRectMake(55,5,100,30)];
    _teaseButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.5];
    _teaseButton.layer.cornerRadius = 23.f;
    [_teaseButton addTarget:self action:@selector(sendTeaseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_teaseButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSelecteTeaseEmoji:(NSString *)teaseName toUser:(NSString *)useId
{
    _teaseEmoji = teaseName;
    _toUserId = useId;
    
    }
- (void)sendTeaseAction
{
    _hud.labelText = @"正在发送...";
    XXTeaseModel *newTease = [[XXTeaseModel alloc]init];
    newTease.postEmoji = _teaseEmoji;
    newTease.userId = _toUserId;
    
    DDLogVerbose(@"new tease post emoji:%@",newTease.postEmoji);
    DDLogVerbose(@"new tease post userId:%@",newTease.userId);
    
    [_hud show:YES];
    [self.view bringSubviewToFront:_hud];
    [[XXMainDataCenter shareCenter]requestTeaseUserWithCondtionTease:newTease withSuccess:^(NSString *successMsg) {
        [_hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:successMsg];
        NSArray *navControllers = self.navigationController.viewControllers;
        [self.navigationController popToViewController:[navControllers objectAtIndex:navControllers.count-3] animated:YES];
    } withFaild:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
    
}

@end
