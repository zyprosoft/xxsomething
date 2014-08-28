//
//  XXChatCacheCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-26.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatCacheCenter.h"

#define XXChatMessageCacheDirectory @"xxchat_message_cache"
#define XXChatMessageDataBase       @"xxchat_db"

//conversation_id标示对话的id，用谈话对象的id和自己的id加下划线组成，这个是唯一的  别人的Id_自己的Id
#define XXChatMessageTableCreate @"create table xxchat_table(ID INTEGER PRIMARY KEY autoincrement ,send_user_id text,status text,send_user text,add_time text,audio_time text,body_content text,message_type text,is_readed text,message_id text,conversation_id text,content text)"

#define XXChatContactTableCreate @"create table xxchat_contact(ID INTEGER PRIMARY KEY autoincrement,user_id text,nickname text,grade text,college text,school_roll text,sex text,school_name text,star text,own_user text)"

static dispatch_queue_t XXChatCacheCenterQueue = nil;

@implementation XXChatCacheCenter
- (id)init
{
    if (self = [super init]) {
        _innerCacheDict = [[NSMutableDictionary alloc]init];
        _innerGlobalNewMessagesDict = [[NSMutableDictionary alloc]init];
        _msgNewCountCacheDict = [[NSMutableDictionary alloc]init];
        XXChatCacheCenterQueue = dispatch_queue_create("com.zyprosoft.chatQueue", NULL);
        [self openDataBase];
        [self observeAllNewMessages];
        [self readLatestMessageListToCacheDict];
    }
    return self;
}
+ (XXChatCacheCenter*)shareCenter
{
    static XXChatCacheCenter *_chatCache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_chatCache) {
            _chatCache = [[XXChatCacheCenter alloc]init];
        }
    });
    return _chatCache;
}
- (void)dealloc{
    [[ZYXMPPClient shareClient]removeMsgActionForReciever:self];
    [_innerDataBase close];
}
- (void)openDataBase
{
    NSArray *rootPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *rootPath = [rootPaths lastObject];
    NSString *chatDBDir = [rootPath stringByAppendingPathComponent:XXChatMessageCacheDirectory];
    BOOL isDir = YES;
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDBDir isDirectory:&isDir]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:chatDBDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *chatDB = [chatDBDir stringByAppendingPathComponent:XXChatMessageDataBase];
    DDLogVerbose(@"chatDB:%@",chatDB);
    if (![[NSFileManager defaultManager]fileExistsAtPath:chatDB]) {
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
        NSError *createTableError = nil;
        [_innerDataBase update:XXChatMessageTableCreate withErrorAndBindings:&createTableError];
        if (createTableError) {
            DDLogVerbose(@"create table error:%@",createTableError);
        }else{
            DDLogVerbose(@"create chat table success");
        }
        //contact table
        NSError *createContactError = nil;
        [_innerDataBase update:XXChatContactTableCreate withErrorAndBindings:&createContactError];
        if (createContactError) {
            DDLogVerbose(@"create contact table error:%@",createContactError);
        }else{
            DDLogVerbose(@"create contact table success");
        }
    }else{
        _innerDataBase = [[FMDatabase alloc]initWithPath:chatDB];
        [_innerDataBase open];
    }
    
}

