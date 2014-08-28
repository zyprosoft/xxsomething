//
//  LonelyShootResultListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LonelyShootResultListViewController.h"

@interface LonelyShootResultListViewController ()

@end

@implementation LonelyShootResultListViewController

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
    self.title = @"射中的人";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    [_userListTable reloadData];
    
    [_refreshControl removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - overload
- (void)refresh
{
    _hiddenLoadMore = NO;
    _isRefresh = YES;
    _currentPageIndex = 0;
    [_refreshControl beginRefreshing];
    [self requestUserList];
}
- (void)requestUserList
{
    //校内人搜索
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.schoolId = [XXUserDataCenter currentLoginUser].schoolId;
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    [[XXMainDataCenter shareCenter]requestLonelyShootWithSuccess:^(NSArray *resultList) {
       
        if (resultList.count==0&&_userListArray.count==0) {
            
            if (self.delegate) {
                [self.delegate shootFinishWithResult:NO];
            }
        }else{
            if (resultList.count==0 && _userListArray.count !=0) {
                
            }else{
                if (self.delegate) {
                    [self.delegate shootFinishWithResult:YES];
                }
            }
        }
        
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
        if (_userListArray.count==0) {
            if (self.delegate ) {
                [self.delegate shootFinishWithResult:NO];
            }
        }
    }];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestUserList];
}


@end
