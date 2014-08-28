//
//  XXBaseUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseUserListViewController.h"
#import "OtherUserHomeViewController.h"
#import "SettingMyProfileGuideViewController.h"

@interface XXBaseUserListViewController ()

@end

@implementation XXBaseUserListViewController

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
    
    //
    _userListArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 30;
    _hiddenLoadMore = NO;
    
    //
    DDLogVerbose(@"self user list height:%f",self.view.frame.size.height);
    CGFloat totalHeight = XXNavContentHeight-44-49;
    _userListTable = [[UITableView alloc]init];
    _userListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _userListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _userListTable.delegate = self;
    _userListTable.dataSource = self;

    _userListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_userListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    _refreshControl.tintColor = [XXCommonStyle xxThemeBlueColor];
    [_userListTable addSubview:_refreshControl];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userListArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXUserInfoBaseCell *cell = (XXUserInfoBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXUserInfoBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    [cell setContentModel:[_userListArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![XXUserDataCenter checkLoginUserInfoIsWellDone]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"您需要完善资料才可查看他人主页" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        OtherUserHomeViewController *otherHomeVC = [[OtherUserHomeViewController alloc]initWithContentUser:[_userListArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:otherHomeVC animated:YES];
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _userListArray.count-1 && !_hiddenLoadMore) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        tableView.tableFooterView = loadMoreView;
        loadMoreView.backgroundColor = rgb(250,250,250,1);
        [loadMoreView startLoading];
        [self performSelector:@selector(loadMoreResult) withObject:nil afterDelay:0.2];
    }else{
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        if (_userListArray.count==0) {
            loadMoreView.titleLabel.text = @"这个学校还没有人";

        }else{
            loadMoreView.titleLabel.text = @"没有更多用户";
        }
        [loadMoreView setLabelModel];
        tableView.tableFooterView = loadMoreView;
        loadMoreView.backgroundColor = rgb(250,250,250,1);
    }
    if (_userListArray.count==0) {
        XXLoadMoreView *loadMoreView = [[XXLoadMoreView alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width,44)];
        loadMoreView.titleLabel.text = @"这个学校还没有人";
        [loadMoreView setLabelModel];
        tableView.tableFooterView = loadMoreView;
        loadMoreView.backgroundColor = rgb(250,250,250,1);
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XXUserModel *userModel = [_userListArray objectAtIndex:indexPath.row];
    return [XXUserInfoBaseCell heightWithContentModel:userModel];
}

#pragma mark - cell delegate
- (void)userInfoBaseCellDidTapOnHeadView:(XXUserInfoBaseCell *)cell
{
    NSIndexPath *indexPath = [_userListTable indexPathForCell:cell];
    OtherUserHomeViewController *otherHomeVC = [[OtherUserHomeViewController alloc]initWithContentUser:[_userListArray objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:otherHomeVC animated:YES];
}

#pragma mark - alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [[XXCommonUitil appMainTabController] shouldSelectAtIndex:3];
    }
}

#pragma mark - over load method
- (void)requestUserList
{
    
}
- (void)finishRequestWithResultArray:(NSArray *)resultArray
{
    
}
- (void)loadMoreResult
{
    
}
- (void)refresh
{
    
}

@end
