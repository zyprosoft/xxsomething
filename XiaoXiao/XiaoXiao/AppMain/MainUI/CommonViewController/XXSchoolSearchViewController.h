//
//  XXSchoolSearchViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSchoolModel.h"
#import "XXSearchBar.h"
#import "XXBaseViewController.h"

/*
 *通用学校搜索列表
 */
typedef void (^XXSchoolSearchViewControllerFinishChooseBlock) (XXSchoolModel *chooseSchool);

@interface XXSchoolSearchViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    XXSchoolSearchViewControllerFinishChooseBlock _chooseBlock;
    XXCommonNavigationNextStepBlock _nextStepBlock;
    UITableView *_resultTableView;
    NSMutableArray *_resultSchoolArray;
    XXSearchBar *_searchBar;
    NSInteger   _currentResultPageIndex;
    NSInteger   _pageSize;
    NSInteger   _selectIndex;
    BOOL        _needLoadMore;
    NSString    *_nextStepTitle;
}
@property (nonatomic,assign)NSInteger   currentResultPageIndex;

- (void)setFinishChooseSchool:(XXSchoolSearchViewControllerFinishChooseBlock)chooseBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock withNextStepTitle:(NSString*)title;

- (void)searchSchoolNow;
- (void)loadMoreResult;

@end
