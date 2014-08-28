//
//  XXShareListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"

/*
 *通用分享列表
 */

@interface XXShareListViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_shareListTable;
    UIRefreshControl *_refreshControl;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    BOOL        _isRefresh;

}
@property (nonatomic,strong)NSMutableArray *sharePostModelArray;
@property (nonatomic,strong)NSMutableArray *sharePostRowHeightArray;

- (void)requestShareListNow;
- (void)refresh;
- (void)loadMoreResult;

@end
