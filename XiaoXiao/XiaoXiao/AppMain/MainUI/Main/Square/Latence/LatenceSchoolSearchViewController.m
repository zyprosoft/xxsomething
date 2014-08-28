//
//  LatenceSchoolSearchViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LatenceSchoolSearchViewController.h"

@interface LatenceSchoolSearchViewController ()

@end

@implementation LatenceSchoolSearchViewController

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
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        
        
        
    } withTitle:@"潜伏"];
    
    [self setNextStepAction:^(NSDictionary *resultDict) {
        
    }];
    [self setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
