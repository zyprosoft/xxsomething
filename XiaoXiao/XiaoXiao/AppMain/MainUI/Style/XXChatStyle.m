//
//  XXChatStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-7.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXChatStyle.h"

@implementation XXChatStyle

+ (CGFloat)contentLineHeight;
{
    return 1.4;
}
+ (NSInteger)contentFontSize
{
    return 15;
}
+ (NSString*)contentTextColor
{
    return @"#463a45";
}
+ (NSString*)contentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)contentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)contentFontWeight
{
    return XXFontWeightNormal;
}
+ (NSInteger)emojiSize
{
    return 22;
}

+ (XXChatStyle*)commonStyle
{
    XXChatStyle *aStyle = [[XXChatStyle alloc]init];
    return aStyle;
}

@end
