//
//  TeaseMeListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTeaseBaseCell.h"

@interface TeaseMeListViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,XXTeaseBaseCellDelegate,UIAlertViewDelegate>
{
    UITableView *_teaseListTable;
    UIRefreshControl *_refreshControl;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    BOOL        _isRefresh;
    
    NSMutableArray *_teasesArray;
    NSIndexPath *_tapPath;
}
@property (nonatomic,weak)UINavigationController *superNav;

- (void)refresh;

@end
