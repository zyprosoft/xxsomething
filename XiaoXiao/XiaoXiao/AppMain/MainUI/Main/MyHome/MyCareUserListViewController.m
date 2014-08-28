//
//  MyCareUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyCareUserListViewController.h"

@interface MyCareUserListViewController ()

@end

@implementation MyCareUserListViewController

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
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

#pragma mark - overload
- (void)refresh
{
    [_refreshControl beginRefreshing];
    _hiddenLoadMore = NO;
    _isRefresh = YES;
    _currentPageIndex = 0;
    [self requestUserList];
}
- (void)requestUserList
{
    //
    
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    
    [[XXMainDataCenter shareCenter] requestMyCareFriendWithConditionFriend:condition withSuccess:^(NSArray *resultList) {
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        if (_isRefresh) {
            [_userListArray removeAllObjects];
            _isRefresh = NO;
            [_refreshControl endRefreshing];
        }
        [_userListArray addObjectsFromArray:resultList];
        [_userListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
        _isRefresh = NO;
        [_refreshControl endRefreshing];
    }];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestUserList];
}


@end