#pragma mark - contact
- (void)saveContactUser:(XXUserModel*)contactUser
{
    //if need save contact user
    NSString *queryUser = [NSString stringWithFormat:@"select nickname from xxchat_contact where user_id = '%@' and own_user='%@' ",contactUser.userId,[XXUserDataCenter currentLoginUser].userId];
    FMResultSet *resultSet = [_innerDataBase executeQuery:queryUser];
    if ([resultSet next]) {
        DDLogVerbose(@"contact user exist");
        return;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into xxchat_contact(user_id,nickname,sex,school_name,own_user)values('%@','%@','%@','%@','%@')",contactUser.userId,contactUser.nickName,contactUser.sex,contactUser.schoolName,[XXUserDataCenter currentLoginUser].userId];
    NSError *saveUserError = nil;
    [_innerDataBase update:insertSql withErrorAndBindings:&saveUserError];
    if (saveUserError) {
        DDLogVerbose(@"save new contact user error:%@",saveUserError);
    }
}
- (BOOL)checkContactUserExist:(XXUserModel *)contactUser
{
    NSString *queryUser = [NSString stringWithFormat:@"select nickname from xxchat_contact where user_id = '%@' and own_user='%@' ",contactUser.userId,[XXUserDataCenter currentLoginUser].userId];
    FMResultSet *resultSet = [_innerDataBase executeQuery:queryUser];
    if ([resultSet next]) {
        DDLogVerbose(@"contact user exist");
        return YES;
    }else{
        return NO;
    }
}
- (void)readLatestMessageListToCacheDict
{
    //有多少位联系人
    NSString *checkQuery = [NSString stringWithFormat:@"select * from xxchat_contact where own_user='%@'",[XXUserDataCenter currentLoginUser].userId];
    DDLogVerbose(@"find contact Usersql:%@",checkQuery);
    FMResultSet *s = [_innerDataBase executeQuery:checkQuery];
    NSMutableArray *resultList = [NSMutableArray array];
    DDLogVerbose(@"contact set:%@",s);
    while ([s next]) {
        
        NSString *contactUserId = [s stringForColumn:@"user_id"];
        DDLogVerbose(@"find a contactUser:%@",contactUserId);
        NSString *querySql = [NSString stringWithFormat:@"select xxchat_table.*,xxchat_contact.* from xxchat_table inner join xxchat_contact on xxchat_table.send_user_id = xxchat_contact.user_id where send_user_id = '%@' order by add_time DESC limit 1",contactUserId];
        DDLogVerbose(@"inner query :%@",querySql);
        
        FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
        DDLogVerbose(@"result message set:%@",resultSet);
        while ([resultSet next]) {
            
            ZYXMPPMessage *existMsg = [[ZYXMPPMessage alloc]init];
            existMsg.messageId = [resultSet stringForColumn:@"message_id"];
            existMsg.conversationId = [resultSet stringForColumn:@"conversation_id"];
            existMsg.userId = [resultSet stringForColumn:@"send_user_id"];
            existMsg.user = [resultSet stringForColumn:@"send_user"];
            existMsg.sendStatus = [resultSet stringForColumn:@"status"];
            existMsg.addTime = [resultSet stringForColumn:@"add_time"];
            existMsg.audioTime = [resultSet stringForColumn:@"audio_time"];
            existMsg.messageType = [resultSet stringForColumn:@"message_type"];
            existMsg.isReaded = [resultSet stringForColumn:@"is_readed"];
            existMsg.content = [resultSet stringForColumn:@"content"];
            existMsg.sendUserSex = [resultSet stringForColumn:@"sex"];
            existMsg.sendUserSchoolName = [resultSet stringForColumn:@"school_name"];
            existMsg.friendAddTime = [XXCommonUitil getTimeStrWithDateString:existMsg.addTime];
            existMsg.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:existMsg];
            existMsg.userHeadAttributedString = [ZYXMPPMessage userHeadAttributedStringWithMessage:existMsg];
            
            [resultList addObject:existMsg];
            DDLogVerbose(@"read existMsg :%@",existMsg.addTime);
            [_innerGlobalNewMessagesDict setObject:existMsg forKey:existMsg.conversationId];
        }
    }
    
    
}
- (NSArray*)getLatestMessageList
{
    NSMutableArray *resultArray = [NSMutableArray array];
    [_innerGlobalNewMessagesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        [resultArray addObject:obj];
        
    }];
    return resultArray;
}
- (NSInteger)findConversationIndexFromLatesMessageListById:(NSString *)conversationId
{
    NSMutableArray *resultArray = [NSMutableArray array];
    __block NSInteger findIndex = -1;
    __block NSInteger index = 0;
    [_innerGlobalNewMessagesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        index++;
        [resultArray addObject:obj];
        if ([(NSString *)key isEqualToString:conversationId]) {
            findIndex = index;
            *stop = YES;
        }
    }];
    return findIndex;
}

