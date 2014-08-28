//
//  LatenceHistoryViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "LatenceHistoryViewController.h"

@interface LatenceHistoryViewController ()

@end

@implementation LatenceHistoryViewController

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
    
    _searchBar.hidden = YES;
    _resultTableView.frame = CGRectMake(0,0,self.view.frame.size.width,XXNavContentHeight-44-49);
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
    [[XXUserCacheCenter shareCenter]returnHistoryStrollSchoolWithResult:^(NSArray *resultArray) {
        if (resultArray.count!=_pageSize) {
            _needLoadMore = NO;
        }else{
            _needLoadMore = YES;
        }
        [_resultSchoolArray addObjectsFromArray:resultArray];
        [_resultTableView reloadData]; 
    }];
}
@end
