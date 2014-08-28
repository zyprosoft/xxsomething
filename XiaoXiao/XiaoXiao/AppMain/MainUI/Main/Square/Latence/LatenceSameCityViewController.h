//
//  LatenceSameCityViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSchoolListViewController.h"

@interface LatenceSameCityViewController : XXSchoolSearchViewController
{
    NSString *_currentUserCity;
    NSIndexPath *_selectedIndexPath;
    
    XXCustomTabBar *_menuBar;
    UIImageView    *_selectTagView;
    NSInteger _currentSearchType;
}
@property (nonatomic,assign) NSInteger currentSearchType;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;


@end
