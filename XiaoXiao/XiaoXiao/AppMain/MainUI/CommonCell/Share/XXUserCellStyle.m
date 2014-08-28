//
//  XXUserCellStyle.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserCellStyle.h"
#import "XXUserInfoCellStyle.h"

#define XXFloatNumber(x) [NSNumber numberWithFloat:x]
#define XXIntNumber(x)   [NSNumber numberWithInt:x]

@implementation XXUserCellStyle

- (id)init
{
    if (self = [super init]) {
        
        self.emojiDes = [[XXImageDescription alloc]init];
        self.sexTagDes = [[XXImageDescription alloc]init];
        self.userNameDes = [[XXFontStyleDescription alloc]init];
        self.collegeDes = [[XXFontStyleDescription alloc]init];
        self.starscoreDes = [[XXFontStyleDescription alloc]init];
        self.scoreDes = [[XXFontStyleDescription alloc]init];
        self.profileDes = [[XXFontStyleDescription alloc]init];
        
    }
    return self;
}

+ (XXUserCellStyle*)userCellStyle
{
    XXUserCellStyle *userStyle = [[XXUserCellStyle alloc]init];

    userStyle.emojiDes.width = [XXUserInfoCellStyle emojiSize];
    userStyle.emojiDes.height = [XXUserInfoCellStyle emojiSize];
    userStyle.sexTagDes.width = [XXUserInfoCellStyle sexTagWidth];
    userStyle.sexTagDes.height = [XXUserInfoCellStyle sexTagHeight];
    
    //username
    userStyle.userNameDes.fontSize = [XXUserInfoCellStyle userNameContentFontSize];
    userStyle.userNameDes.lineHeight = [XXUserInfoCellStyle userNameContentLineHeight];
    userStyle.userNameDes.fontColor = [XXUserInfoCellStyle userNameContentTextColor];
    userStyle.userNameDes.fontAlign = [XXUserInfoCellStyle userNameContentTextAlign];
    userStyle.userNameDes.fontWeight = [XXUserInfoCellStyle userNameContentFontWeight];
    userStyle.userNameDes.fontFamily = [XXUserInfoCellStyle userNameContentFontFamily];
    
    //college
    userStyle.collegeDes.fontSize = [XXUserInfoCellStyle collegeContentFontSize];
    userStyle.collegeDes.lineHeight = [XXUserInfoCellStyle collegeContentLineHeight];
    userStyle.collegeDes.fontColor = [XXUserInfoCellStyle collegeContentTextColor];
    userStyle.collegeDes.fontAlign = [XXUserInfoCellStyle collegeContentTextAlign];
    userStyle.collegeDes.fontWeight = [XXUserInfoCellStyle collegeContentFontWeight];
    userStyle.collegeDes.fontFamily = [XXUserInfoCellStyle collegeContentFontFamily];
    
    //starscore
    userStyle.starscoreDes.fontSize = [XXUserInfoCellStyle starscoreContentFontSize];
    userStyle.starscoreDes.lineHeight = [XXUserInfoCellStyle starscoreContentLineHeight];
    userStyle.starscoreDes.fontColor = [XXUserInfoCellStyle starscoreContentTextColor];
    userStyle.starscoreDes.fontAlign = [XXUserInfoCellStyle starscoreContentTextAlign];
    userStyle.starscoreDes.fontWeight = [XXUserInfoCellStyle starscoreContentFontWeight];
    userStyle.starscoreDes.fontFamily = [XXUserInfoCellStyle starscoreContentFontFamily];
    
    //score
    userStyle.scoreDes.lineHeight = [XXUserInfoCellStyle scoreContentLineHeight];
    userStyle.scoreDes.fontSize = [XXUserInfoCellStyle scoreContentFontSize];
    userStyle.scoreDes.fontColor = [XXUserInfoCellStyle scoreContentTextColor];
    userStyle.scoreDes.fontAlign = [XXUserInfoCellStyle scoreContentTextAlign];
    userStyle.scoreDes.fontWeight = [XXUserInfoCellStyle scoreContentFontWeight];
    userStyle.scoreDes.fontFamily = [XXUserInfoCellStyle scoreContentFontFamily];
    
    //profile
    userStyle.profileDes.lineHeight = [XXUserInfoCellStyle profileContentLineHeight];
    userStyle.profileDes.fontSize = [XXUserInfoCellStyle profileContentFontSize];
    userStyle.profileDes.fontColor = [XXUserInfoCellStyle profileContentTextColor];
    userStyle.profileDes.fontAlign = [XXUserInfoCellStyle profileContentTextAlign];
    userStyle.profileDes.fontWeight = [XXUserInfoCellStyle profileContentFontWeight];
    userStyle.profileDes.fontFamily = [XXUserInfoCellStyle profileContentFontFamily];
    
    
    return userStyle;
    
}

@end
