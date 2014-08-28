//
//  XXUserInfoCellStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserInfoCellStyle.h"

@implementation XXUserInfoCellStyle



+ (NSInteger)emojiSize
{
    return 18;
}
+ (NSInteger)sexTagWidth
{
    return 12;
}
+ (NSInteger)sexTagHeight
{
    return 12;
}
+ (CGFloat)lineHeight
{
    return 0.8f;
}
+ (CGFloat)contentWidth
{
    return 204;
}

//username
+ (CGFloat)userNameContentLineHeight
{
    return 0.0;
}
+ (NSInteger)userNameContentFontSize
{
    return 15;
}
+ (NSString*)userNameContentTextColor
{
    return @"#171b22";
}
+ (NSString*)userNameContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)userNameContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)userNameContentFontWeight
{
    return XXFontWeightBold;
}

//college
+ (CGFloat)collegeContentLineHeight
{
    return 0.0;
}
+ (NSInteger)collegeContentFontSize
{
    return 15;
}
+ (NSString*)collegeContentTextColor
{
    return @"#171b22";
}
+ (NSString*)collegeContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)collegeContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)collegeContentFontWeight
{
    return XXFontWeightBold;
}

//starscore
+ (CGFloat)starscoreContentLineHeight
{
    return 0.0;
}
+ (NSInteger)starscoreContentFontSize
{
    return 13;
}
+ (NSString*)starscoreContentTextColor
{
    return @"#7d8288";
}
+ (NSString*)starscoreContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)starscoreContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)starscoreContentFontWeight
{
    return XXFontWeightNormal;
}

//score
+ (CGFloat)scoreContentLineHeight
{
    return 0.0;
}
+ (NSInteger)scoreContentFontSize
{
    return 15;
}
+ (NSString*)scoreContentTextColor
{
    return @"#fa5c47";
}
+ (NSString*)scoreContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)scoreContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)scoreContentFontWeight
{
    return XXFontWeightBold;
}

//profile
+ (CGFloat)profileContentLineHeight
{
    return 0.0;
}
+ (NSInteger)profileContentFontSize
{
    return 14;
}
+ (NSString*)profileContentTextColor
{
    return @"#7d8288";
}
+ (NSString*)profileContentTextAlign
{
    return XXTextAlignLeft;
}
+ (NSString*)profileContentFontFamily
{
    return @"Helvetica";
}
+ (NSString*)profileContentFontWeight
{
    return XXFontWeightNormal;
}

@end
