//
//  LoginViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //
    CGFloat totalWidth = self.view.frame.size.width;
    CGFloat totalHeight = self.view.frame.size.height-44;

    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    _FormView = [[XXFormView alloc]initWithFrame:CGRectMake(10,30,totalWidth-10*2,115)];
    if (cUser) {
        _FormView.accountTextField.text = cUser.account;
        _FormView.passwordTextField.text = cUser.password;
    }
    [self.view addSubview:_FormView];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(10,155,totalWidth-10*2,45);
    [loginButton setTitle:@"马上登陆" forState:UIControlStateNormal];
    UIImage *normal = [[UIImage imageNamed:@"login_normal.png"]t:6 l:6 b:6 r:6];
    UIImage *selected = [[UIImage imageNamed:@"login_selected.png"]t:6 l:6 b:6 r:6];
    [loginButton setBackgroundImage:normal forState:UIControlStateNormal];
    [loginButton setBackgroundImage:selected forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginNowAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginNowAction
{
    [_FormView.passwordTextField resignFirstResponder];
    [_FormView.accountTextField resignFirstResponder];
    
    XXUserModel *newUser = [[XXUserModel alloc]init];
    newUser.account = _FormView.accountTextField.text;
    newUser.password = _FormView.passwordTextField.text;
    
    
    _hud.labelText = @"正在登陆";
    [_hud show:YES];
    [self.view bringSubviewToFront:_hud];
    [[XXMainDataCenter shareCenter]requestLoginWithNewUser:newUser withSuccessLogin:^(XXUserModel *detailUser) {
        [_hud hide:YES];
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        if (_resultBlock) {
            _resultBlock(YES);
        }
    } withFaildLogin:^(NSString *faildMsg) {
        [_hud hide:YES];
        [SVProgressHUD showErrorWithStatus:faildMsg];
        if (_resultBlock) {
            _resultBlock(NO);
        }
    }];
}

- (void)setLoginResultBlock:(LoginViewControllerResultBlock)resultBlock
{
    _resultBlock = resultBlock;
}

@end
