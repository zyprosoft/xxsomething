//
//  XXPraiseModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXPraiseModel.h"

@implementation XXPraiseModel
- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        
        self.paiseTIme = @"";
        self.userId = @"";
        self.nickname = @"";
        
        NSDictionary *userDict = [contentDict objectForKey:@"user"];
        self.userId = [userDict objectForKey:@"id"];
        self.nickname = [userDict objectForKey:@"nickname"];
        self.paiseTIme = [contentDict objectForKey:@"add_time"];
        self.friendlyTime = [XXCommonUitil getTimeStrWithDateString:self.paiseTIme];
        
    }
    return self;
}
@end
