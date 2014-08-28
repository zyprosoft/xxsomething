//
//  XXUserInfoCellStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXUserInfoCellStyle : NSObject

+ (NSInteger)emojiSize;
+ (NSInteger)sexTagWidth;
+ (NSInteger)sexTagHeight;
+ (CGFloat)lineHeight;
+ (CGFloat)contentWidth;

//username
+ (CGFloat)userNameContentLineHeight;
+ (NSInteger)userNameContentFontSize;
+ (NSString*)userNameContentTextColor;
+ (NSString*)userNameContentTextAlign;
+ (NSString*)userNameContentFontFamily;
+ (NSString*)userNameContentFontWeight;

//college
+ (CGFloat)collegeContentLineHeight;
+ (NSInteger)collegeContentFontSize;
+ (NSString*)collegeContentTextColor;
+ (NSString*)collegeContentTextAlign;
+ (NSString*)collegeContentFontFamily;
+ (NSString*)collegeContentFontWeight;

//starscore
+ (CGFloat)starscoreContentLineHeight;
+ (NSInteger)starscoreContentFontSize;
+ (NSString*)starscoreContentTextColor;
+ (NSString*)starscoreContentTextAlign;
+ (NSString*)starscoreContentFontFamily;
+ (NSString*)starscoreContentFontWeight;

//score
+ (CGFloat)scoreContentLineHeight;
+ (NSInteger)scoreContentFontSize;
+ (NSString*)scoreContentTextColor;
+ (NSString*)scoreContentTextAlign;
+ (NSString*)scoreContentFontFamily;
+ (NSString*)scoreContentFontWeight;

//profile
+ (CGFloat)profileContentLineHeight;
+ (NSInteger)profileContentFontSize;
+ (NSString*)profileContentTextColor;
+ (NSString*)profileContentTextAlign;
+ (NSString*)profileContentFontFamily;
+ (NSString*)profileContentFontWeight;

@end
