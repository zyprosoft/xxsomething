//
//  UIButton+XXStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-11.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "UIButton+XXStyle.h"

@implementation UIButton (XXStyle)

-(void)bootstrapStyle{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 4.0;
    self.layer.masksToBounds = YES;
    [self setAdjustsImageWhenHighlighted:NO];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)defaultStyle{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
    [self setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

- (void)blueStyle
{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [XXCommonStyle xxThemeBlueColor];
    self.layer.borderColor = [XXCommonStyle xxThemeBlueColor].CGColor;
    [self setBackgroundImage:[self buttonImageFromColor:[XXCommonStyle xxThemeBlueSelectedColor]] forState:UIControlStateHighlighted];
}

- (void)redStyle
{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [XXCommonStyle xxThemeRedColor];
    self.layer.borderColor = [XXCommonStyle xxThemeRedColor].CGColor;
    [self setBackgroundImage:[self buttonImageFromColor:[XXCommonStyle xxThemeRedSelectedColor]] forState:UIControlStateHighlighted];
}

- (void)teaseStyle
{
    [self bootstrapStyle];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.backgroundColor = [XXCommonStyle xxThemeTeaseBackColor];
    self.layer.borderColor = [XXCommonStyle xxThemeTeaseBackColor].CGColor;
    [self setBackgroundImage:[self buttonImageFromColor:[XXCommonStyle xxThemeTeaseBackSelectedColor]] forState:UIControlStateHighlighted];
}

- (UIImage *) buttonImageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
