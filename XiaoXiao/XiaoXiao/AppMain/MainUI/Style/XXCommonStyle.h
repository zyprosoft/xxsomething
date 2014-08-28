//
//  XXCommonStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXCommonStyle : NSObject

+ (CGFloat)commonPostContentLineHeight;
+ (NSInteger)commonPostContentFontSize;
+ (NSString*)commonPostContentTextColor;
+ (NSString*)commonPostContentTextAlign;
+ (NSString*)commonPostContentFontFamily;
+ (NSString*)commonPostContentFontWeight;
+ (NSInteger)commonPostEmojiSize;

+ (UIColor*)xxThemeBlueColor;
+ (UIColor*)xxThemeBlueSelectedColor;
+ (UIColor*)xxThemeRedColor;
+ (UIColor*)xxThemeRedSelectedColor;
+ (UIColor*)xxThemeDefaultSelectedColor;
+ (UIColor*)xxThemeTeaseBackColor;
+ (UIColor*)xxThemeTeaseBackSelectedColor;
+ (UIColor*)xxThemeButtonBoardColor;
+ (CGFloat)xxThemeButtonBoardWidth;
+ (UIColor*)xxThemeButtonTitleColor;
+ (CGFloat)xxThemeButtonCornerRadius;
+ (CGFloat)xxThemeNavigationBarCornerRadius;
+ (CGFloat)xxThemeLoginGuideButtonRadius;
+ (UIView*)xxThemeNormalCellBackground;
+ (UIColor*)xxThemeBackgroundColor;
+ (UIColor*)xxThemeGrayTitleColor;
+ (UIColor*)xxThemeHomeBackColor;
+ (UIColor*)xxThemeButtonGrayTitleColor;
+ (UIColor*)xxThemeDarkBlueColor;


//school choose cell
+ (UIColor*)schoolChooseCellTitleColor;
+ (UIFont*)schoolChooseCellTitleFont;

@end
