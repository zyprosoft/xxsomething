//
//  XXCustomButton.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXCustomButton.h"

@implementation XXCustomButton
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.frame = CGRectMake(5,5,15,15);
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
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self.iconImageView setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.iconImageView.image = [UIImage imageNamed:self.selectIconName];
    }else{
        self.iconImageView.image = [UIImage imageNamed:self.normalIconName];
    }
}
- (void)setNormalIconImage:(NSString*)nImage withSelectedImage:(NSString*)sImage withFrame:(CGRect)iconFrame
{
    self.normalIconName = nImage;
    self.selectIconName = sImage;
    
    self.iconImageView.image = [UIImage imageNamed:nImage];
    self.iconImageView.highlightedImage = [UIImage imageNamed:sImage];
    self.iconImageView.frame = iconFrame;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0,iconFrame.origin.x,0,0)];

}

- (void)setTitle:(NSString *)title withFrame:(CGRect)titleFrame
{
    [self setTitle:title forState:UIControlStateNormal];
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(titleFrame.origin.y,titleFrame.origin.x,0,0)];
}
@end
