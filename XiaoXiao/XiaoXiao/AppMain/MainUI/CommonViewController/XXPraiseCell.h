//
//  XXPraiseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBaseCell.h"

@interface XXPraiseCell : XXBaseCell
{
    XXHeadView *_headView;
    UILabel    *_nameLabel;
    UILabel    *_timeLabel;
    UIImageView *_praiseImageView;
}

- (void)setPraiseModel:(XXPraiseModel *)contentModel;

@end
