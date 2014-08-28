//
//  InSchoolSearchUserListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseUserListViewController.h"
#import "InSchoolUserFilterViewController.h"

@interface InSchoolSearchUserListViewController : XXBaseUserListViewController<InSchoolUserFilterViewControllerDelegate>
{
    UIControl *blackBoardView;
    XXSearchBar *searchBar;
    NSString *keyword;
    UILabel  *_currentSchoolLabel;
    XXConditionModel *condition;
}
@end