- (void)saveMessage:(ZYXMPPMessage*)newMessage
{
    NSString *checkExist = [NSString stringWithFormat:@"select status from xxchat_table where add_time = '%@'",newMessage.addTime];
    FMResultSet *checkResult = [_innerDataBase executeQuery:checkExist];
    if ([checkResult next]) {
        return;
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"insert into xxchat_table(send_user_id,status,send_user,add_time,audio_time,body_content,message_type,is_readed,message_id,conversation_id,content)values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",newMessage.userId,newMessage.sendStatus,newMessage.user,newMessage.addTime,newMessage.audioTime,newMessage.messageAttributedContent,newMessage.messageType,newMessage.isReaded,newMessage.messageId,newMessage.conversationId,newMessage.content];
    
    NSError *saveMessageError = nil;
    BOOL saveResult = [_innerDataBase update:insertSql withErrorAndBindings:&saveMessageError];
    DDLogVerbose(@"save message :%@ result:%d",newMessage.messageId,saveResult);
    if (saveMessageError) {
        DDLogVerbose(@"save message error:%@",saveMessageError);
    }
}

- (void)saveSomeMessages:(NSArray*)messages
{
    [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZYXMPPMessage *aMsg = (ZYXMPPMessage*)obj;
        [self saveMessage:aMsg];
    }];
}

- (void)updateMessageSendStatusWithMessageId:(NSString *)messageId
{
    dispatch_async(XXChatCacheCenterQueue, ^{
        NSString *updateSql = [NSString stringWithFormat:@"update xxchat_table set status = '1' where message_id='%@'",messageId];
        NSError *updateMsgError = nil;
        BOOL updateResult = [_innerDataBase update:updateSql withErrorAndBindings:&updateMsgError];
        DDLogVerbose(@"update message:%@ result:%d",messageId,updateResult);
        if (updateMsgError) {
            DDLogVerbose(@"update message:%@ error:%@",messageId,updateMsgError);
        }
    });
}

- (void)getCacheMessagesWithCondition:(XXConditionModel*)condition withFinish:(void (^)(NSArray *))finish
{
    if (!condition.userId||!condition.toUserId) {
        DDLogVerbose(@"query cache message need two user id to find conversation");
        if (finish) {
            finish(nil);
        }
        return;
    }
    
    NSString *currenUserId = [XXUserDataCenter currentLoginUser].userId;
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
    
    NSString *querySql = [NSString stringWithFormat:@"select * from xxchat_table where conversation_id='%@' order by id DESC limit %d,%d ",conversationId,[condition.pageIndex intValue],[condition.pageSize intValue]];
    
    DDLogVerbose(@"query cache messages sql --->%@",querySql);
    NSMutableArray *modelArray = [NSMutableArray array];
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    while ([resultSet next]) {
        
        ZYXMPPMessage *existMsg = [[ZYXMPPMessage alloc]init];
        existMsg.messageId = [resultSet stringForColumn:@"message_id"];
        existMsg.conversationId = [resultSet stringForColumn:@"conversation_id"];
        existMsg.userId = [resultSet stringForColumn:@"send_user_id"];
        existMsg.user = [resultSet stringForColumn:@"send_user"];
        existMsg.sendStatus = [resultSet stringForColumn:@"status"];
        existMsg.addTime = [resultSet stringForColumn:@"add_time"];
        existMsg.audioTime = [resultSet stringForColumn:@"audio_time"];
        existMsg.messageType = [resultSet stringForColumn:@"message_type"];
        existMsg.isReaded = [resultSet stringForColumn:@"is_readed"];
        existMsg.content = [resultSet stringForColumn:@"content"];
        existMsg.friendAddTime = [XXCommonUitil getTimeStrWithDateString:existMsg.addTime];
        existMsg.isFromSelf = [[resultSet stringForColumn:@"send_user_id"]isEqualToString:currenUserId];
        existMsg.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:existMsg];
        
        [modelArray insertObject:existMsg atIndex:0];
    }
    if (finish) {
        finish(modelArray);
    }

}

