//
//  OtherUserShareListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserShareListViewController.h"

@interface OtherUserShareListViewController ()

@end

@implementation OtherUserShareListViewController

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
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    [_refreshControl beginRefreshing];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestShareListNow
{
    XXConditionModel *condtion = [[XXConditionModel alloc]init];
    condtion.pageIndex = [NSString stringWithFormat:@"%d",_currentPageIndex];
    condtion.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    condtion.userId = self.otherUserId;
    
    [[XXMainDataCenter shareCenter]requestSharePostListWithCondition:condtion withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
        }
        if (_isRefresh) {
            [self.sharePostModelArray removeAllObjects];
            [self.sharePostRowHeightArray removeAllObjects];
            _isRefresh = NO;
        }
        [resultList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            XXSharePostModel *postModel = (XXSharePostModel*)obj;
            CGFloat heightForModel = [XXShareBaseCell heightWithSharePostModel:postModel forContentWidth:[XXSharePostStyle sharePostContentWidth]];
            [self.sharePostRowHeightArray addObject:[NSNumber numberWithFloat:heightForModel]];
            
        }];
        [self.sharePostModelArray addObjectsFromArray:resultList];
        [_refreshControl endRefreshing];
        [_shareListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _isRefresh = YES;
    _hiddenLoadMore = NO;
    [self requestShareListNow];
}
- (void)loadMoreResult
{
    _currentPageIndex ++;
    [self requestShareListNow];
}

@end
