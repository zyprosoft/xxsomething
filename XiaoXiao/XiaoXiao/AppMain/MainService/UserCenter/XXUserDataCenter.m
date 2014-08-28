//
//  XXUserDataCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXUserDataCenter.h"

#define XXUserDataCenterSaveUDF @"xxuser_save_udf"

@implementation XXUserDataCenter
+ (NSString*)currentLoginUserToken
{
    if ([XXUserDataCenter currentLoginUser]) {
        return [XXUserDataCenter currentLoginUser].tooken;
    }else{
        return @"";
    }
}
+ (XXUserModel*)currentLoginUser
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        return nil;
    }
    NSMutableArray *userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
//    DDLogVerbose(@"userList :%@",userList);
    __block NSUInteger findUserIndex=9999;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            findUserIndex = idx;
            *stop = YES;
        }
    }];
    if (findUserIndex==9999) {
        DDLogVerbose(@"didn't find login user");
        return nil;
    }
    XXUserModel *aUser = [userList objectAtIndex:findUserIndex];
    DDLogVerbose(@"find currentUser account:%@  token:%@",aUser.account,aUser.tooken);
    return [userList objectAtIndex:findUserIndex];
}
+ (void)currentUserLoginOut
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        return;
    }
    NSArray *userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
    
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.status boolValue]) {
            existUser.status = @"0";
            *stop = YES;
        }
    }];
    NSData *userData = [XXUserDataCenter archiveArray:[NSMutableArray arrayWithArray:userList]];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (void)loginThisUser:(XXUserModel *)aUser
{
    NSMutableArray *userList = nil;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]) {
        userList = [NSMutableArray array];
    }else{
        userList = [XXUserDataCenter unarchiveArray:[[NSUserDefaults standardUserDefaults]objectForKey:XXUserDataCenterSaveUDF]];
    }
    
    __block BOOL findExistUser = NO;
    [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XXUserModel *existUser = (XXUserModel*)obj;
        if ([existUser.userId isEqualToString:aUser.userId]) {
            DDLogVerbose(@"login exist user!");
            existUser.tooken = aUser.tooken;
            existUser.status = @"1";
            existUser.nickName = aUser.nickName;
            existUser.signature = aUser.signature;
            existUser.constellation = aUser.constellation;
            existUser.sex = aUser.sex;
            existUser.grade = aUser.grade;
            existUser.schoolRoll = aUser.schoolRoll;
            existUser.college = aUser.college;
            existUser.strollSchoolId = aUser.strollSchoolId;
            existUser.strollSchoolName = aUser.strollSchoolName;
            existUser.bgImage = aUser.bgImage;
            existUser.type = aUser.type;
            existUser.postCount = aUser.postCount;
            existUser.careMeCount = aUser.careMeCount;
            existUser.schoolName = aUser.schoolName;
            existUser.meCareCount = aUser.meCareCount;
            existUser.praiseCount = aUser.praiseCount;
            existUser.birthDay = aUser.birthDay;
            existUser.lastTime = aUser.lastTime;
            existUser.headUrl = aUser.headUrl;
            existUser.schoolRank = aUser.schoolRank;
            existUser.teaseCount = aUser.teaseCount;
            existUser.visitCount = aUser.visitCount;
            existUser.wellknow = aUser.wellknow;
            existUser.distance = aUser.distance;
            existUser.score = aUser.score;
            existUser.commentNewCount = aUser.commentNewCount;
            existUser.friendHasNewShareCount = aUser.friendHasNewShareCount;
            existUser.visitUserNewCount = aUser.visitUserNewCount;
            existUser.teaseNewCount = aUser.teaseNewCount;
            
            if (existUser.city==nil) {
                existUser.city = [[XXCacheCenter shareCenter]returnUserCityBySchoolId:existUser.schoolId];
            }
            if (existUser.province==nil) {
                existUser.province = [[XXCacheCenter shareCenter]returnUserProvinceBySchoolId:existUser.schoolId];
            }
        
            findExistUser = YES;
        }else{
            existUser.status = @"0";
        }
    }];
    if (!findExistUser) {
        DDLogVerbose(@"add new user!");
        aUser.status=@"1";
        aUser.city = [[XXCacheCenter shareCenter]returnUserCityBySchoolId:aUser.schoolId];
        aUser.province = [[XXCacheCenter shareCenter]returnUserProvinceBySchoolId:aUser.schoolId];
        [userList addObject:aUser];
    }
    DDLogVerbose(@"login user after:%@",userList);
    NSData *userData = [XXUserDataCenter archiveArray:userList];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:XXUserDataCenterSaveUDF];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+ (NSData*)archiveArray:(NSMutableArray*)tempArray
{
   return [NSKeyedArchiver archivedDataWithRootObject:tempArray];
}
+ (NSMutableArray*)unarchiveArray:(NSData*)arrayData
{
   return  (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:arrayData];
}
+ (BOOL)checkLoginUserInfoIsWellDone
{
    XXUserModel *currentUser = [XXUserDataCenter currentLoginUser];
    DDLogVerbose(@"user nick name:%@",currentUser.nickName);
    if ([currentUser.nickName isEqualToString:@""]||currentUser.nickName==nil) {
        return NO;
    }
//    if ([currentUser.signature isEqualToString:@""]) {
//        return NO;
//    }
    DDLogVerbose(@"user constellation:%@",currentUser.constellation);
    if ([currentUser.constellation isEqualToString:@""]||currentUser.constellation==nil) {
        return NO;
    }
    DDLogVerbose(@"user sex:%@",currentUser.sex);
    if ([currentUser.sex isEqualToString:@""]||currentUser.sex==nil) {
        return NO;
    }
    DDLogVerbose(@"user grade:%@",currentUser.grade);
    if ([currentUser.grade isEqualToString:@""]||currentUser.grade==nil) {
        return NO;
    }
//    if ([currentUser.birthDay isEqualToString:@""]) {
//        return NO;
//    }
    DDLogVerbose(@"user type:%@",currentUser.type);
    if ([currentUser.type intValue]==XXUserMiddleSchool||[currentUser.type intValue]==XXUserHighSchool ) {
        if ([currentUser.schoolRoll isEqualToString:@""]||currentUser.schoolRoll==nil) {
            return NO;
        }
    }else{
        DDLogVerbose(@"user college:%@",currentUser.college);
        if ([currentUser.college isEqualToString:@""]||currentUser.college==nil) {
            return NO;
        }
    }
    
    return YES;
}
@end