- (void)getUnReadMessagesWithCondition:(XXConditionModel *)condition withFinish:(void (^)(NSArray *))finish
{
    if (!condition.userId||!condition.toUserId) {
        DDLogVerbose(@"query cache unread message need two user id to find conversation");
        if (finish) {
            finish(nil);
        }
        return;
    }
    NSString *currenUserId = [XXUserDataCenter currentLoginUser].userId;
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
    NSString *querySql = [NSString stringWithFormat:@"select * from xxchat_table where conversation_id='%@' and is_readed = '0' order by add_time DESC",conversationId];
    
    DDLogVerbose(@"query unread messages sql --->%@",querySql);
    NSMutableArray *modelArray = [NSMutableArray array];
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    while ([resultSet next]) {
        
        ZYXMPPMessage *existMsg = [[ZYXMPPMessage alloc]init];
        existMsg.messageId = [resultSet stringForColumn:@"message_id"];
        existMsg.messageAttributedContent = [[NSAttributedString alloc]initWithString:[resultSet stringForColumn:@"body_content"]];
        existMsg.conversationId = [resultSet stringForColumn:@"conversation_id"];
        existMsg.userId = [resultSet stringForColumn:@"send_user_id"];
        existMsg.user = [resultSet stringForColumn:@"send_user"];
        existMsg.sendStatus = [resultSet stringForColumn:@"status"];
        existMsg.addTime = [resultSet stringForColumn:@"add_time"];
        existMsg.audioTime = [resultSet stringForColumn:@"audio_time"];
        existMsg.messageType = [resultSet stringForColumn:@"message_type"];
        existMsg.isReaded = [resultSet stringForColumn:@"is_readed"];
        existMsg.content = [resultSet stringForColumn:@"content"];
        existMsg.friendAddTime = [XXCommonUitil getTimeStrWithDateString:existMsg.addTime];
        existMsg.isFromSelf = [[resultSet stringForColumn:@"send_user_id"]isEqualToString:currenUserId];
        
        [modelArray addObject:existMsg];
    }
    if (finish) {
        finish(modelArray);
    }

}

//=============  内存的缓存  ========//
- (void)saveMessageForCacheDict:(ZYXMPPMessage *)newMessage
{
    NSMutableArray *newConversation = nil;
    if (![_innerCacheDict objectForKey:newMessage.conversationId]) {
        newConversation = [NSMutableArray array];
    }else{
        newConversation = [_innerCacheDict objectForKey:newMessage.conversationId];
    }  
    [newConversation addObject:newMessage];
    [_innerCacheDict setObject:newConversation forKey:newMessage.conversationId];
    DDLogVerbose(@"cache dict save message success:%@",newMessage.audioTime);
}
- (void)saveSomeMessagesForCacheDict:(NSArray *)messages
{
    dispatch_async(XXChatCacheCenterQueue, ^{
        [messages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ZYXMPPMessage *message = (ZYXMPPMessage*)obj;
            [self saveMessageForCacheDict:message];
        }];
    });
}
- (void)updateMessageSendStatusWithMessageIdForCacheDict:(NSString *)messageId
{
    dispatch_async(XXChatCacheCenterQueue, ^{
        [_innerCacheDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSArray *eachConversation = (NSArray*)obj;
            __block BOOL findMessage = NO;
            [eachConversation enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ZYXMPPMessage *eachMessage = (ZYXMPPMessage*)obj;
                if ([eachMessage.messageId isEqualToString:messageId]) {
                    eachMessage.sendStatus = @"1";
                    DDLogVerbose(@"update message in cache dict:%@",messageId);
                    [_innerCacheDict setObject:eachConversation forKey:eachMessage.conversationId];
                    findMessage = YES;
                    *stop = YES;
                }
            }];
            *stop = findMessage;
        }];
    });
}
- (void)persistMessagesWithCondition:(XXConditionModel *)condition
{
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
    NSMutableArray *conversationMessages = [_innerCacheDict objectForKey:conversationId];
    DDLogVerbose(@"will persist conversation:%@",conversationMessages);
    [self saveSomeMessages:conversationMessages];
    
    [self performSelector:@selector(removeCacheDictMessagesForCoversation:) withObject:condition afterDelay:0.1f];
    
}
- (void)persistConversationWithOtherUserId:(NSString*)otherUserId withMyUserId:(NSString*)myUserId
{
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:otherUserId withMyUserId:myUserId];
    NSMutableArray *conversationMessages = [_innerCacheDict objectForKey:conversationId];
    DDLogVerbose(@"will persist conversation:%@",conversationMessages);
    [self saveSomeMessages:conversationMessages];
    
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.toUserId = otherUserId;
    condition.userId = myUserId;
    [self performSelector:@selector(removeCacheDictMessagesForCoversation:) withObject:condition afterDelay:0.1f];
    
}
- (void)persistAllConversationNow
{
    [_innerGlobalNewMessagesDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
       
        NSArray *sepratorConversationArr = [(NSString*)key componentsSeparatedByString:@"_"];
        [self persistConversationWithOtherUserId:[sepratorConversationArr objectAtIndex:0] withMyUserId:[sepratorConversationArr objectAtIndex:1]];
    }];
}

