//
//  XXLoadMoreView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXLoadMoreView.h"

@implementation XXLoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:_backgroundImageView];
        
        _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(105,5,34,34);
        [self addSubview:_indicatorView];
        
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.frame = CGRectMake(40,0,frame.size.width-40,frame.size.height);
        [self addSubview:_titleLabel];
        _titleLabel.text = @"加载更多...";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
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
- (void)startLoading
{
    _titleLabel.frame = CGRectMake(40,0,self.frame.size.width-40,self.frame.size.height);
    [_indicatorView startAnimating];
    _titleLabel.text = @"正在加载...";
}
- (void)endLoading
{
    _titleLabel.frame = CGRectMake(40,0,self.frame.size.width-40,self.frame.size.height);
    [_indicatorView stopAnimating];
    _titleLabel.text = @"加载更多...";
}
- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}
- (void)setLabelModel
{
    _titleLabel.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}
@end
