//
//  SettingGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingGuideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_titleArray;
    UITableView    *_tableView;
}

@end