- (NSArray*)messagesFromCacheDictForConversationCondition:(XXConditionModel *)condition
{
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
    NSMutableArray *conversationMessages = [_innerCacheDict objectForKey:conversationId];
    return conversationMessages;
}
- (void)removeCacheDictMessagesForCoversation:(XXConditionModel *)condition
{
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
    [_innerCacheDict removeObjectForKey:conversationId];
}
- (void)readCacheMsgToDictForCondition:(XXConditionModel *)condition withFinish:(void (^)(NSArray *messages))finish
{
    [self getCacheMessagesWithCondition:condition withFinish:^(NSArray *resultArray) {
       
        if (resultArray) {
            DDLogVerbose(@"find cache Msgs:%@",resultArray);
            NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:condition.toUserId withMyUserId:condition.userId];
            DDLogVerbose(@"find converstion id:%@",conversationId);
            NSMutableArray *conversationMsgs = [NSMutableArray arrayWithArray:resultArray];
            [_innerCacheDict setObject:conversationMsgs forKey:conversationId];
            
            if (conversationMsgs) {
                if (finish) {
                    finish(conversationMsgs);
                }
            }
        }
    }];
}


#pragma mark - observe newest message
- (void)setHappeningConversation:(XXConditionModel *)condition
{
    _happeningCoversationCondition.userId = condition.userId;
    _happeningCoversationCondition.toUserId = condition.toUserId;
}
- (void)clearHappeningConversation
{
    _happeningCoversationCondition.userId = @"";
    _happeningCoversationCondition.toUserId = @"";
}

