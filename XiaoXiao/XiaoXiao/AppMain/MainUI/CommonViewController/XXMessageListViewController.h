//
//  XXMessageListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"
#import "XXMessageBaseCell.h"

/*
 *通用消息列表
 */
@interface XXMessageListViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource,XXMessageBaseCellDelegate,UIAlertViewDelegate>
{
    UITableView *_messageListTable;
    UIRefreshControl *_refreshControl;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;
    BOOL        _isRefresh;
    
    NSMutableArray *_messagesArray;
    NSIndexPath *_tapOnCellPath;
}
@property (nonatomic,weak)UINavigationController *superNav;

- (void)requestMessageListNow;
- (void)refresh;
- (void)loadMoreResult;
- (void)deletePathAction;

@end
