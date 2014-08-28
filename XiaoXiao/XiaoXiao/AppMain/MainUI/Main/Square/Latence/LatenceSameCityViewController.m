//
//  LatenceSameCityViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LatenceSameCityViewController.h"

@interface LatenceSameCityViewController ()

@end

@implementation LatenceSameCityViewController

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
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    CGFloat totalWidth = self.view.frame.size.width;
    
    _searchBar.hidden = YES;
    _currentSearchType = 0;//default
    if (_currentSearchType==0) {
        _currentUserCity = [XXUserDataCenter currentLoginUser].province;
    }else{
        _currentUserCity = [XXUserDataCenter currentLoginUser].city;
    }
    
    NSMutableArray *tabBarConfig = [NSMutableArray array];
    //    NSDictionary *audioMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"留声机",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    //    [tabBarConfig addObject:audioMsgItem];
    
    NSDictionary *replyMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"大学",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:replyMsgItem];
    
    NSDictionary *teaseMsgItem = @{XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@"",XXBarItemTitleKey:@"中学",XXBarItemNormalIconKey:@"",XXBarItemSelectIconKey:@""};
    [tabBarConfig addObject:teaseMsgItem];
    
    _menuBar = [[XXCustomTabBar alloc]initWithFrame:CGRectMake(0,0,totalWidth,44) withConfigArray:tabBarConfig];
    [self.view addSubview:_menuBar];
    _menuBar.layer.borderColor = [XXCommonStyle xxThemeGrayTitleColor].CGColor;
    _menuBar.layer.borderWidth = 1.0f;
    
    //tagLine
    _selectTagView = [[UIImageView alloc]init];
    _selectTagView.backgroundColor = rgb(0,197,181,1);
    _selectTagView.frame = CGRectMake(0,42,self.view.frame.size.width/2,2);
    [self.view addSubview:_selectTagView];
    
    WeakObj(self) weakSelf = self;
    WeakObj(_selectTagView) weakTagView = _selectTagView;
    WeakObj(_resultSchoolArray) weakResultSchoolArray = _resultSchoolArray;
    WeakObj(_currentUserCity) weakUserCity = _currentUserCity;
    
    [_menuBar setTabBarDidSelectAtIndexBlock:^(NSInteger index) {
        
        DDLogVerbose(@"menu bar index :%d",index);
        weakSelf.currentSearchType = index;
        if (weakSelf.currentSearchType==0) {
            weakUserCity = [XXUserDataCenter currentLoginUser].province;
        }else{
            weakUserCity = [XXUserDataCenter currentLoginUser].city;
        }
        weakSelf.currentResultPageIndex = 0;

        weakSelf.selectedIndexPath = nil;
        [weakResultSchoolArray removeAllObjects];
        [weakSelf searchSchoolNow];
        
        weakTagView.frame = CGRectMake(index*(weakSelf.view.frame.size.width/2),42,weakSelf.view.frame.size.width/2,2);
    }];
    
    //seprator
    UIImageView *middleSepLine = [[UIImageView alloc]init];
    middleSepLine.frame = CGRectMake(self.view.frame.size.width/2-1,0,1,44);
    middleSepLine.backgroundColor = [XXCommonStyle xxThemeGrayTitleColor];
    [self.view addSubview:middleSepLine];
    
    _resultTableView.frame = CGRectMake(0,44,self.view.frame.size.width,totalHeight-44);
    [self searchSchoolNow];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedIndexPath) {
        XXSchoolChooseCell *lastSelectCell = (XXSchoolChooseCell*)[tableView cellForRowAtIndexPath:_selectedIndexPath];
        [lastSelectCell setChooseState:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    _selectedIndexPath = indexPath;
    
    XXSchoolChooseCell *lastSelectCell = (XXSchoolChooseCell*)[tableView cellForRowAtIndexPath:_selectedIndexPath];
    [lastSelectCell setChooseState:YES];
    XXSchoolModel *selectSchool = [_resultSchoolArray objectAtIndex:indexPath.row];
    [_searchBar finishChooseWithNameText:selectSchool.schoolName];
    if (_chooseBlock) {
        _chooseBlock(selectSchool);
    }
}

- (void)searchSchoolNow
{
    NSString *searchType = [NSString stringWithFormat:@"%d",_currentSearchType];
    [[XXCacheCenter shareCenter]searchSchoolWithCityName:_currentUserCity withResult:^(NSArray *resultArray) {
        if (resultArray.count!=_pageSize) {
            _needLoadMore = NO;
        }else{
            _needLoadMore = YES;
        }
        [_resultSchoolArray addObjectsFromArray:resultArray];
        [_resultTableView reloadData];
    } withPageIndex:_currentResultPageIndex withPageSize:_pageSize withSchoolType:searchType];
}

@end
