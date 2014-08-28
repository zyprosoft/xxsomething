//
//  ZYXMPPLocalPersist.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-29.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPLocalPersist.h"

#define ZYXMPPLocalPersistDatabaseDirectory @"com.zyprosoft.xmpplocalpersist"
#define ZYXMPPLocalPersistDatabase @"xmpplocalpersist.sqlite"

#define ZYXMPPLocalPersistCreateRoomTable @"create table zy_xmpp_room (room_id text primary key,name text,description text,max_user_count int,need_password_protect int,max_history_messageReturnCount int,enable_logging int,subject text,allow_inivite int,allow_privateMsg int,who_can_broadCastMsg text,owner text,need_persist int,is_public int,who_can_getRoomMemberList text,is_admin_only int,is_memeber_only int,who_can_discoveryOthersJID text,admins text,secret text,reconfig_state int,my_nick_name text)"

#define ZYXMPPLocalPersistInsertRow @"insert into zy_xmpp_room (room_id,name,description,max_user_count,need_password_protect,max_history_messageReturnCount,enable_logging,subject,allow_inivite,allow_privateMsg,who_can_broadCastMsg,owner,need_persist,is_public,who_can_getRoomMemberList,is_admin_only,is_memeber_only,who_can_discoveryOthersJID,admins,secret,reconfig_state,my_nick_name)values('%@','%@','%@',%d,%d,%d,%d,'%@',%d,%d,'%@','%@',%d,%d,'%@',%d,%d,'%@','%@','%@',%d,'%@')"

#define ZYXMPPQueryRow @"select * from zy_xmpp_room where room_id = '%@' and reconfig_state=1"

#define ZYXMPPLocalPersistCreateUserTable @"create table zy_xmpp_user (user_id text primary key,nick_name text,room_id text,status text)"

#define ZYXMPPLocalPersistInsertUserRow @"insert into zy_xmpp_user (user_id,nick_name,room_id,status)values('%@','%@','%@','%@')"

static dispatch_queue_t ZYXMPPLocalPersistQueue = nil;

@implementation ZYXMPPLocalPersist
- (id)init
{
    if (self = [super init]) {
        ZYXMPPLocalPersistQueue = dispatch_queue_create("com.zyprosoft.PersistQueue", NULL);
        [self openDataBase];
    }
    return self;
}

+ (ZYXMPPLocalPersist*)sharePersist
{
    static ZYXMPPLocalPersist *_localPersist = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_localPersist) {
            _localPersist = [[self alloc]init];
        }
    });
    return _localPersist;
}
- (void)dealloc{
    [_innerDataBase close];
}
- (void)openDataBase
{
    NSArray *rootPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *rootPath = [rootPaths lastObject];
    NSString *chatDBDir = [rootPath stringByAppendingPathComponent:ZYXMPPLocalPersistDatabaseDirectory];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDBDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:chatDBDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *chatDB = [chatDBDir stringByAppendingPathComponent:ZYXMPPLocalPersistDatabase];
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDB]) {
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
        NSError *createTableError = nil;
        [_innerDataBase update:ZYXMPPLocalPersistCreateRoomTable withErrorAndBindings:&createTableError];
        [_innerDataBase update:ZYXMPPLocalPersistCreateUserTable withErrorAndBindings:&createTableError];
        if (createTableError) {
            DDLogVerbose(@"create table error:%@",createTableError);
        }
    }else{
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
    }
    
}
- (void)saveNewLocalRoomWithConfigure:(ZYXMPPRoomConfig *)newRoomConfig
{
    dispatch_async(ZYXMPPLocalPersistQueue, ^{
        NSMutableString *adminsArrayToString = [NSMutableString string];
        [newRoomConfig.admins enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *eachAdminString = (NSString*)obj;
            if (idx!=newRoomConfig.admins.count-1) {
                [adminsArrayToString appendFormat:@"%@|",eachAdminString];
            }else{
                [adminsArrayToString appendFormat:@"%@",eachAdminString];
            }
        }];
        
        NSString *insertSql = [NSString stringWithFormat:ZYXMPPLocalPersistInsertRow,newRoomConfig.roomID,newRoomConfig.name,newRoomConfig.description,newRoomConfig.maxUserCount,newRoomConfig.needPasswordProtect,newRoomConfig.maxHistoryMessageReturnCount,newRoomConfig.enableLogging,newRoomConfig.subject,newRoomConfig.allowInivite,newRoomConfig.allowPrivateMsg,newRoomConfig.whoCanBroadCastMsg,newRoomConfig.owner,newRoomConfig.needPersistThisRoom,newRoomConfig.isThisPublicRoom,newRoomConfig.whoCanGetRoomMemberList,newRoomConfig.isRoomForAdminOnly,newRoomConfig.isRoomForMemberOnly,newRoomConfig.whoCanDiscoveryOthersJID,adminsArrayToString,newRoomConfig.secret,newRoomConfig.reconfigState,newRoomConfig.myNickName];
        
        DDLogVerbose(@"will save new room sql:%@",insertSql);
        NSError *saveRoomSqlError = nil;
        BOOL saveNewRoomConfigResult = [_innerDataBase update:insertSql withErrorAndBindings:&saveRoomSqlError];
        if (saveNewRoomConfigResult) {
            DDLogVerbose(@"save new room config success");
        }else{
            DDLogVerbose(@"save room config faild:%@",saveRoomSqlError.description);
        }
    });
}

