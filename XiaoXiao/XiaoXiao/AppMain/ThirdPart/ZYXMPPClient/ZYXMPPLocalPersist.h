//
//  ZYXMPPLocalPersist.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-29.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYXMPPRoomConfig.h"
#import "FMDatabase.h"
#import "ZYXMPPUser.h"

@interface ZYXMPPLocalPersist : NSObject
{
    FMDatabase *_innerDataBase;
}
+ (ZYXMPPLocalPersist*)sharePersist;

- (void)saveNewLocalRoomWithConfigure:(ZYXMPPRoomConfig*)newRoomConfig;

- (void)saveOthersRoomWithRoomID:(NSString*)roomID;

//需要则返回roomConfig 需要返回nil
- (ZYXMPPRoomConfig*)checkIfNeedReFecthRoomConfigForRoomID:(NSString*)roomID;

//更新状态
- (void)updateRoomReconfigState:(BOOL)state forRoom:(NSString*)roomID;

- (NSString *)getRoomNameByRoomID:(NSString*)roomID;
- (NSString *)getRoomSubjectByRoomID:(NSString*)roomID;

//用于退群用
- (void)deleteRoomInfoWithRoomID:(NSString*)roomID;
- (NSString *)findMyNickNameInRoom:(NSString*)roomID;

//获取某个聊天室缓存的本地群员
- (NSArray*)getRoomAllUsersWithRoomID:(NSString*)roomID;
- (void)saveUsers:(NSArray*)users;

@end
