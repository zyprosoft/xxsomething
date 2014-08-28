//
//  XXMyShareBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXMyShareBaseCell.h"

@implementation XXMyShareBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(backgroundImageView.frame.size.width-10-27,10,27,27);
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete_share.png"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(tapOnDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [backgroundImageView addSubview:_deleteBtn];
        
        _timeLabel.frame = CGRectMake(_timeLabel.frame.origin.x,_deleteBtn.frame.origin.y+_deleteBtn.frame.size.height+2,_timeLabel.frame.size.width,_timeLabel.frame.size.height);
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)tapOnDeleteBtn
{
    if (_deleteBlock) {
        _deleteBlock(self);
    }
}
- (void)setDeleteShareBlock:(XXMyShareBaseCellDidTapDeleteBlock)deleteBlock
{
    _deleteBlock = [deleteBlock copy];
}

@end
