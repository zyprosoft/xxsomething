//
//  SettingMyProfileGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SettingMyProfileGuideViewControllerFinishBlock) (BOOL resultState);

@interface SettingMyProfileGuideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView    *_tableView;
    NSMutableArray *_titleArray;
    XXUserModel    *_updateModel;
    
    SettingMyProfileGuideViewControllerFinishBlock _finishBlock;
}
- (void)setFinishBlock:(SettingMyProfileGuideViewControllerFinishBlock)finishBlock;

@end
