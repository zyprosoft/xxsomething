//
//  XXChatStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-7.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXChatStyle : NSObject

+ (CGFloat)contentLineHeight;
+ (NSInteger)contentFontSize;
+ (NSString*)contentTextColor;
+ (NSString*)contentTextAlign;
+ (NSString*)contentFontFamily;
+ (NSString*)contentFontWeight;
+ (NSInteger)emojiSize;

+ (XXChatStyle*)commonStyle;

@end