- (void)updateRoomReconfigState:(BOOL)state forRoom:(NSString*)roomID
{
    dispatch_async(ZYXMPPLocalPersistQueue, ^{
        NSString *updateSql = [NSString stringWithFormat:@"update zy_xmpp_room set reconfig_state = %d where room_id = %@ ",state,roomID];
        NSError *updateConfigError = nil;
        BOOL updateReconfigResult=[_innerDataBase update:updateSql withErrorAndBindings:&updateConfigError];
        if (!updateReconfigResult) {
            DDLogVerbose(@"update Reconfig Result Error:%@",updateConfigError.description);
        }
    });
}

- (ZYXMPPRoomConfig*)checkIfNeedReFecthRoomConfigForRoomID:(NSString *)roomID
{
    NSString *querySql = [NSString stringWithFormat:ZYXMPPQueryRow,roomID];
    
    DDLogVerbose(@"find Config sql++++++:%@",querySql);
    
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    
    ZYXMPPRoomConfig *existConfigure = nil;
    while ([resultSet next]) {
        
        existConfigure = [[ZYXMPPRoomConfig alloc]init];
        
        existConfigure.roomID = [resultSet stringForColumn:@"room_id"];
        existConfigure.name = [resultSet stringForColumn:@"name"];
        existConfigure.description = [resultSet stringForColumn:@"description"];
        existConfigure.maxUserCount = [resultSet intForColumn:@"max_user_count"];
        existConfigure.needPasswordProtect = [resultSet intForColumn:@"need_password_protect"];
        existConfigure.maxHistoryMessageReturnCount = [resultSet intForColumn:@"max_history_messageReturnCount"];
        existConfigure.enableLogging = [resultSet intForColumn:@"enable_logging"];
        existConfigure.subject = [resultSet stringForColumn:@"subject"];
        existConfigure.allowInivite = [resultSet intForColumn:@"allow_inivite"];
        existConfigure.allowPrivateMsg = [resultSet intForColumn:@"allow_privateMsg"];
        existConfigure.whoCanBroadCastMsg = [resultSet stringForColumn:@"who_can_broadCastMsg"];
        existConfigure.owner = [resultSet stringForColumn:@"owner"];
        existConfigure.needPersistThisRoom = [resultSet intForColumn:@"need_persist"];
        existConfigure.isThisPublicRoom = [resultSet intForColumn:@"is_public"];
        existConfigure.whoCanGetRoomMemberList = [resultSet stringForColumn:@"who_can_getRoomMemberList"];
        existConfigure.isRoomForAdminOnly = [resultSet intForColumn:@"is_admin_only"];
        existConfigure.isRoomForMemberOnly = [resultSet intForColumn:@"is_memeber_only"];
        existConfigure.whoCanDiscoveryOthersJID = [resultSet stringForColumn:@"who_can_discoveryOthersJID"];
        existConfigure.secret = [resultSet stringForColumn:@"secret"];
        NSString *adminsString = [resultSet stringForColumn:@"admins"];
        existConfigure.admins = [adminsString componentsSeparatedByString:@"|"];
        existConfigure.reconfigState = [resultSet intForColumn:@"reconfig_state"];
        existConfigure.myNickName = [resultSet stringForColumn:@"my_nick_name"];
        
    }
    
    return existConfigure;
}

