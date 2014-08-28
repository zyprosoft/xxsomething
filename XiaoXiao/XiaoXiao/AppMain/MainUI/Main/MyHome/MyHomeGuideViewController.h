//
//  MyHomeGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFansUserListViewController.h"
#import "MyCareUserListViewController.h"
#import "MyPeepUserListViewController.h"
#import "MyProfileEditViewController.h"
#import "MyShareListViewController.h"
#import "MyHomeUserHeadView.h"
#import "XXBaseViewController.h"

@interface MyHomeGuideViewController : XXBaseViewController<UITableViewDataSource,UITableViewDelegate,MyHomeUserHeadViewDelegate>
{
    UITableView *guideTable;
    
    NSMutableArray *guideVCArray;
    
}

@end
