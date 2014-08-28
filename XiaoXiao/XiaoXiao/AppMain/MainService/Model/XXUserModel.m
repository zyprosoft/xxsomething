//
//  XXUserModel.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserModel.h"

@implementation XXUserModel

- (id)initWithContentDict:(NSDictionary *)contentDict
{
    if (self = [super init]) {
        //给个默认值
        self.userId = @"";
        self.account = @"";
        self.password = @"";
        self.nickName = @"未设昵称";
        self.score = @"";
        self.schoolId = @"";
        self.strollSchoolId = @"";
        self.headUrl = @"";
        self.email = @"";
        self.grade = @"";
        self.sex = @"";
        self.birthDay = @"";
        self.signature = @"";
        self.bgImage = @"";
        self.constellation = @"";
        self.postCount = @"";
        self.registTime = @"";
        self.wellknow = @"0";
        self.praiseCount = @"";
        self.tooken = @"";
        self.status = @"";
        self.latitude = @"";
        self.longtitude = @"";
        self.distance = @"";
        self.schoolName = @"";
        self.isInSchool = @"0";
        self.schoolRoll = @"";
        self.college = @"";
        self.type = @"2";
        self.commentCount = @"";
        self.teaseCount = @"";
        self.careMeCount = @"";
        self.meCareCount = @"";
        self.schoolRank = @"";
        self.isCareMe = @"";
        self.isCareYou = @"";
        self.visitCount = @"";
        self.latestDistance = @"";
        self.lastTime = @"";
        self.visitTime = @"";
        self.hasNewPosts = @"0";
        self.isInMyCareList = @"0";
        
        //填充获取的值
        self.userId = [contentDict objectForKey:@"id"];
        self.account = [contentDict objectForKey:@"account"];
        self.password = [contentDict objectForKey:@"password"];
        self.nickName = [contentDict objectForKey:@"nickname"];
        self.score = [contentDict objectForKey:@"score"];
        self.schoolId = [contentDict objectForKey:@"xuexiao_id"];
        self.strollSchoolId = [contentDict objectForKey:@"stroll_xuexiao_id"];
        self.headUrl = [contentDict objectForKey:@"picture"];
        self.email = [contentDict objectForKey:@"email"];
        self.grade = [contentDict objectForKey:@"grade"];
        self.sex = [contentDict objectForKey:@"sex"];
        self.birthDay = [contentDict objectForKey:@"birthday"];
        self.signature = [contentDict objectForKey:@"signature"];
        self.bgImage = [contentDict objectForKey:@"bgimage"];
        self.constellation = [contentDict objectForKey:@"constellation"];
        self.postCount = [contentDict objectForKey:@"posts_count"];
        self.registTime = [contentDict objectForKey:@"reg_time"];
        NSString *wellKonw = [NSString stringWithFormat:@"%@％",[contentDict objectForKey:@"wellknown"]];
        self.wellknow = wellKonw;
        self.praiseCount = [contentDict objectForKey:@"praise_count"];
        self.tooken = [contentDict objectForKey:@"token"];
        self.status = [contentDict objectForKey:@"status"];
        self.latitude = [contentDict objectForKey:@"lat"];
        self.longtitude = [contentDict objectForKey:@"lng"];
        self.schoolName = [contentDict objectForKey:@"school_name"];
        if (self.schoolName==nil||[self.schoolName isEqualToString:@""]) {
            self.schoolName = [[XXCacheCenter shareCenter]returnSchoolNameBySchoolId:self.schoolId];
        }
        self.distance = [contentDict objectForKey:@"MQ_DISTANCE"];
        self.commentCount = [contentDict objectForKey:@"comment_count"];
        self.teaseCount = [contentDict objectForKey:@"tease_count"];
        self.careMeCount = [contentDict objectForKey:@"count_care_me"];
        self.meCareCount = [contentDict objectForKey:@"count_me_care"];
        self.schoolRank = [contentDict objectForKey:@"score_rank"];
        if ([[contentDict objectForKey:@"distance"]intValue]==0) {
            self.latestDistance = @"暂无距离";
        }else{
            self.latestDistance = [contentDict objectForKey:@"distance"];
            NSInteger distanceKm = [self.latestDistance intValue]/1000;
            self.latestDistance = [NSString stringWithFormat:@"%dkm",distanceKm];
        }
        self.lastTime = [contentDict objectForKey:@"last_time"];
        if ([self.lastTime  isEqualToString:@""]||self.lastTime==nil) {
            self.lastTime = @"刚刚";
        }else{
            self.lastTime = [XXCommonUitil getTimeStrWithDateString:self.lastTime];
        }
        
        self.schoolRoll = [contentDict objectForKey:@"schoolroll"];
        self.college = [contentDict objectForKey:@"college"];
        self.type = [contentDict objectForKey:@"type"];
        self.isCareMe = [contentDict objectForKey:@"is_care_me"];
        self.isCareYou = [contentDict objectForKey:@"is_care_you"];
        self.visitCount = [contentDict objectForKey:@"visit_count"];
        self.strollSchoolName = [contentDict objectForKey:@"stroll_school_name"];
        
        if ([contentDict objectForKey:@"visit_time"]) {
            self.visitTime = [XXCommonUitil getTimeStrWithDateString:[contentDict objectForKey:@"visit_time"]];
        }
        if ([contentDict objectForKey:@"has_new_posts"]) {
            self.hasNewPosts = [contentDict objectForKey:@"has_new_posts"];
        }
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init]) {
        
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.schoolId = [aDecoder decodeObjectForKey:@"schoolId"];
        self.strollSchoolId = [aDecoder decodeObjectForKey:@"strollSchoolId"];
        self.headUrl = [aDecoder decodeObjectForKey:@"headUrl"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.grade = [aDecoder decodeObjectForKey:@"grade"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.birthDay = [aDecoder decodeObjectForKey:@"birthDay"];
        self.signature = [aDecoder decodeObjectForKey:@"signature"];
        self.bgImage = [aDecoder decodeObjectForKey:@"bgImage"];
        self.constellation = [aDecoder decodeObjectForKey:@"constellation"];
        self.postCount = [aDecoder decodeObjectForKey:@"postCount"];
        self.registTime = [aDecoder decodeObjectForKey:@"registTime"];
        self.attributedContent = [aDecoder decodeObjectForKey:@"attributedContent"];
        self.wellknow = [aDecoder decodeObjectForKey:@"wellknow"];
        self.praiseCount = [aDecoder decodeObjectForKey:@"praiseCount"];
        self.tooken = [aDecoder decodeObjectForKey:@"tooken"];
        self.status = [aDecoder decodeObjectForKey:@"status"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longtitude = [aDecoder decodeObjectForKey:@"longtitude"];
        self.schoolName = [aDecoder decodeObjectForKey:@"schoolName"];
        self.isUserInfoWell = [aDecoder decodeObjectForKey:@"isUserInfoWell"];
        self.isInSchool = [aDecoder decodeObjectForKey:@"isInSchool"];
        self.commentCount = [aDecoder decodeObjectForKey:@"commentCount"];
        self.teaseCount = [aDecoder decodeObjectForKey:@"teaseCount"];
        self.careMeCount = [aDecoder decodeObjectForKey:@"careMeCount"];
        self.meCareCount = [aDecoder decodeObjectForKey:@"meCareCount"];

        self.schoolRoll = [aDecoder decodeObjectForKey:@"schoolRoll"];
        self.college = [aDecoder decodeObjectForKey:@"college"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.isCareMe = [aDecoder decodeObjectForKey:@"isCareMe"];
        self.isCareYou = [aDecoder decodeObjectForKey:@"isCareYou"];
        self.visitCount = [aDecoder decodeObjectForKey:@"visitCount"];
        
        self.careMeNew = [aDecoder decodeObjectForKey:@"careMeNew"];
        self.meCareNew = [aDecoder decodeObjectForKey:@"meCareNew"];
        self.schoolRank = [aDecoder decodeObjectForKey:@"schoolRank"];
        
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.province = [aDecoder decodeObjectForKey:@"province"];

        self.strollSchoolName = [aDecoder decodeObjectForKey:@"strollSchoolName"];
        
        self.friendHasNewShareCount = [aDecoder decodeObjectForKey:@"friendHasNewShareCount"];
        self.visitUserNewCount = [aDecoder decodeObjectForKey:@"visitUserNewCount"];
        self.commentNewCount = [aDecoder decodeObjectForKey:@"commentNewCount"];
        self.teaseNewCount = [aDecoder decodeObjectForKey:@"teaseNewCount"];

        self.latestDistance = [aDecoder decodeObjectForKey:@"latestDistance"];
        self.lastTime = [aDecoder decodeObjectForKey:@"lastTime"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.account forKey:@"account"];
    [aCoder encodeObject:self.password forKey:@"password"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.schoolId forKey:@"schoolId"];
    [aCoder encodeObject:self.strollSchoolId forKey:@"strollSchoolId"];
    [aCoder encodeObject:self.headUrl forKey:@"headUrl"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.grade forKey:@"grade"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.birthDay forKey:@"birthDay"];
    [aCoder encodeObject:self.signature forKey:@"signature"];
    [aCoder encodeObject:self.bgImage forKey:@"bgImage"];
    [aCoder encodeObject:self.constellation forKey:@"constellation"];
    [aCoder encodeObject:self.postCount forKey:@"postCount"];
    [aCoder encodeObject:self.registTime forKey:@"registTime"];
    [aCoder encodeObject:self.attributedContent forKey:@"attributedContent"];
    [aCoder encodeObject:self.wellknow forKey:@"wellknow"];
    [aCoder encodeObject:self.praiseCount forKey:@"praiseCount"];
    [aCoder encodeObject:self.status forKey:@"status"];
    [aCoder encodeObject:self.tooken forKey:@"tooken"];
    [aCoder encodeObject:self.latitude forKey:@"latitude"];
    [aCoder encodeObject:self.longtitude forKey:@"longtitude"];
    [aCoder encodeObject:self.schoolName forKey:@"schoolName"];
    [aCoder encodeObject:self.isUserInfoWell forKey:@"isUserInfoWell"];
    [aCoder encodeObject:self.isInSchool forKey:@"isInSchool"];
    [aCoder encodeObject:self.schoolRoll forKey:@"schoolRoll"];
    [aCoder encodeObject:self.college forKey:@"college"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.isCareMe forKey:@"isCareMe"];
    [aCoder encodeObject:self.isCareYou forKey:@"isCareYou"];
    [aCoder encodeObject:self.commentCount forKey:@"commentCount"];
    [aCoder encodeObject:self.teaseCount forKey:@"teaseCount"];
    [aCoder encodeObject:self.careMeCount forKey:@"careMeCount"];
    [aCoder encodeObject:self.meCareCount forKey:@"meCareCount"];
    [aCoder encodeObject:self.visitCount forKey:@"visitCount"];

    [aCoder encodeObject:self.careMeNew forKey:@"careMeNew"];
    [aCoder encodeObject:self.meCareNew forKey:@"meCareNew"];
    [aCoder encodeObject:self.schoolRank forKey:@"schoolRank"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.strollSchoolName forKey:@"strollSchoolName"];
    
    [aCoder encodeObject:self.friendHasNewShareCount forKey:@"friendHasNewShareCount"];
    [aCoder encodeObject:self.visitUserNewCount forKey:@"visitUserNewCount"];
    [aCoder encodeObject:self.commentNewCount forKey:@"commentNewCount"];
    [aCoder encodeObject:self.teaseNewCount forKey:@"teaseNewCount"];

    [aCoder encodeObject:self.latestDistance forKey:@"latestDistance"];
    [aCoder encodeObject:self.lastTime forKey:@"lastTime"];
}

@end
