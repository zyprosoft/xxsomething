//
//  XXCommentModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommentModel.h"

@implementation XXCommentModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //默认值
        self.commentId = @"";
        self.resourceType = @"";
        self.resourceId = @"";
        self.content = @"";
        self.userId = @"";
        self.pCommentId = @"";
        self.rootCommentId = @"";
        self.addTime = @"";
        self.userName = @"";
        self.postContent = @"";
        self.postAudioTime = @"0";
        self.postAudio = @"";
        self.toUserId = @"";
        self.toUserName = @"";

        self.commentId = [contentDict objectForKey:@"id"];
        self.resourceType = [contentDict objectForKey:@"res_type"];
        self.resourceId = [contentDict objectForKey:@"res_id"];
        self.content = [contentDict objectForKey:@"content"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.pCommentId = [contentDict objectForKey:@"p_id"];
        self.rootCommentId = [contentDict objectForKey:@"root_id"];
        self.addTime = [contentDict objectForKey:@"add_time"];
        self.friendAddTime = [XXCommonUitil getTimeStrWithDateString:self.addTime];
        self.addTime = nil;
        self.userName = [[contentDict objectForKey:@"user"]objectForKey:@"nickname"];
        self.sex = [[contentDict objectForKey:@"user"]objectForKey:@"sex"];
        self.schoolName = [[contentDict objectForKey:@"user"]objectForKey:@"school_name"];
        self.grade = [[contentDict objectForKey:@"user"]objectForKey:@"grade"];
        
        //to user
        NSDictionary *toUserDict = [contentDict objectForKey:@"to_user"];
        self.toUserId = [toUserDict objectForKey:@"id"];
        self.toUserName = [toUserDict objectForKey:@"nickname"];
        
        DDLogVerbose(@"user:%@",contentDict);
        //解析content字段
        NSData *contentData = [self.content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *customContentDict = [NSJSONSerialization JSONObjectWithData:contentData options:NSJSONReadingAllowFragments error:nil];
        NSString *audioTime = [customContentDict objectForKey:XXSharePostJSONAudioTime];
        self.postAudioTime = audioTime;
        if ([audioTime isEqualToString:@"0"]) {
            self.postContent = [customContentDict objectForKey:XXSharePostJSONContentKey];
            
            //content style
            XXShareStyle *contentStyle = [[XXShareStyle alloc]init];
            contentStyle.contentFontFamily = @"Hevica";
            contentStyle.contentFontSize = 12.5;
            contentStyle.contentFontWeight = XXFontWeightNormal;
            contentStyle.contentLineHeight = 1.6;
            contentStyle.contentTextAlign = XXTextAlignLeft;
            contentStyle.contentTextColor = [XXCommonStyle commonPostContentTextColor];
            contentStyle.emojiSize = 13;
            
            DDLogVerbose(@"comment content:%@",self.postContent);
            self.contentAttributedString = [XXBaseTextView formatteTextToAttributedText:self.postContent withHtmlTemplateFile:@"xxbase_common_template.html" withCSSTemplate:@"xxbase_comment_style.css" withShareStyle:contentStyle];
            
            
            self.userHeadContent = [XXSharePostUserView useHeadAttributedStringWithCommnetModel:self];
//            self.postContent = nil;
            
        }else{
            self.postContent = @"语音";
            self.postAudio = [customContentDict objectForKey:XXSharePostJSONAudioKey];
        }
        
        
    }
    return self;
}

@end