- (void)saveOthersRoomWithRoomID:(NSString *)roomID
{
    dispatch_async(ZYXMPPLocalPersistQueue, ^{
        NSString *insertSql = [NSString stringWithFormat:@"insert into zy_xmpp_room (room_id)values('%@')",roomID];
        NSError *saveOtherRoomResultError = nil;
        BOOL saveResult = [_innerDataBase update:insertSql withErrorAndBindings:&saveOtherRoomResultError];
        if (!saveResult) {
            DDLogVerbose(@"save other room result faild:%@",saveOtherRoomResultError.description);
        }else{
            DDLogVerbose(@"join save other room success");
        }
    });
}

- (NSString*)getRoomNameByRoomID:(NSString *)roomID
{
    NSString *querySql = [NSString stringWithFormat:@"select name from zy_xmpp_room where room_id = '%@'",roomID];
    
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    NSString *resultString = nil;
    while ([resultSet next]) {
        
        resultString = [resultSet stringForColumn:@"name"];
    }
    return resultString;
}

- (NSString*)getRoomSubjectByRoomID:(NSString *)roomID
{
    NSString *querySql = [NSString stringWithFormat:@"select subject from zy_xmpp_room where room_id = '%@'",roomID];
    
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    NSString *resultString = nil;
    while ([resultSet next]) {
        
        resultString = [resultSet stringForColumn:@"subject"];
    }
    return resultString;

}
- (void)deleteRoomInfoWithRoomID:(NSString *)roomID
{
    dispatch_async(ZYXMPPLocalPersistQueue, ^{
        NSString *deleteSql = [NSString stringWithFormat:@"delete from zy_xmpp_room where room_id = '%@'",roomID];
        NSError *deleteError = nil;
        BOOL deleteResult = [_innerDataBase update:deleteSql withErrorAndBindings:&deleteError];
        if (!deleteResult) {
            DDLogVerbose(@"delete room info faild:%@",deleteError.description);
        }
    });
    
}
- (NSString*)findMyNickNameInRoom:(NSString *)roomID
{
    NSString *querySql = [NSString stringWithFormat:@"select my_nick_name from zy_xmpp_room where room_id = '%@'",roomID];
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    NSString *resultString  = nil;
    while ([resultSet next]) {
        
        resultString = [resultSet stringForColumn:@"my_nick_name"];
        
    }
    return resultString;
}

//================= 用户
- (void)saveAUser:(ZYXMPPUser*)aUser
{
    dispatch_async(ZYXMPPLocalPersistQueue, ^{
        NSString *insertSql = [NSString stringWithFormat:ZYXMPPLocalPersistInsertUserRow,aUser.jID,aUser.nickName,aUser.roomId,aUser.state];
        NSError *saveAUserError = nil;
        [_innerDataBase update:insertSql withErrorAndBindings:&saveAUserError];
        if (saveAUserError) {
            DDLogVerbose(@"save user error :%@",saveAUserError.description);
        }
    });
    
}
- (void)saveUsers:(NSArray *)users
{
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZYXMPPUser *aUser = (ZYXMPPUser*)obj;
        [self saveAUser:aUser];
    }];
}
@end
