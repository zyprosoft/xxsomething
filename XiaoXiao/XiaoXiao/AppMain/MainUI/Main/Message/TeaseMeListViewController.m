//
//  TeaseMeListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "TeaseMeListViewController.h"
#import "XXTeaseBaseCell.h"
#import "OtherUserHomeViewController.h"

@interface TeaseMeListViewController ()

@end

@implementation TeaseMeListViewController

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
    _teasesArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44-49-40;
    _teaseListTable = [[UITableView alloc]init];
    _teaseListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight);
    _teaseListTable.delegate = self;
    _teaseListTable.dataSource = self;
    _teaseListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _teaseListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_teaseListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_teaseListTable addSubview:_refreshControl];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _teasesArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXTeaseBaseCell *cell = (XXTeaseBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXTeaseBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    [cell setContentModel:[_teasesArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225+11;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width,44)];
    header.backgroundColor = [UIColor clearColor];
    
    return header;
}

#pragma mark - override api
- (void)requestTeaseMeListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.userId = [XXUserDataCenter currentLoginUser].userId;
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    
    [[XXMainDataCenter shareCenter]requestTeaseMeListWithCondition:condition withSuccess:^(NSArray *resultList) {
       
        [XXUserDataCenter currentLoginUser].teaseNewCount = @"0";
        
        if (_isRefresh) {
            [XXSimpleAudio playRefreshEffect];
            [_teasesArray removeAllObjects];
            _isRefresh = NO;
            [_refreshControl endRefreshing];
        }
        [_teasesArray addObjectsFromArray:resultList];
        [_teaseListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        
        [SVProgressHUD showErrorWithStatus:faildMsg];
        [_teaseListTable reloadData];
        if (_isRefresh) {
            _isRefresh = NO;
            [_refreshControl endRefreshing];
        }
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _hiddenLoadMore = NO;
    _isRefresh = YES;
    [_refreshControl beginRefreshing];
    [self requestTeaseMeListNow];
}
- (void)loadMoreResult
{
    
}

#pragma mark - tease me cell delegate
- (void)teaseCellDidTapOnDelegate:(XXTeaseBaseCell *)teaseCell
{
    _tapPath = [_teaseListTable indexPathForCell:teaseCell];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定删除此挑逗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)teaseCellDidTapOnHeadView:(XXTeaseBaseCell *)teaseCell
{
    NSIndexPath *tapHeadPath = [_teaseListTable indexPathForCell:teaseCell];
    XXTeaseModel *teaseModel = [_teasesArray objectAtIndex:tapHeadPath.row];
    OtherUserHomeViewController *otherHomeVC = [[OtherUserHomeViewController alloc]initWithContentUser:teaseModel.sendFromUser];
    [self.superNav pushViewController:otherHomeVC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (_tapPath) {
            
            XXTeaseModel *teaseModel = [_teasesArray objectAtIndex:_tapPath.row];
            
            [[XXMainDataCenter shareCenter]requestDeleteTeaseWithTeaseModel:teaseModel withSuccess:^(NSString *successMsg) {
                [SVProgressHUD showSuccessWithStatus:successMsg];
                [_teasesArray removeObjectAtIndex:_tapPath.row];
                [_teaseListTable deleteRowsAtIndexPaths:@[_tapPath] withRowAnimation:UITableViewRowAnimationTop];
                
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
        }
    }
}


@end
