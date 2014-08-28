//
//  SettingAdivceViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "SettingAdivceViewController.h"

@interface SettingAdivceViewController ()

@end

@implementation SettingAdivceViewController

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
    
    //commit
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(10,_inputTextView.frame.origin.y+_inputTextView.frame.size.height+20,self.view.frame.size.width-2*10,40);
    [commitButton blueStyle];
    [commitButton setTitle:@"提交建议" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(commitAdviceAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitButton];
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commitAdviceAction
{
    if (!_inputTextView.text || [_inputTextView.text isEqualToString:@""]) {
        return;
    }
    
    //
    XXConditionModel *newCondition = [[XXConditionModel alloc]init];
    newCondition.content = _inputTextView.text;
    
    [[XXMainDataCenter shareCenter]requestAdvicePublishWithCondition:newCondition withSuccess:^(NSString *successMsg) {
        [SVProgressHUD showSuccessWithStatus:successMsg];
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
    
}


@end
