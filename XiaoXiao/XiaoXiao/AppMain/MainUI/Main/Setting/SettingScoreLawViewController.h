//
//  SettingScoreLawViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-26.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBaseViewController.h"

@interface SettingScoreLawViewController : XXBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_titleArray;
    
}

@end
