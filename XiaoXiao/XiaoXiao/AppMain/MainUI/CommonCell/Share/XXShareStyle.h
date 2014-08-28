//
//  XXShareStyle.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXShareStyle : NSObject
@property (nonatomic,assign)NSInteger contentFontSize;
@property (nonatomic,assign)CGFloat contentLineHeight;
@property (nonatomic,assign)NSInteger thumbImageSize;
@property (nonatomic,assign)NSInteger emojiSize;
@property (nonatomic,assign)NSInteger audioImageWidth;
@property (nonatomic,assign)NSInteger audioImageHeight;
@property (nonatomic,strong)NSString  *contentTextColor;
@property (nonatomic,strong)NSString  *contentTextAlign;
@property (nonatomic,strong)NSString  *contentFontWeight;
@property (nonatomic,strong)NSString  *contentFontFamily;

//每个模板下，对应的风格设置
+ (XXShareStyle*)shareStyleForSharePostType:(XXSharePostType)sharePostType withContentWidth:(CGFloat)contentWidth;

+ (XXShareStyle*)commonStyle;

+ (XXShareStyle*)chatStyle;

+ (XXShareStyle*)userInfoCellStyle;

@end
