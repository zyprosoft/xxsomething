//
//  XXTeaseModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXTeaseModel.h"

@implementation XXTeaseModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        //默认值
        self.teaseTime = @"";
        self.teaseId = @"";
        self.userId = @"";
        self.toUserId = @"";
        self.postEmoji = @"";
        self.nickName = @"";
        self.friendTeaseTime = @"";
        self.grade = @"  ";

        self.teaseTime = [contentDict objectForKey:@"add_time"];
        self.friendTeaseTime = [XXCommonUitil getTimeStrWithDateString:self.teaseTime];
        self.teaseId = [contentDict objectForKey:@"id"];
        self.userId = [contentDict objectForKey:@"user_id"];
        self.toUserId = [contentDict objectForKey:@"to_user_id"];
        self.nickName = [[contentDict objectForKey:@"user"]objectForKey:@"nickname"];
        self.grade = [[contentDict objectForKey:@"user"]objectForKey:@"grade"];
        self.schoolName = [[contentDict objectForKey:@"user"]objectForKey:@"school_name"];
        self.sex = [[contentDict objectForKey:@"user"]objectForKey:@"sex"];
        self.sendFromUser = [[XXUserModel alloc]initWithContentDict:[contentDict objectForKey:@"user"]];
        
        //解析内容字段
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[[contentDict objectForKey:@"content"]dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        self.postEmoji = [contentDict objectForKey:@"content"];
        DDLogVerbose(@"tease emoji:%@",self.postEmoji);
        self.userHeadContent = [XXSharePostUserView  useHeadAttributedStringWithTeaseModel:self];
        
        
    }
    return self;
}

@end
