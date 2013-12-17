//
//  MainTabViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MainTabViewController.h"

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化TabBar
- (void)initCustomTabBar
{
    NSMutableArray *tabBarConfigArray = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        
        NSString *iconNormal = @"normal";
        NSString *iconSelected = @"selected";
        NSString *title = @"test";
        
        NSDictionary *itemDict = @{XXBarItemNormalIconKey:iconNormal,XXBarItemSelectIconKey:iconSelected,XXBarItemTitleKey:title};
        [tabBarConfigArray addObject:itemDict];
    }
    
    customTabBar = [[XXCustomTabBar alloc]initWithFrame:self.tabBar.frame withConfigArray:tabBarConfigArray];
    [self.tabBar addSubview:customTabBar];
    //set select action
    
    WeakObj(self);
    [customTabBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
        
    }];
}

@end
