//
//  XXCommonStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommonStyle.h"

@implementation XXCommonStyle

+ (CGFloat)commonPostContentLineHeight
{
    return 2.0f;
}
+ (NSInteger)commonPostContentFontSize
{
    return 14;
}
+ (NSString*)commonPostContentTextColor
{
    return @"#463a45";
}
+ (NSString*)commonPostContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)commonPostContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)commonPostContentFontWeight
{
    return XXFontWeightNormal;
}
+ (NSInteger)commonPostEmojiSize
{
    return 24;
}

//UI style
+ (UIColor*)xxThemeBlueColor
{
    return rgb(5,232,219,1);
}
+ (UIColor*)xxThemeBlueSelectedColor
{
    return rgb(10,216,204,1);
}
+ (UIColor*)xxThemeRedColor
{
    return rgb(232,75,55,1);
}
+ (UIColor*)xxThemeRedSelectedColor
{
    return rgb(255,87,65,1);
}
+ (UIColor*)xxThemeDefaultSelectedColor
{
    return rgb(235,235,235,1);
}
+ (UIColor*)xxThemeTeaseBackColor
{
    return rgb(234,39,80,1);
}
+ (UIColor *)xxThemeTeaseBackSelectedColor
{
    return rgb(249,79,115,1);
}
+ (UIColor*)xxThemeButtonBoardColor
{
    return rgb(227,230,232,1);
}
+ (CGFloat)xxThemeButtonBoardWidth
{
    return 1.0f;
}
+ (UIColor*)xxThemeButtonTitleColor
{
    return [UIColor blackColor];
}
+ (CGFloat)xxThemeButtonCornerRadius
{
    return 3.0f;
}
+ (CGFloat)xxThemeNavigationBarCornerRadius
{
    return 4.0f;
}
+ (CGFloat)xxThemeLoginGuideButtonRadius
{
    return 6.0f;
}
+ (UIColor*)xxThemeBackgroundColor
{
    return rgb(229,233,238, 1);
}
+ (UIColor*)xxThemeGrayTitleColor
{
    return rgb(222,222,222,1);
}
+ (UIColor*)xxThemeHomeBackColor
{
    return rgb(78,84,87,1);
}
+ (UIColor*)xxThemeButtonGrayTitleColor
{
    return rgb(125,130,136,1);
}
+ (UIColor*)xxThemeDarkBlueColor
{
    return rgb(11,26,36,1);
}

//school choose cell
+ (UIColor *)schoolChooseCellTitleColor
{
    return rgb(94,94,94,1);
}
+ (UIFont*)schoolChooseCellTitleFont
{
    return [UIFont systemFontOfSize:16];
}
@end
