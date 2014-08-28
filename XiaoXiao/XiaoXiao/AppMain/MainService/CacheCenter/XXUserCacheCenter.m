//
//  XXUserCacheCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXUserCacheCenter.h"

#define XXCacheCenterUserDataBase @"xxuser"
#define XXCacheCenterUserDataBaseDirectory @"xx_user_cache"
static dispatch_queue_t XXCacheCenterQueue = nil;

#define XXMyCareUserInfoTableCreate @"create table xxcare_user(ID INTEGER PRIMARY KEY autoincrement ,user_id text,nickname text,praise_count text,posts_count text,tease_count text,comment_count text,visit_count text,is_care_me text,is_care_you text,isPraise text)"

#define XXStrollSchoolTableCreate @"create table xxstroll_school(ID INTEGER PRIMARY KEY autoincrement ,school_id text,school_name text,user_id text)"

@implementation XXUserCacheCenter
- (id)init
{
    if (self = [super init]) {
        XXCacheCenterQueue = dispatch_queue_create("com.zyprosoft.userCacheCenterQueue",NULL);
        [self openDataBase];
    }
    return self;
}
+ (XXUserCacheCenter*)shareCenter
{
    static XXUserCacheCenter *cacheCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheCenter) {
            cacheCenter = [[XXUserCacheCenter alloc]init];
        }
    });
    return cacheCenter;
}
- (void)dealloc{
    [_innerDataBase close];
}
- (NSString*)userDataBaseDir
{
    NSArray *rootPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *rootPath = [rootPaths lastObject];
    NSString *databaseDir = [rootPath stringByAppendingPathComponent:XXCacheCenterUserDataBaseDirectory];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:databaseDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:databaseDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return databaseDir;
}
- (NSString*)userDataBasePath
{
    NSString *databaseDir = [self userDataBaseDir];
    NSString *databaseName = [XXCacheCenterUserDataBase stringByAppendingPathExtension:@"sqlite"];
    NSString *databasePath = [databaseDir stringByAppendingPathComponent:databaseName];
    return databasePath;
}
- (void)openDataBase
{
    NSString *databasePath = [self userDataBasePath];
    _innerDataBase = [[FMDatabase alloc]initWithPath:databasePath];
    [_innerDataBase open];
    [self createStrollSchoolTable];//create table
}
- (void)createUserTable
{
    
}

- (void)saveUser:(XXUserModel*)aUser
{
    
}
- (XXUserModel*)returnUserInfoById:(NSString *)userId
{
    
}

-(void)saveStrolledSchool:(XXSchoolModel *)schoolModel
{
    NSString *checkSql = [NSString stringWithFormat:@"select school_name from xxstroll_school where school_id = '%@'",schoolModel.schoolId];
    
    FMResultSet *resultSet = [_innerDataBase executeQuery:checkSql];
    if ([resultSet next]) {
        DDLogVerbose(@"stroll school has exist");
        return;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into xxstroll_school(school_id,school_name,user_id)values('%@','%@','%@')",schoolModel.schoolId,schoolModel.schoolName,[XXUserDataCenter currentLoginUser].userId];
    NSError *saveUserError = nil;
    [_innerDataBase update:insertSql withErrorAndBindings:&saveUserError];
    if (saveUserError) {
        DDLogVerbose(@"save new stroll school error:%@",saveUserError);
    }

}

- (void)createStrollSchoolTable
{
    NSError *createTableError = nil;
    [_innerDataBase update:XXStrollSchoolTableCreate withErrorAndBindings:&createTableError];
    if (createTableError) {
        DDLogVerbose(@"create contact table error:%@",createTableError);
    }else{
        DDLogVerbose(@"create contact table success");
    }

}

- (void)returnHistoryStrollSchoolWithResult:(void (^)(NSArray *))result
{
    NSString *searchSql = [NSString stringWithFormat:@"select * from xxstroll_school where user_id = '%@'",[XXUserDataCenter currentLoginUser].userId];
    DDLogVerbose(@"search sql -->%@",searchSql);
    NSMutableArray *resultModelArray = [NSMutableArray array];
    
    FMResultSet *resultSet = [_innerDataBase executeQuery:searchSql];
    while ([resultSet next]) {
        
        XXSchoolModel *newSchool = [[XXSchoolModel alloc]init];
        newSchool.schoolId = [resultSet stringForColumn:@"school_id"];
        newSchool.schoolName = [resultSet stringForColumn:@"school_name"];
        [resultModelArray addObject:newSchool];
    }
    if (result) {
        result(resultModelArray);
    }

}

@end