- (void)observeAllNewMessages
{
    [[ZYXMPPClient shareClient]setDidRecievedMessage:^(ZYXMPPMessage *newMessage) {
        
        //是不是第一次收到这个人的消息
        XXUserModel *newUser = [[XXUserModel alloc]init];
        newUser.userId = newMessage.userId;
        newUser.sex = newMessage.sendUserSex;
        newUser.schoolName = newMessage.sendUserSchoolName;
        newMessage.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:newMessage];
        [[XXChatCacheCenter shareCenter]saveContactUser:newUser];
        
        //是否在聊天
        if ([newMessage.conversationId isEqualToString:[ZYXMPPMessage conversationIdWithOtherUserId:_happeningCoversationCondition.toUserId withMyUserId:_happeningCoversationCondition.userId]]) {
            newMessage.isReaded = @"1";
        }else{
            newMessage.isReaded = @"0";
        }
        [self saveMessage:newMessage];//保存消息

        //保存最新的一条聊天信息，并且添加联系人信息
        if (![newMessage.conversationId isEqualToString:[ZYXMPPMessage conversationIdWithOtherUserId:_happeningCoversationCondition.toUserId withMyUserId:_happeningCoversationCondition.userId]]) {
            if (![_msgNewCountCacheDict objectForKey:newMessage.conversationId]) {
                [_msgNewCountCacheDict setObject:@"1" forKey:newMessage.conversationId];
            }else{
                
                NSInteger oldNewMsgCount = [[_msgNewCountCacheDict objectForKey:newMessage.conversationId]intValue];
                NSString *newMsgCount = [NSString stringWithFormat:@"%d",oldNewMsgCount+1];
                [_msgNewCountCacheDict setObject:newMsgCount forKey:newMessage.conversationId];
            }
            _currentUnReadMsgCount++;
        }else{
            [_msgNewCountCacheDict setObject:@"0" forKey:newMessage.conversationId];
        }
        
        [_innerGlobalNewMessagesDict setObject:newMessage forKey:newMessage.conversationId];
        [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasRecievedNewMsgNoti object:newMessage.conversationId];
        [[XXCommonUitil appMainTabController]showMsgRemind];//remind
        
    } forReciever:self];
}

- (NSString*)getConversationNewMsgCount:(NSString *)conversationId
{
    return [_msgNewCountCacheDict objectForKey:conversationId];
}
- (void)setConvesationNewMsgHasRead:(NSString *)conversationId
{
    [_msgNewCountCacheDict setObject:@"0" forKey:conversationId];
}

- (XXUserModel*)getContactUserInfoWithUserId:(NSString *)userId
{
    NSString *querySql = [NSString stringWithFormat:@"select * from xxchat_contact where user_id = '%@'",userId];
    FMResultSet *resultSet = [_innerDataBase executeQuery:querySql];
    
    if (resultSet) {
        
        XXUserModel *contactUser = [[XXUserModel alloc]init];
        contactUser.userId = [resultSet stringForColumn:@"user_id"];
        contactUser.sex = [resultSet stringForColumn:@"send_user_sex"];
        contactUser.schoolName = [resultSet stringForColumn:@"send_user_school_name"];
        
        return contactUser;
        
    }else{
        return nil;
    }
}
- (NSInteger)getTotalUnReadMsgCount
{
    return _currentUnReadMsgCount;
}
- (void)reduceUnReadMessgeCount:(NSInteger)hasReadCount
{
    _currentUnReadMsgCount = _currentUnReadMsgCount -hasReadCount;
}
- (NSInteger)getUnReadMessagesCountByConversationId:(NSString *)conversationId
{
    return [[_msgNewCountCacheDict objectForKey:conversationId]intValue];
}
- (void)clearLastUserDataNow
{
    [_innerCacheDict removeAllObjects];
    [_innerGlobalNewMessagesDict removeAllObjects];
    [_msgNewCountCacheDict removeAllObjects];
}

//delete conversation
- (BOOL)deleteConversationByUserId:(NSString*)otherUserId
{
    //delete contact 
    NSString *deleteContactUser = [NSString stringWithFormat:@"delete from xxchat_contact where user_id = '%@' and own_user='%@'",otherUserId,[XXUserDataCenter currentLoginUser].userId];
    
    NSString *conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:otherUserId withMyUserId:[XXUserDataCenter currentLoginUser].userId];
    
    [_innerGlobalNewMessagesDict removeObjectForKey:conversationId];
    [_msgNewCountCacheDict removeObjectForKey:conversationId];
    XXConditionModel *condition = [[XXConditionModel alloc]init];
    condition.userId = [XXUserDataCenter currentLoginUser].userId;
    condition.toUserId = otherUserId;
    [self persistMessagesWithCondition:condition];
    
    NSError *deleteUserError = nil;
    [_innerDataBase update:deleteContactUser withErrorAndBindings:&deleteUserError];
    if (deleteUserError) {
        return NO;
    }else{
        return YES;
    }
}

@end
