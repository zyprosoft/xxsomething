//
//  XXResponseButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXResponseButton.h"

@implementation XXResponseButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
        [self addSubview:self.iconImageView];
        self.iconImageView.userInteractionEnabled = NO;
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
- (void)didTapOnSelf
{
    if (_tapBlock) {
        _tapBlock();
    }
}
- (void)setNormalIconImage:(NSString *)nImage
{
    self.iconImageView.image = [UIImage imageNamed:nImage];
    self.iconImageView.frame = CGRectMake(0,0,self.frame.size.width,self.frame.size.height);
}
- (void)setButtonSelfTapInside
{
    [self addTarget:self action:@selector(didTapOnSelf) forControlEvents:UIControlEventTouchUpInside];
}
- (void)setResponseButtonTapped:(XXResponseButtonDidTapBlock)tapBlock
{
    _tapBlock = tapBlock;
}

@end
