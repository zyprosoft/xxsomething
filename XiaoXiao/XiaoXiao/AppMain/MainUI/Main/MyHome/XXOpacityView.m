//
//  XXOpacityView.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-14.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXOpacityView.h"

@implementation XXOpacityView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _backgroundView = [[UIImageView alloc]init];
        _backgroundView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.59;
        _backgroundView.layer.cornerRadius = 8.f;
        [self addSubview:_backgroundView];
        
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = _backgroundView.frame;
        _contentLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentLabel];
        
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.frame = CGRectMake(0,10,frame.size.width,frame.size.height-10);
        _detailLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_detailLabel];
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = _backgroundView.frame;
        [self addSubview:_iconImageView];
    }
    return self;
}
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        _backgroundView.alpha = 0.9;
    }else{
        _backgroundView.alpha = 0.59;
    }
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
