//
//  NearByUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "NearByUserListViewController.h"
#import "NearByUserNormalFilterViewController.h"

@interface NearByUserListViewController ()

@end

@implementation NearByUserListViewController

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
    
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"nav_share_post_setting.png" withNextStepAction:^{
        NearByUserNormalFilterViewController *filterVC = [[NearByUserNormalFilterViewController alloc]init];
        filterVC.title = @"按条件筛选";
        [self.navigationController pushViewController:filterVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC];
        
    }];

    
    _pageSize = 30;
    _currentPageIndex = 0;
    _locationManager = [[BFLocationManager alloc]init];
    
    [SVProgressHUD showWithStatus:@"正在获取位置..."];
    [_locationManager startGetLocationInfoWithDelegate:self withUpdateBlock:^(long lat, long lng) {
        if (lat==0&&lng==0) {
            [SVProgressHUD showErrorWithStatus:@"获取位置失败"];
        }else{
            [SVProgressHUD showSuccessWithStatus:@"定位成功"];
            _latitude = lat;
            _longtitude = lng;
            [self refresh];
        }
        
    }];
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
    [self requestUserList];
}
- (void)requestUserList
{
    //校内人搜索
    XXUserModel *condition = [[XXUserModel alloc]init];
    condition.latitude = StringLong(_latitude);
    condition.longtitude = StringLong(_longtitude);

    [[XXMainDataCenter shareCenter]requestNearbyUserWithConditionUser:condition withSuccess:^(NSArray *resultList) {
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
    }];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestUserList];
}

@end
