//
//  XXMyShareBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXShareBaseCell.h"

@class XXMyShareBaseCell;
typedef void (^XXMyShareBaseCellDidTapDeleteBlock) (XXMyShareBaseCell *tapOnCell);
@interface XXMyShareBaseCell : XXShareBaseCell
{
    UIButton *_deleteBtn;
    XXMyShareBaseCellDidTapDeleteBlock _deleteBlock;
}
- (void)setDeleteShareBlock:(XXMyShareBaseCellDidTapDeleteBlock)deleteBlock;
@end
