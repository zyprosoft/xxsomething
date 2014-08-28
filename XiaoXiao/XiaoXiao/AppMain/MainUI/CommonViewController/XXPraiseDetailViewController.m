//
//  XXPraiseDetailViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXPraiseDetailViewController.h"
#import "XXPraiseCell.h"
#import "XXLoadMoreCell.h"

@interface XXPraiseDetailViewController ()

@end

@implementation XXPraiseDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithSharePostModel:(XXSharePostModel *)sharePost
{
    if(self = [super init]){
        _postId = sharePost.postId;
        _postType = @"posts";
        _praiseCount = sharePost.praiseCount;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"追捧详情";
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    self.hidesBottomBarWhenPushed = YES;
    
    self.praiseArray = [[NSMutableArray alloc]init];
    NSString *praiseTitle = [NSString stringWithFormat:@"共%@条追捧",_praiseCount];
    NSDictionary *praiseCountDict = @{@"title":praiseTitle};
    [self.praiseArray addObject:praiseCountDict];
    
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44;
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight-35);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.praiseArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *CellIdentifier = @"CellIdentifier ";
        XXBaseCell *cell = (XXBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setCellType:XXBaseCellTypeTop withBottomMargin:0 withCellHeight:46];
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.titleLabel.text = [[self.praiseArray objectAtIndex:indexPath.row]objectForKey:@"title"];
        
        return cell;
        
    }else if (indexPath.row==self.praiseArray.count-1){
        static NSString *CommentIdentifier = @"MoreIdentifier";
        XXLoadMoreCell *cell = (XXLoadMoreCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXLoadMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
            
        }
        [cell setTitle:[[self.praiseArray objectAtIndex:indexPath.row]objectForKey:@"title"]];
        
        return cell;
    }else{
        static NSString *CommentIdentifier = @"CommentIdentifier";
        XXPraiseCell *cell = (XXPraiseCell*)[tableView dequeueReusableCellWithIdentifier:CommentIdentifier];
        
        if (!cell) {
            cell = [[XXPraiseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentIdentifier];
            [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0 withCellHeight:65];
        }
        [cell setPraiseModel:[self.praiseArray objectAtIndex:indexPath.row]];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==self.praiseArray.count-1) {
        return 46.f;
    }else if(indexPath.row==0){
        return 46.5f;
    }else{
        return 65.f;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.praiseArray.count>1&& indexPath.row== self.praiseArray.count-1) {
        NSDictionary *stateDict = [self.praiseArray objectAtIndex:indexPath.row];
        if ([[stateDict objectForKey:@"state"]boolValue]) {
            [self loadMoreResult];
        }
    }
}

#pragma mark - override api
- (void)detailModelArrayAndRowHeightNow
{
    
}

- (void)requestPraiseListNow
{
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    condition.postId = _postId;
    condition.resType = _postType;
    
    [[XXMainDataCenter shareCenter]requestPraiseListWithCondition:condition withSuccess:^(NSArray *resultList) {
        if (self.praiseArray.count>1) {
            [self.praiseArray removeLastObject];
        }
        [self.praiseArray addObjectsFromArray:resultList];
        
        if (resultList.count<_pageSize) {
            if (self.praiseArray.count==0) {
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"还没有追捧"};
                [self.praiseArray addObject:loadmoreDict];
            }else{
                NSDictionary *loadmoreDict = @{@"state":@"0",@"title":@"没有更多追捧"};
                [self.praiseArray addObject:loadmoreDict];
            }
            
        }else{
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多追捧"};
            [self.praiseArray addObject:loadmoreDict];
        }
        [_tableView reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        if (self.praiseArray.count==1) {
            NSDictionary *loadmoreDict = @{@"state":@"1",@"title":@"点击加载更多追捧"};
            [self.praiseArray addObject:loadmoreDict];
            [_tableView reloadData];
        }
        [SVProgressHUD showErrorWithStatus:faildMsg];
    }];
}
- (void)refresh
{
    _currentPageIndex = 0;
    _hiddenLoadMore = NO;
    [self requestPraiseListNow];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestPraiseListNow];
}


@end
