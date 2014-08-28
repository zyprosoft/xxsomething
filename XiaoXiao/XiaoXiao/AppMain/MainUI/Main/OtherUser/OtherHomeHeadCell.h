//
//  OtherHomeHeadCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherUserHomeHeadView.h"


typedef void (^OtherHomeHeadCellTeaseBlock) (void);
@interface OtherHomeHeadCell : UITableViewCell
{
    OtherUserHomeHeadView  *_headView;
    OtherHomeHeadCellTeaseBlock _teaseBlock;
}

- (void)setContentUser:(XXUserModel*)aUser;
- (void)setTeaseActionBlock:(OtherHomeHeadCellTeaseBlock)teaseBlock;

- (void)updateUserCared:(BOOL)isCared;

@end
