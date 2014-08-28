//
//  XXGradeChooseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 *通用年级选择列表
 */
typedef void (^XXGradeChooseViewControllerFinishChooseBlock) (NSString *resultString);

@interface XXGradeChooseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    XXGradeChooseViewControllerFinishChooseBlock _finishBlock;
    XXCommonNavigationNextStepBlock _nextStepBlock;
    UITableView *_tableView;
    NSArray *_gradeArray;
    NSInteger _selectIndex;
}
- (void)setDefaultSelectValue:(NSString*)value;

- (void)setFinishBlock:(XXGradeChooseViewControllerFinishChooseBlock)finishBlock;
- (void)setNextStepAction:(XXCommonNavigationNextStepBlock)nextStepBlock;
@end
