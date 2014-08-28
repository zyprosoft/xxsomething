//
//  XXChatCacheCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-26.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ZYXMPPMessage.h"

@interface XXChatCacheCenter : NSObject
{
    FMDatabase *_innerDataBase;
    
    //内存缓存
    NSMutableDictionary *_innerCacheDict;
    NSMutableDictionary *_innerGlobalNewMessagesDict;
    NSMutableDictionary *_msgNewCountCacheDict;
    NSInteger            _currentUnReadMsgCount;
    XXConditionModel    *_happeningCoversationCondition;//正在聊天的对话
    
}
+ (XXChatCacheCenter*)shareCenter;
- (NSArray*)messagesFromCacheDictForConversationCondition:(XXConditionModel*)condition;
- (void)readCacheMsgToDictForCondition:(XXConditionModel*)condition withFinish:(void(^)(NSArray *messages))finish;//加入到内存缓存中
- (void)removeCacheDictMessagesForCoversation:(XXConditionModel*)condition;
- (XXUserModel*)getContactUserInfoWithUserId:(NSString*)userId;
- (void)readLatestMessageListToCacheDict;//获取与所有用户的最近的消息列表
- (NSArray*)getLatestMessageList;
- (NSInteger)findConversationIndexFromLatesMessageListById:(NSString*)
conversationId;
- (NSString*)getConversationNewMsgCount:(NSString*)conversationId;
- (void)setConvesationNewMsgHasRead:(NSString*)conversationId;

- (void)saveContactUser:(XXUserModel*)contactUser;
- (BOOL)checkContactUserExist:(XXUserModel*)contactUser;

- (void)saveMessage:(ZYXMPPMessage*)newMessage;
- (void)saveSomeMessages:(NSArray*)messages;
- (void)updateMessageSendStatusWithMessageId:(NSString*)messageId;
- (void)getCacheMessagesWithCondition:(XXConditionModel*)condition withFinish:(void(^)(NSArray*resultArray))finish;
- (void)getUnReadMessagesWithCondition:(XXConditionModel*)condition withFinish:(void(^)(NSArray*resultArray))finish;

- (void)setHappeningConversation:(XXConditionModel*)condition;
- (void)clearHappeningConversation;

//内存运行缓存
- (void)saveMessageForCacheDict:(ZYXMPPMessage*)newMessage;
- (void)saveSomeMessagesForCacheDict:(NSArray*)messages;
- (void)updateMessageSendStatusWithMessageIdForCacheDict:(NSString*)messageId;
- (void)persistMessagesWithCondition:(XXConditionModel*)condition;
- (void)persistAllConversationNow;

- (NSInteger)getTotalUnReadMsgCount;
- (NSInteger)getUnReadMessagesCountByConversationId:(NSString*)conversationId;
- (void)reduceUnReadMessgeCount:(NSInteger)hasReadCount;

//delete conversation
- (BOOL)deleteConversationByUserId:(NSString*)otherUserId;

//切换用户清除上一个人的数据
- (void)clearLastUserDataNow;

@end
