//
//  XXSchoolSearchViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSchoolSearchViewController.h"
#import "XXSchoolChooseCell.h"

@interface XXSchoolSearchViewController ()

@end

@implementation XXSchoolSearchViewController

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
    _resultSchoolArray = [[NSMutableArray alloc]init];
    _currentResultPageIndex = 0;
    _pageSize = 30;
    _selectIndex = 0;
    _needLoadMore = YES;
    CGFloat totoalHeight = self.view.frame.size.height-44;
    CGFloat totalWidth = self.view.frame.size.width;
    DDLogVerbose(@"totalHeight -->%f",totoalHeight);
    
    UIView *backBar = [[UIView alloc]init];
    backBar.frame = CGRectMake(0,0,totalWidth,46);
    [self.view addSubview:backBar];
    backBar.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    
    _searchBar = [[XXSearchBar alloc]initWithFrame:CGRectMake(3,3,totalWidth-6,40)];
    [self.view addSubview:_searchBar];
    DDLogVerbose(@"_searchBar frame:%@",NSStringFromCGRect(_searchBar.frame));
    
    _resultTableView = [[UITableView alloc]init];
    _resultTableView.frame = CGRectMake(0,_searchBar.frame.size.height+6,totalWidth,totoalHeight-_searchBar.frame.size.height-_searchBar.frame.origin.y);
    _resultTableView.delegate = self;
    _resultTableView.dataSource = self;
    _resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_resultTableView];
    
    //config search bar
    [self configSearchBarAction];
    
    //navigation next setp
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self];
    
    //search bar input change
    CGRect resultTableRect = _resultTableView.frame;
    _resultTableView.keyboardTriggerOffset = 0.f;
    
    WeakObj(_searchBar) weakSearchBar = _searchBar;
    WeakObj(_resultTableView) weakResultTable = _resultTableView;
    [self.view addKeyboardNonpanningWithActionHandler:^(CGRect keyboardFrameInView) {
        DDLogVerbose(@"kebyordFrameInView:%@",NSStringFromCGRect(keyboardFrameInView));
        CGRect makeNewRect = CGRectMake(resultTableRect.origin.x,resultTableRect.origin.y,resultTableRect.size.width,keyboardFrameInView.origin.y-weakSearchBar.frame.size.height-weakSearchBar.frame.origin.y);
        weakResultTable.frame = makeNewRect;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setFinishChooseSchool:(XXSchoolSearchViewControllerFinishChooseBlock)chooseBlock
{
    _chooseBlock = chooseBlock;
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _resultSchoolArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    XXSchoolChooseCell *cell = (XXSchoolChooseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXSchoolChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setContentModel:[_resultSchoolArray objectAtIndex:indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectIndex = indexPath.row;
    XXSchoolModel *selectSchool = [_resultSchoolArray objectAtIndex:indexPath.row];
    [_searchBar finishChooseWithNameText:selectSchool.schoolName];
    if (_chooseBlock) {
        _chooseBlock(selectSchool);
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _resultSchoolArray.count-1 && _needLoadMore) {
        [self loadMoreResult];
    }
}
#pragma mark - Config Search Bar Action
- (void)configSearchBarAction
{
    XXSearchBarValueChangeBlock valueChangeBlock = ^ (BOOL canEnableNextStep, NSString *msg){
        if (canEnableNextStep) {
            [[XXCacheCenter shareCenter]searchSchoolWithKeyword:msg withResult:^(NSArray *resultArray) {
                _currentResultPageIndex = 0;
                DDLogVerbose(@"result school:%d pageSize:%d",resultArray.count,_pageSize);
                if (resultArray.count!=_pageSize) {
                    _needLoadMore = NO;
                }else{
                    _needLoadMore = YES;
                }
                [_resultSchoolArray removeAllObjects];
                [_resultSchoolArray addObjectsFromArray:resultArray];
                [_resultTableView reloadData];
            } withPageIndex:_currentResultPageIndex withPageSize:_pageSize];
        }
    };
    [_searchBar setValueChangedBlock:^(BOOL canEnableNextStep, NSString *msg) {
        valueChangeBlock(canEnableNextStep,msg);
    }];
    [_searchBar setBeginSearchBlock:^{
        
    }];
    
}
#pragma mark - next step
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock
{
    _nextStepBlock = nextStepBlock;
    _nextStepTitle = @"下一步";
}
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock withNextStepTitle:(NSString *)title
{
    _nextStepBlock = nextStepBlock;
    _nextStepTitle = title;
    [XXCommonUitil setCommonNavigationNextStepItemForViewController:self withNextStepAction:^{
        if (_nextStepBlock) {
            if (_resultSchoolArray.count !=0 && [_resultSchoolArray objectAtIndex:_selectIndex]) {
                XXSchoolModel *chooseModel = [_resultSchoolArray objectAtIndex:_selectIndex];
                NSDictionary *resuldDict = @{@"result":chooseModel};
                _nextStepBlock(resuldDict);
            }else{
                [SVProgressHUD showErrorWithStatus:@"未选择学校"];
                
            }
        }
    } withTitle:_nextStepTitle];
}

- (void)searchSchoolNow
{
    [[XXCacheCenter shareCenter]searchSchoolWithKeyword:_searchBar.contentTextField.text withResult:^(NSArray *resultArray) {
        if (resultArray.count!=_pageSize) {
            _needLoadMore = NO;
        }else{
            _needLoadMore = YES;
        }
        [_resultSchoolArray addObjectsFromArray:resultArray];
        [_resultTableView reloadData];
    } withPageIndex:_currentResultPageIndex withPageSize:_pageSize];
}
- (void)loadMoreResult
{
    _currentResultPageIndex++;
    [self searchSchoolNow];
}

@end
