//
//  XXLeftNavItem.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXLeftNavItem.h"

@implementation XXLeftNavItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        iconImageView  = [[UIImageView alloc]init];
        iconImageView.frame = CGRectMake(5,13,18,18);
        [self addSubview:iconImageView];
        
        titleLabel = [[UILabel alloc]init];
        titleLabel.frame = CGRectMake(28,5,frame.size.width-28-5,34);
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment  = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
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
- (void)setTitle:(NSString *)title
{
    titleLabel.text = title;
}
- (void)setIconName:(NSString *)iconName
{
    iconImageView.image  = [UIImage imageNamed:iconName];
}
@end
