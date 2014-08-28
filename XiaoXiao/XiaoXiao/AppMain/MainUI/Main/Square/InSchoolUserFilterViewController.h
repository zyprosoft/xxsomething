//
//  InSchoolUserFilterViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserFilterViewController.h"
#import "XXSegmentControl.h"

@protocol InSchoolUserFilterViewControllerDelegate <NSObject>

- (void)inSchoolUserFilterViewControllerDidFinishChooseCondition:(XXConditionModel*)aCondition;

@end
@interface InSchoolUserFilterViewController : XXUserFilterViewController
{
    UIScrollView *_backScrollView;
    XXSegmentControl *segBoyGire;
    XXSegmentControl *schoolRoll;
    XXSegmentControl *AboutKnow;
    
    NSIndexPath *selectPath;
}
@property (nonatomic,weak)id<InSchoolUserFilterViewControllerDelegate> delegate;

@end
