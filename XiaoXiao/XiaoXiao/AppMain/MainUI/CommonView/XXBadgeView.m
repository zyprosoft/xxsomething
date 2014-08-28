//
//  XXBadgeView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBadgeView.h"

@implementation XXBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [[UIImage imageNamed:@"red_badge_view.png"]t:3 l:3 b:3 r:3];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.titleLabel];
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

@end
