//
//  InSchoolSearchUserListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "InSchoolSearchUserListViewController.h"
#import "LatenceGuideViewController.h"

@interface InSchoolSearchUserListViewController ()

@end

@implementation InSchoolSearchUserListViewController

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
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withIconImage:@"nav_stroll.png" withNextStepAction:^{
        LatenceGuideViewController *latenceViewController = [[LatenceGuideViewController alloc]init];
        [self.navigationController pushViewController:latenceViewController animated:YES];
    } withTitle:@"潜伏"];
    
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self withBackStepAction:^{
        InSchoolUserFilterViewController *filterVC = [[InSchoolUserFilterViewController alloc]init];
        filterVC.title = @"按条件筛选";
        filterVC.delegate = self;
        [self.navigationController pushViewController:filterVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:filterVC];
    } withIconImage:@"nav_share_post_setting.png"];
    
    CGFloat totalHeight = XXNavContentHeight-44-49;

//    //black board
//    blackBoardView = [[UIControl alloc]init];
//    blackBoardView.frame = CGRectMake(0,44,self.view.frame.size.width,totalHeight-44);
//    blackBoardView.alpha = 0.6;
//    blackBoardView.backgroundColor = [UIColor blackColor];
//    [blackBoardView addTarget:self action:@selector(blackboardAction) forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:blackBoardView];
//    [self.view sendSubviewToBack:blackBoardView];
//    
//    //insert search bar
//    UIView *barBack = [[UIView alloc]init];
//    barBack.frame = CGRectMake(0,0,self.view.frame.size.width,44);
//    barBack.layer.borderWidth = 1;
//    barBack.backgroundColor = [UIColor whiteColor];
//    barBack.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
//    [self.view addSubview:barBack];
//    
//    searchBar = [[XXSearchBar alloc]initWithFrame:CGRectMake(10,4,self.view.frame.size.width-20,36)];
//    searchBar.contentTextField.placeholder = @"输入校校号或者关键字找人";
//    searchBar.contentTextField.font = [UIFont systemFontOfSize:13];
//    searchBar.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:searchBar];
//    WeakObj(self) weakSelf = self;
//    WeakObj(blackBoardView) weakBlackBoard = blackBoardView;
//    [searchBar setBeginSearchBlock:^{
//        [weakSelf.view bringSubviewToFront:weakBlackBoard];
//    }];
//    
//    WeakObj(keyword) weakKeyword = keyword;
//    [searchBar setSearchBlock:^(NSString *searchText) {
//        weakKeyword = searchText;
//        [weakSelf refresh];
//        [weakSelf blackboardAction];
//    }];
    
    
    //black title
    UIView *blackTitleView = [[UIView alloc]init];
    blackTitleView.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    blackTitleView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:blackTitleView];
    
    //themeback
    UIView *themeBackView = [[UIView alloc]init];
    themeBackView.frame = CGRectMake(0,1,blackTitleView.frame.size.width,39);
    themeBackView.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    [blackTitleView addSubview:themeBackView];
    
    //icon
    UIImageView *locationIcon = [[UIImageView alloc]init];
    locationIcon.frame = CGRectMake(10, 8, 19, 19);
    locationIcon.image = [UIImage imageNamed:@"location_school.png"];
    [blackTitleView addSubview:locationIcon];
    
    //school title label
    _currentSchoolLabel = [[UILabel alloc]init];
    _currentSchoolLabel.frame = CGRectMake(35,8,150,20);
    _currentSchoolLabel.backgroundColor = [UIColor clearColor];
    _currentSchoolLabel.textColor = rgb(80, 85, 90, 1);
    _currentSchoolLabel.text = [XXUserDataCenter currentLoginUser].schoolName;
    [blackTitleView addSubview:_currentSchoolLabel];
    
    
    _userListTable.frame = CGRectMake(0,40,self.view.frame.size.width,totalHeight-40);
    
    
    [_refreshControl beginRefreshing];
    [self refresh];
    
    //observe user change stroll school
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeUserFinishLantenceNoti:) name:XXUserHasStrollNewSchool object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self blackboardAction];
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
    if (!condition) {
        condition = [[XXConditionModel alloc]init];
    }
    condition.schoolId = [XXUserDataCenter currentLoginUser].strollSchoolId;
    condition.pageIndex = StringInt(_currentPageIndex);
    condition.pageSize = StringInt(_pageSize);
    condition.keyword = keyword;
    [[XXMainDataCenter shareCenter]requestSameSchoolUsersWithCondition:condition withSuccess:^(NSArray *resultList) {
        
        if (resultList.count<_pageSize) {
            _hiddenLoadMore = YES;
            if (resultList.count==0&&_userListArray.count==0) {
                [SVProgressHUD showErrorWithStatus:@"此学校还没有人"];
                
            }
        }
        if (_isRefresh) {
            [_userListArray removeAllObjects];
            _isRefresh = NO;
            [_refreshControl endRefreshing];
            [XXSimpleAudio playRefreshEffect];
            [_userListTable scrollRectToVisible:CGRectMake(0,0,_userListTable.frame.size.width,_userListTable.frame.size.height) animated:YES];
        }
        [_userListArray addObjectsFromArray:resultList];
        [_userListTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        [SVProgressHUD showErrorWithStatus:faildMsg];
        if (_isRefresh) {
            _isRefresh=NO;
            [_refreshControl endRefreshing];
        }
        [_userListTable reloadData];
    }];
}
- (void)loadMoreResult
{
    _currentPageIndex++;
    [self requestUserList];
}

//#pragma mark - black board dismiss
//- (void)blackboardAction
//{
//    [searchBar.contentTextField resignFirstResponder];
//    [self.view sendSubviewToBack:blackBoardView];
//}

//observ lantence school noti
- (void)observeUserFinishLantenceNoti:(NSNotification*)noti
{
    [self performSelector:@selector(refresh) withObject:nil afterDelay:0.2];
    _currentSchoolLabel.text = [XXUserDataCenter currentLoginUser].strollSchoolName;
}

#pragma mark user fileter
- (void)inSchoolUserFilterViewControllerDidFinishChooseCondition:(XXConditionModel *)aCondition
{
    DDLogVerbose(@"get filters:%@",aCondition);
    condition.grade = aCondition.grade;
    condition.schoolRoll = aCondition.schoolRoll;
    condition.sex = aCondition.sex;
    condition.userScoreRank = aCondition.userScoreRank;
    condition.userWellKnowRank = aCondition.userWellKnowRank;
    
    [self refresh];
    
}

@end
