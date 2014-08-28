//
//  SettingMyXiaoXiaoGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-24.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingMyXiaoXiaoGuideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_titleArray;
    UITableView    *_tableView;
}

@end
