//
//  ZYXMPPClient.m
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPClient.h"

@interface ZYXMPPClient()

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

@end

#define kZYXMPPRoom @"kZYXMPPRoom"
#define kZYXMPPRoomStorge @"kZYXMPPRoomStorge"
#define kZYXMPPRoomMembers @"kZYXMPPRoomMembers"
#define ZYXMPPRoomCreateOneRoomFinishedNoti @"ZYXMPPRoomCreateOneRoomFinishedNoti"

static dispatch_queue_t ZYXMPPClientQueue = nil;

@implementation ZYXMPPClient
@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppvCardTempModule;
@synthesize xmppvCardAvatarModule;
@synthesize xmppCapabilities;
@synthesize xmppCapabilitiesStorage;
@synthesize hasConfigedClient;
@synthesize xmppRoom;

#pragma mark - init 
- (id)init
{
    if (self = [super init]) {
        ZYXMPPClientQueue = dispatch_queue_create("com.zyprosoft.clientQueue", NULL);
        _actions = [[NSMutableDictionary alloc]init];
        xmppRooms = [[NSMutableDictionary alloc]init];
        _innerConfigDict = [[NSMutableDictionary alloc]init];
        xmppRoomConfigs = [[NSMutableArray alloc]init];
//        [self initDefaultRoomConfig];
        needBackgroundRecieve = YES;//默认后台接收消息
        // Setup the XMPP stream
        [self setupStream];
    }
    return self;
}

+ (ZYXMPPClient*)shareClient
{
    static ZYXMPPClient *chatClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!chatClient) {
            chatClient = [[ZYXMPPClient alloc]init];
        }
    });
    return chatClient;
}

- (void)dealloc
{
	[self teardownStream];
}

//默认配置
- (void)clientDefaultConfig
{
    [self setNeedAutoJIDWithCustomHostName:YES];
    [self setNeedBackgroundRecieve:YES];
    [self setNeedUseCustomHostAddress:YES];
}
- (NSString*)myChatID
{
    return originJId;
}
- (NSString*)myChatJID
{
    return _jId;
}
- (void)setMyDefaultNickName:(NSString *)nickName
{
    myRoomConfig.myNickName = nickName;
}
- (NSString*)myNickName
{
    return myRoomConfig.myNickName;
}
//是否需要补全JID
- (void)setNeedAutoJIDWithCustomHostName:(BOOL)state
{
    needAutoHostForJID = state;
}
- (void)loginOutCurrentClient
{
    [self goOffline];
    [xmppStream disconnect];
    isXmppConnected = NO;
}

#pragma mark - start client
- (void)startClientWithJID:(NSString *)jidString withPassword:(NSString *)password
{
    if (!_serverHost || !_serverPort) {
        ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
        faildAction(@"host or port is null !");
        return;
    }
    if (!jidString || !password) {
        ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
        faildAction(@"jid or password is null !");
        return;
    }
    
    if (isXmppConnected) {
        return;
    }
    if ([xmppStream isConnected]) {
        return;
    }
    
    _jId = jidString;
    originJId = jidString;
    if (needAutoHostForJID) {
        _jId = [NSString stringWithFormat:@"%@@%@",_jId,_serverHost];
    }
    _password = password;

    myRoomConfig.roomID = [self genrateRoomID];
    myRoomConfig.myNickName = [NSString stringWithFormat:@"%@",originJId];
    myRoomConfig.name = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.description = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.subject = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.owner = _jId;
    
    if (![self connect])
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_actions objectForKey:@"clientStartFaild"]) {
                
                ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
                faildAction(@"client start faild connect server");
            }
        });
		
	}
}
- (void)clientTearDown
{
    [self disconnect];
    [self teardownStream];
}
- (void)setJabbredServerAddress:(NSString *)address
{
    _serverHost = address;
}
- (void)setJabbredServerPort:(NSString *)port
{
    _serverPort = port;
}
- (void)setNeedBackgroundRecieve:(BOOL)needBackground
{
    if (needBackground==needBackgroundRecieve) {
        return;
    }
    needBackgroundRecieve = needBackground;
}
- (BOOL)backgroundActiveEnbaleState
{
    return needBackgroundRecieve;
}
- (void)setNeedUseCustomHostAddress:(BOOL)shouldUse
{
    shouldUseCustomHost = shouldUse;
}
- (void)setStartClientSuccessAction:(ZYXMPPClientStartSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"clientStartSuccess"];
}
- (void)setStartClientFaildAction:(ZYXMPPClientStartFaildAction)faildAction
{
    [_actions setObject:faildAction forKey:@"clientStartFaild"];
}
- (void)setConnectToServerErrorAction:(ZYXMPPClientConnectServerErrorAction)errorAction
{
    [_actions setObject:errorAction forKey:@"connectServerError"];
}
- (void)setSendMessageSuccessAction:(ZYXMPPClientSendMessageSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"sendMessageSuccess"];
}
- (void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction
{
    [_actions setObject:faildAction forKey:@"sendMessageFaild"];
}
- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction
{
    [_actions setObject:recievedAction forKey:@"recieveMessageSuccess"];
}
- (void)setDidSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction
{
    [_actions setObject:successAction forKey:@"didSendMessageSuccess"];
}
- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction forReciever:(id)reciever
{
    NSString *key = [NSString stringWithFormat:@"recieveMsgAction_%d",[reciever hash]];
    [_actions setObject:recievedAction forKey:key];
}
-(void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction forReciever:(id)reciever
{
    NSString *key = [NSString stringWithFormat:@"sendFaildAction_%d",[reciever hash]];
    [_actions setObject:faildAction forKey:key];
}
- (void)setSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction forReciever:(id)reciever
{
    NSString *key = [NSString stringWithFormat:@"sendSuccessAction_%d",[reciever hash]];
    [_actions setObject:successAction forKey:key];
}
- (void)removeMsgActionForReciever:(id)reciever
{
    NSString *recieveMsgSuccessKey = [NSString stringWithFormat:@"recieveMsgAction_%d",[reciever hash]];
    NSString *sendSuccessKey = [NSString stringWithFormat:@"sendSuccessAction_%d",[reciever hash]];
    NSString *sendFaildKey = [NSString stringWithFormat:@"sendFaildAction_%d",[reciever hash]];
    
    [_actions removeObjectForKey:recieveMsgSuccessKey];
    [_actions removeObjectForKey:sendSuccessKey];
    [_actions removeObjectForKey:sendFaildKey];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Send  Message  and Recieve Message
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//返回当前时间
- (NSString*)returnCurrentDateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-M-d HH:mm:ss"];
    
    NSString *currentDateTime = [dateFormatter stringFromDate:[NSDate date]];
    return currentDateTime;
}
- (void)sendMessageToUser:(ZYXMPPUser *)toUser withContent:(ZYXMPPMessage *)newMessage withSendResult:(void (^)(NSString *, NSString *))sendResult
{

    if (needAutoHostForJID) {
        toUser.jID = [NSString stringWithFormat:@"%@@%@",toUser.jID,_serverHost];
    }
	if([newMessage.content length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:newMessage.content];
        NSXMLElement *messageType = [NSXMLElement elementWithName:@"message_type"];
        [messageType setStringValue:newMessage.messageType];
        NSXMLElement *sendUser = [NSXMLElement elementWithName:@"send_user"];
        [sendUser setStringValue:newMessage.user];
        NSXMLElement *sendUserId = [NSXMLElement elementWithName:@"send_user_id"];
        [sendUserId setStringValue:newMessage.userId];
        NSXMLElement *sendUserSex = [NSXMLElement elementWithName:@"send_user_sex"];
        NSXMLElement *sendUserSchoolName = [NSXMLElement elementWithName:@"send_user_school_name"];
        [sendUserSex setStringValue:newMessage.sendUserSex];
        [sendUserSchoolName setStringValue:newMessage.sendUserSchoolName];
        
        NSXMLElement *addTime = [NSXMLElement elementWithName:@"add_time"];
        NSString *currentTime = [self returnCurrentDateTime];
		[addTime setStringValue:currentTime];
        NSXMLElement *audioTime = [NSXMLElement elementWithName:@"audio_time"];
        [audioTime setStringValue:newMessage.audioTime];
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];

        NSString *siID = [XMPPStream generateUUID];
        XMPPJID *receiptUser = [XMPPJID jidWithString:toUser.jID];
        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:receiptUser elementID:siID];
		[message addAttributeWithName:@"type" stringValue:@"chat"];
		[message addAttributeWithName:@"to" stringValue:toUser.jID];
		[message addChild:body];
        [message addChild:messageType];
        [message addChild:sendUser];
        [message addChild:sendUserId];
        [message addChild:sendUserSex];
        [message addChild:sendUserSchoolName];
        [message addChild:addTime];
        [message addChild:audioTime];
        [message addChild:receipt];
        
        DDLogVerbose(@"send message once time!");
        [self.xmppStream sendElement:message];
        
        //将这条信息的Id返回，以判断是否发送成功
        if ([message attributeStringValueForName:@"id"]) {
            DDLogVerbose(@"send message id :%@",[message attributeStringValueForName:@"id"]);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (sendResult) {
                    sendResult ([message attributeStringValueForName:@"id"],currentTime);
                }
            });
        }
	}
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else if (serverDomain == nil)
		{
			expectedCertName = virtualDomain;
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isXmppConnected = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:_password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_actions objectForKey:@"clientStartSuccess"]) {
            ZYXMPPClientStartSuccessAction successAction = [_actions objectForKey:@"clientStartSuccess"];
            successAction(@"login success");
        }
    });

	[self goOnline];
  
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_actions objectForKey:@"clientStartFaild"]) {
            ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
            faildAction(@"login faild");
        }
    });
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	DDLogVerbose(@"recv iq:%@",[iq description]);

	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
	// A simple example of inbound message handling.
    
    //回执判断
    NSXMLElement *request = [message elementForName:@"request"];
    if (request)
    {
        if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //组装消息回执
            XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:[message attributeStringValueForName:@"id"]];
            NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
            [msg addChild:recieved];
            
            //发送回执
            [self.xmppStream sendElement:msg];
        }
    }else
    {
        NSXMLElement *received = [message elementForName:@"received"];
        if (received)
        {
            if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    //发送成功
                    if ([_actions objectForKey:@"didSendMessageSuccess"]) {
                        ZYXMPPClientDidSendMessageSuccessAction didSendSuccess = [_actions objectForKey:@"didSendMessageSuccess"];
                        didSendSuccess([message attributeStringValueForName:@"id"]);
                    }
                    //分发消息
                    [_actions.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        
                        NSString *key = (NSString*)obj;
                        if ([key rangeOfString:@"sendSuccessAction_"].location!=NSNotFound) {
                            
                            ZYXMPPClientDidSendMessageSuccessAction didSendSuccess = [_actions objectForKey:key];
                            didSendSuccess([message attributeStringValueForName:@"id"]);
                        }
                        
                    }];

                });
            }
        }
    }
    //聊天消息
    if ([message isChatMessageWithBody])
    {
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [[message elementForName:@"send_user"]stringValue];
        NSString *addTime = [[message elementForName:@"add_time"]stringValue];
        NSString *audioTime = [[message elementForName:@"audio_time"]stringValue];
        NSString *messageType = [[message elementForName:@"message_type"]stringValue];
        NSString *sendUserId = [[message elementForName:@"send_user_id"]stringValue];
        NSString *messageId = [message attributeStringValueForName:@"id"];
        NSString *sendUserSex = [[message elementForName:@"send_user_sex"]stringValue];
        NSString *sendUserSchoolName = [[message elementForName:@"send_user_school_name"]stringValue];

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([_actions objectForKey:@"recieveMessageSuccess"]) {
                
                ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:@"recieveMessageSuccess"];
                ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
                newMessage.user = displayName;
                newMessage.content = body;
                newMessage.addTime = addTime;
                newMessage.friendAddTime = [XXCommonUitil getTimeStrWithDateString:addTime];
                newMessage.audioTime = audioTime;
                newMessage.messageType = messageType;
                newMessage.userId = sendUserId;
                newMessage.sendStatus = @"1";
                newMessage.messageId = messageId;
                newMessage.sendUserSex = sendUserSex;
                newMessage.sendUserSchoolName = sendUserSchoolName;
                
                newMessage.conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:newMessage.userId withMyUserId:originJId];
                newMessage.sendUserSex = sendUserSex;
                newMessage.sendUserSchoolName = sendUserSchoolName;
                if ([newMessage.messageType intValue]==ZYXMPPMessageTypeText) {
                    newMessage.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:newMessage];
                }
                recieveAction (newMessage);
            }
            
            //分发消息
            [_actions.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
               
                NSString *key = (NSString*)obj;
                if ([key rangeOfString:@"recieveMsgAction_"].location!=NSNotFound) {
                    
                    ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:key];
                    ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
                    newMessage.user = displayName;
                    newMessage.content = body;
                    newMessage.addTime = addTime;
                    newMessage.friendAddTime = [XXCommonUitil getTimeStrWithDateString:addTime];
                    newMessage.audioTime = audioTime;
                    newMessage.messageType = messageType;
                    newMessage.userId = sendUserId;
                    newMessage.sendStatus = @"1";
                    newMessage.messageId = messageId;
                    newMessage.sendUserSex = sendUserSex;
                    newMessage.sendUserSchoolName = sendUserSchoolName;
                    
                    newMessage.conversationId = [ZYXMPPMessage conversationIdWithOtherUserId:newMessage.userId withMyUserId:originJId];
                    if ([newMessage.messageType intValue]==ZYXMPPMessageTypeText) {
                        newMessage.messageAttributedContent = [ZYXMPPMessage attributedContentStringWithMessage:newMessage];
                        newMessage.content = [XXBaseTextView switchEmojiTextWithSourceText:newMessage.content];
                        newMessage.userHeadAttributedString = [ZYXMPPMessage userHeadAttributedStringWithMessage:newMessage];
                    }else if([newMessage.messageType intValue]==ZYXMPPMessageTypeAudio){
                        newMessage.userHeadAttributedString = [ZYXMPPMessage userHeadAttributedStringWithMessage:newMessage];

                    }else if([newMessage.messageType intValue]==ZYXMPPMessageTypeImage){
                        newMessage.userHeadAttributedString = [ZYXMPPMessage userHeadAttributedStringWithMessage:newMessage];
                    }
                    
                    recieveAction (newMessage);

                }
                
            }];
            
        });
        
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    
    NSXMLElement *x = [presence elementForName:@"x" xmlns:@"http://jabber.org/protocol/muc#user"];
    for (NSXMLElement *status in [x elementsForName:@"status"])
    {
        switch ([status attributeIntValueForName:@"code"])
        {
            case 201:
            {
                DDLogVerbose(@"enter room faild!");
            }
                break;
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
    if (error) {
        DDLogVerbose(@" DisConnect error :%@",error.description);
    }
    
	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_actions objectForKey:@"clientStartFaild"]) {
            
            ZYXMPPClientStartFaildAction faildAction = [_actions objectForKey:@"clientStartFaild"];
            faildAction(@"error account or password make disconnect error");
        }
    });
}
//================资源冲突=================
//- (NSString *)xmppStream:(XMPPStream *)sender alternativeResourceForConflictingResource:(NSString *)conflictingResource
//{
//    
//}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext_capabilities
{
	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");
	
	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.
    
	xmppStream = [[XMPPStream alloc] init];
    [xmppStream setMyJID:[XMPPJID jidWithString:_jId]];
	
#if !TARGET_IPHONE_SIMULATOR
	{
		xmppStream.enableBackgroundingOnSocket = needBackgroundRecieve;
	}
#endif
	
	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.
	
	xmppReconnect = [[XMPPReconnect alloc] init];
	
    //消息回执
//    xmppMessageDeliveryRecipts = [[XMPPMessageDeliveryReceipts alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryReceipts = YES;
//    xmppMessageDeliveryRecipts.autoSendMessageDeliveryRequests = YES;
    

    //聊天室
    xmppRoomStorage = [[XMPPRoomCoreDataStorage alloc]init];
    XMPPMUC *xmppMuc = [[XMPPMUC alloc]initWithDispatchQueue:ZYXMPPClientQueue];
    [xmppMuc addDelegate:self delegateQueue:ZYXMPPClientQueue];
    
	// Activate xmpp modules    
	[xmppReconnect         activate:xmppStream];
    [xmppMessageDeliveryRecipts activate:xmppStream];
    [xmppMuc activate:xmppStream];

	// Add ourself as a delegate to anything we may be interested in
	[xmppStream addDelegate:self delegateQueue:ZYXMPPClientQueue];

	
    if (shouldUseCustomHost) {
        [xmppStream setHostName:_serverHost];
    }
    if (_serverPort) {
        [xmppStream setHostPort:[_serverPort intValue]];
    }else{
        [xmppStream setHostPort:5222];
    }
	
	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
//	[xmppRoster removeDelegate:self];
    [xmppRoom   removeDelegate:self];
	
	[xmppReconnect         deactivate];
//	[xmppRoster            deactivate];
//	[xmppvCardTempModule   deactivate];
//	[xmppvCardAvatarModule deactivate];
//	[xmppCapabilities      deactivate];
    [xmppMessageDeliveryRecipts deactivate];
    [xmppRoom deactivate];
	
	[xmppStream disconnect];
	
	xmppStream = nil;
	xmppReconnect = nil;
    xmppMessageDeliveryRecipts=nil;
    xmppRoomStorage = nil;
    xmppRoom = nil;
//    xmppRoster = nil;
//	xmppRosterStorage = nil;
//	xmppvCardStorage = nil;
//    xmppvCardTempModule = nil;
//	xmppvCardAvatarModule = nil;
//	xmppCapabilities = nil;
//	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}
    
	NSString *myJID = _jId;
	NSString *myPassword = _password;
    
	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";
	
	if (myJID == nil || myPassword == nil) {
		return NO;
	}
    
	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	_password = myPassword;
    
	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		
        if ([_actions objectForKey:@"connectServerError"]) {
            
            ZYXMPPClientConnectServerErrorAction errorAction = [_actions objectForKey:@"connectServerError"];
            
            errorAction (@"connect to server error happend!");
        }
		DDLogError(@"Error connecting: %@", error);
        
		return NO;
	}
    
	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


//================================ turnsocket 文件传输  ===================
- (void)sendFileWithData:(NSData *)fileData withFileName:(NSString *)fileName toJID:(NSString *)jID
{
    if (!isXmppConnected) {
        DDLogVerbose(@"turnsocket connect need login");
        return;
    }

    if(needAutoHostForJID){
        jID = [NSString stringWithFormat:@"%@@%@/spark",jID,_serverHost];
    }
    XMPPJID *toUser = [XMPPJID jidWithString:jID];
    
    if (fileData) {
        fileData=nil;
    }
    fileData = [[NSMutableData alloc]initWithData:fileData];
    [TURNSocket setProxyCandidates:[NSArray arrayWithObject:_serverHost]];
    TURNSocket *fileTurn = [[TURNSocket alloc]initWithStream:self.xmppStream toJID:toUser];
    
    [fileTurn startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}
#pragma mark - turnsocket delegate
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket
{
    DDLogVerbose(@"turn socket connected now !!!!++++++++++++++++++!!!!!!!!!");
    
    //写入文件流
    [socket writeData:fileDataWillTrans withTimeout:240.f tag:1234567];
}
- (void)turnSocketDidFail:(TURNSocket *)sender
{
    DDLogVerbose(@"turn socket connected faild !!!++++++++++++++++!!!!!!");
}

//=============================  聊天室 ====================================//

//==========群聊
- (void)setDidRecievedGroupMessageAction:(ZYXMPPClientDidRecievedGroupChatMessage)successAction
{
    [_actions setObject:successAction forKey:@"didRecieveGroupMessageSuccess"];
}
- (void)setCreateRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"CreateRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)createRoomSuccessAction
{
    return [_actions objectForKey:@"CreateRoomSuccessAction"];
}
- (void)setJoinRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"JoinRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)joinRoomSuccessAction
{
    return [_actions objectForKey:@"JoinRoomSuccessAction"];
}
- (void)setLeaveRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"LeaveRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)leaveRoomSuccessAction
{
    return [_actions objectForKey:@"LeaveRoomSuccessAction"];
}
- (void)setDestroyRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction
{
    [_actions setObject:resultAction forKey:@"DestroyRoomSuccessAction"];
}
- (ZYXMPPClientRoomExcuteResultAction)destroyRoomSuccessAction
{
   return [_actions objectForKey:@"DestroyRoomSuccessAction"];
}
- (void)setDidRecieveInviteActioon:(ZYXMPPClientDidRecieveInviteAction)successAction
{
    [_actions setObject:successAction forKey:@"DidFinishInvite"];
}
- (ZYXMPPClientDidRecieveInviteAction)didRecieveInviteAction
{
    return [_actions objectForKey:@"DidFinishInvite"];
}
#pragma mark - room chat
- (NSString *)genrateRoomID
{
    NSString *trueJID = [NSString stringWithFormat:@"%@_grouproom@conference.%@",[xmppStream generateUUID],_serverHost];
    return trueJID;
}
- (void)readAllRoomConfig
{
    for (int i=0; i<10; i++) {
        ZYXMPPRoomConfig *newConfig = [[ZYXMPPRoomConfig alloc]init];
        newConfig.name = [NSString stringWithFormat:@"用户%@创建的聊天室%d",originJId,i];
        newConfig.description = [NSString stringWithFormat:@"用户%@创建的聊天室%d",originJId,i];
        newConfig.subject = @"创建新聊天室";
        newConfig.needPasswordProtect = NO;
        newConfig.secret = @"";
        newConfig.maxUserCount = 30;
        newConfig.maxHistoryMessageReturnCount = 100;
        newConfig.owner = _jId;
        newConfig.admins = [NSArray array];
        newConfig.enableLogging = YES;
        newConfig.allowInivite = YES;
        newConfig.allowPrivateMsg = NO;
        newConfig.whoCanDiscoveryOthersJID = ZYXMPPRoomRoleMember;
        newConfig.whoCanBroadCastMsg = ZYXMPPRoomRoleMember;
        newConfig.whoCanGetRoomMemberList = ZYXMPPRoomRoleMember;
        newConfig.needPersistThisRoom = YES;
        newConfig.isThisPublicRoom = YES;
        newConfig.isRoomForAdminOnly = NO;
        newConfig.isRoomForMemberOnly = NO;
        newConfig.reconfigState = YES;
        newConfig.roomID = [NSString stringWithFormat:@"zyprosoft%d",i];
        newConfig.roomID = [ZYXMPPRoomConfig realRoomJIDWithID:newConfig.roomID withHostName:_serverHost];
        newConfig.roomIndex = i;
        newConfig.myNickName = [NSString stringWithFormat:@"zyprosoft"];
        [xmppRoomConfigs addObject:newConfig];
        [[ZYXMPPLocalPersist sharePersist]saveNewLocalRoomWithConfigure:newConfig];
    }
    
    roomIndex = 0;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createNextConfigRoom:) name:ZYXMPPRoomCreateOneRoomFinishedNoti object:nil];
}
- (void)createNextConfigRoom:(NSNotification*)noti
{
    roomIndex++;
    if (roomIndex==xmppRoomConfigs.count) {
        return;
    }
    
    DDLogVerbose(@"nextRoomIndex:%d",roomIndex);
    [self createRoomsWithRoomIndex:roomIndex];
    
}
- (void)initDefaultRoomConfig
{
    myRoomConfig = [[ZYXMPPRoomConfig alloc]init];
    myRoomConfig.name = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.description = [NSString stringWithFormat:@"用户%@创建的聊天室",originJId];
    myRoomConfig.subject = @"创建新聊天室";
    myRoomConfig.needPasswordProtect = NO;
    myRoomConfig.secret = @"";
    myRoomConfig.maxUserCount = 30;
    myRoomConfig.maxHistoryMessageReturnCount = 100;
    myRoomConfig.owner = _jId;
    myRoomConfig.admins = [NSArray array];
    myRoomConfig.enableLogging = YES;
    myRoomConfig.allowInivite = YES;
    myRoomConfig.allowPrivateMsg = NO;
    myRoomConfig.whoCanDiscoveryOthersJID = ZYXMPPRoomRoleMember;
    myRoomConfig.whoCanBroadCastMsg = ZYXMPPRoomRoleMember;
    myRoomConfig.whoCanGetRoomMemberList = ZYXMPPRoomRoleMember;
    myRoomConfig.needPersistThisRoom = YES;
    myRoomConfig.isThisPublicRoom = YES;
    myRoomConfig.isRoomForAdminOnly = NO;
    myRoomConfig.isRoomForMemberOnly = NO;
    myRoomConfig.reconfigState = YES;
    myRoomConfig.myNickName = @"zyprosoft";

    DDLogVerbose(@"init my default room config success!");
}
- (void)createRoomsWithRoomIndex:(NSInteger)roomIndex
{
    ZYXMPPRoomConfig *firstRoom = [xmppRoomConfigs objectAtIndex:roomIndex];
    DDLogVerbose(@"creating room with ID============>%@",firstRoom.roomID);
    xmppRoom  = [[XMPPRoom alloc]initWithRoomStorage:self jid:[XMPPJID jidWithString:firstRoom.roomID]];
    BOOL activeNewRoomResult = [xmppRoom activate:xmppStream];
    if (activeNewRoomResult) {
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        //
        [xmppRoom joinRoomUsingNickname:originJId history:nil];
    }
}

//创建默认聊天室
- (void)createDefaultConfigRoomUseMyJID
{
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:myRoomConfig.roomID withHostName:_serverHost];
    myRoomConfig.roomID = roomJID;
    myRoomConfig.roomID = [NSString stringWithFormat:@"vincent@conference.112.124.37.183"];
    xmppRoom  = [[XMPPRoom alloc]initWithRoomStorage:self jid:[XMPPJID jidWithString:myRoomConfig.roomID]];
    BOOL activeNewRoomResult = [xmppRoom activate:xmppStream];
    if (activeNewRoomResult) {
        [xmppRoom addDelegate:self delegateQueue:ZYXMPPClientQueue];
        
        //
        [xmppRoom joinRoomUsingNickname:originJId history:nil];
        
        //持久化
        [_innerConfigDict setObject:myRoomConfig forKey:myRoomConfig.roomID];
        [[ZYXMPPLocalPersist sharePersist]saveNewLocalRoomWithConfigure:myRoomConfig];
    }
    
}
- (void)createGroupChatRoomWithRoomConfig:(ZYXMPPRoomConfig *)roomConfig
{
    XMPPJID *roomJID = [XMPPJID jidWithString:roomConfig.roomID];
    roomConfig.reconfigState = YES;
    xmppRoom= [[XMPPRoom alloc]initWithRoomStorage:self jid:roomJID];
    roomConfig.roomID = [roomJID full];
    BOOL activeNewRoomResult = [xmppRoom activate:self.xmppStream];
    if (activeNewRoomResult) {
        DDLogVerbose(@"active room success:%@ ",xmppRoom.description);
        [xmppRoom addDelegate:self delegateQueue:ZYXMPPClientQueue];
        //自己加入
        [xmppRoom joinRoomUsingNickname:roomConfig.myNickName history:nil];
        //持久化
        [[ZYXMPPLocalPersist sharePersist]saveNewLocalRoomWithConfigure:roomConfig];
    }
}
- (void)createDefaultConfigGroupChatRoomSpecialWithRoomName:(NSString *)roomName
{
    ZYXMPPRoomConfig *newConfig = [myRoomConfig copy];
    newConfig.name = roomName;
    newConfig.reconfigState = YES;
    
    [self createGroupChatRoomWithRoomConfig:newConfig];
    
}

//邀请别人
- (void)inviteUser:(NSString *)userJID toRoom:(NSString *)roomID
{
    NSString *realJID = [NSString stringWithFormat:@"%@@%@",userJID,_serverHost];
    [xmppRoom inviteUser:[XMPPJID jidWithString:realJID] withMessage:@"join me!"];
}

//加入目标聊天室
- (void)joinGroupChatRoomWithRoomId:(NSString *)roomID withNickName:(NSString *)nickName
{
    xmppRoom = [[XMPPRoom alloc]initWithRoomStorage:xmppRoomStorage jid:[XMPPJID jidWithString:roomID]];
    BOOL activeNewRoomResult = [xmppRoom activate:self.xmppStream];
    if (activeNewRoomResult) {
        DDLogVerbose(@"active room success:%@ ",xmppRoom.description);
        [xmppRoom addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)];
        //自己加入
        [xmppRoom joinRoomUsingNickname:myRoomConfig.myNickName history:nil];
        //持久化
        [[ZYXMPPLocalPersist sharePersist]saveOthersRoomWithRoomID:roomID];
    }
    
}

- (void)queryRoomNickName:(NSString*)roomID
{
    NSString *roomJID = [ZYXMPPRoomConfig realRoomJIDWithID:roomID withHostName:_serverHost];
    NSString *qId = [xmppStream generateUUID];

    NSXMLElement *xlmns = [NSXMLElement attributeWithName:@"xmlns" stringValue:@"http://jabber.org/protocol/disco#info"];
    NSXMLElement *node = [NSXMLElement attributeWithName:@"node" stringValue:@"x-roomuser-item"];
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" children:nil attributes:@[xlmns,node]];
    NSXMLElement *presence = [[XMPPIQ alloc]initWithType:@"get" elementID:qId child:query];
    [presence addAttributeWithName:@"to" stringValue:roomJID];
    [presence addAttributeWithName:@"id" stringValue:qId];
    [presence addAttributeWithName:@"from" stringValue:_jId];
    [presence addAttributeWithName:@"type" stringValue:@"get"];
    [[self xmppStream] sendElement:presence];

}

- (void)sendRoomChatMessage:(ZYXMPPMessage *)newMessage toRoomJID:(NSString *)roomJID
{
	if([newMessage.content length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:newMessage.content];
        NSXMLElement *messageType = [NSXMLElement elementWithName:@"message_type"];
        [messageType setStringValue:newMessage.messageType];
        NSXMLElement *sendUser = [NSXMLElement elementWithName:@"send_user"];
        [sendUser setStringValue:newMessage.user];
        NSXMLElement *sendUserId = [NSXMLElement elementWithName:@"send_user_id"];
        [sendUserId setStringValue:newMessage.userId];
        NSXMLElement *addTime = [NSXMLElement elementWithName:@"add_time"];
        NSString *currentTime = [self returnCurrentDateTime];
		[addTime setStringValue:currentTime];
        if (![newMessage.content isEqualToString:@""]) {
            newMessage.audioTime = @"0";
        }
        NSXMLElement *audioTime = [NSXMLElement elementWithName:@"audio_time"];
        [audioTime setStringValue:newMessage.audioTime];
        NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
        
        NSString *siID = [XMPPStream generateUUID];
        XMPPMessage *message = [XMPPMessage messageWithType:@"groupchat" elementID:siID];
        NSXMLElement *from = [NSXMLElement attributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@/%@",_jId,myRoomConfig.myNickName]];
        NSXMLElement *to = [NSXMLElement attributeWithName:@"to" stringValue:roomJID];
        [message addAttribute:from];
        [message addAttribute:to];
        
		[message addChild:body];
        [message addChild:messageType];
        [message addChild:sendUser];
        [message addChild:sendUserId];
        [message addChild:addTime];
        [message addChild:audioTime];
        [message addChild:receipt];
        
        DDLogVerbose(@"send message once time!");
        [xmppRoom sendMessage:message];
        
	}

}

- (void)saveGroupChatViewController:(UIViewController *)groupVC forRoomID:(NSString *)roomID
{
    [xmppRooms setObject:groupVC forKey:roomID];
}
- (void)removeGroupChatViewForRoomID:(NSString *)roomID
{
    [xmppRooms removeObjectForKey:roomID];
}

#pragma mark xmpproom delegate
//============================================ XMPPRoom Delegate =========================
- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    [xmppRoom fetchConfigurationForm];
    [xmppRoom fetchBanList];
    [xmppRoom fetchMembersList];
    [xmppRoom fetchModeratorsList];
}

/**
 *在这里确认房间配置,才能解锁房间
 **/
- (void)xmppRoom:(XMPPRoom *)sender didFetchConfigurationForm:(NSXMLElement *)configForm
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"didFetchConfigure:%@",[configForm description]);
    
    NSString *roomJID = [[sender roomJID]full];
    
    ZYXMPPRoomConfig *checkConfig = [[ZYXMPPLocalPersist sharePersist]checkIfNeedReFecthRoomConfigForRoomID:roomJID];
    DDLogVerbose(@"Fetch Config to Find Config:%@",checkConfig);
    if (checkConfig) {
        
        DDLogVerbose(@"check config:%@",checkConfig);
        NSXMLElement *configElement = [ZYXMPPRoomConfig configElementWithRoomConfigModel:checkConfig];
        [sender configureRoomUsingOptions:configElement];
        [_innerConfigDict removeObjectForKey:roomJID];
    }


}

- (void)xmppRoom:(XMPPRoom *)sender willSendConfiguration:(XMPPIQ *)roomConfigForm
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didConfigure:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"didConfigure result:%@",[iqResult description]);

    //create next room
    dispatch_async(dispatch_get_main_queue(), ^{
        ZYXMPPRoomConfig *roomConfig = [[ZYXMPPLocalPersist sharePersist]checkIfNeedReFecthRoomConfigForRoomID:[sender.roomJID full]];
        DDLogVerbose(@"currentConfig +++++++++++++++++++++++++++++++++++++++++++:%@",roomConfig);
        [[NSNotificationCenter defaultCenter]postNotificationName:ZYXMPPRoomCreateOneRoomFinishedNoti object:roomConfig];
    });
    
    if ([self createRoomSuccessAction]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ZYXMPPClientRoomExcuteResultAction resultAction = [self createRoomSuccessAction];
            NSString *roomID = [sender.roomJID full];
            NSString *getSubjectName = [[ZYXMPPLocalPersist sharePersist]getRoomSubjectByRoomID:roomID];
            NSString *resultMsg = [NSString stringWithFormat:@"创建群:%@成功",getSubjectName];
            resultAction(YES,resultMsg);
            
            //更新room配置状态
            NSString *roomJID = [[sender roomJID]full];
            [[ZYXMPPLocalPersist sharePersist]updateRoomReconfigState:NO forRoom:roomJID];
            
        });
    }
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotConfigure:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    
}
- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
}

- (void)xmppRoomDidDestroy:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender occupantDidUpdate:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

/**
 * Invoked when a message is received.
 * The occupant parameter may be nil if the message came directly from the room, or from a non-occupant.
 **/
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    DDLogVerbose(@"group message :%@",message);
    
    //聊天消息
    if ([[message attributeStringValueForName:@"type"]isEqualToString:@"groupchat"])
    {
        NSString *body = [[message elementForName:@"body"] stringValue];
        NSString *displayName = [[message elementForName:@"send_user"]stringValue];
        NSString *addTime = [[message elementForName:@"add_time"]stringValue];
        NSString *audioTime = [[message elementForName:@"audio_time"]stringValue];
        NSString *messageType = [[message elementForName:@"message_type"]stringValue];
        NSString *sendUserId = [[message elementForName:@"send_user_id"]stringValue];
        
        if ([_actions objectForKey:@"didRecieveGroupMessageSuccess"]) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                ZYXMPPClientDidRecievedMessageAction recieveAction = [_actions objectForKey:@"didRecieveGroupMessageSuccess"];
                ZYXMPPMessage *newMessage = [[ZYXMPPMessage alloc]init];
                newMessage.user = displayName;
                newMessage.content = body;
                newMessage.addTime = addTime;
                newMessage.audioTime = audioTime;
                newMessage.messageType = messageType;
                newMessage.userId = sendUserId;
                newMessage.sendStatus = @"1";
                
                DDLogVerbose(@"new group messsage:%@",newMessage);
                recieveAction (newMessage);
                
            });
        }
    }
}

- (void)xmppRoom:(XMPPRoom *)sender didFetchBanList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchBanList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didFetchMembersList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);
    //保存群成员信息
    
}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchMembersList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didFetchModeratorsList:(NSArray *)items
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotFetchModeratorsList:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}

- (void)xmppRoom:(XMPPRoom *)sender didEditPrivileges:(XMPPIQ *)iqResult
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
- (void)xmppRoom:(XMPPRoom *)sender didNotEditPrivileges:(XMPPIQ *)iqError
{
    DDLogVerbose(@"%@%@",THIS_FILE,THIS_METHOD);

}
//=================== room storge =======================
- (BOOL)configureWithParent:(XMPPRoom *)aParent queue:(dispatch_queue_t)queue
{
    return YES;
}

/**
 * Updates and returns the occupant for the given presence element.
 * If the presence type is "available", and the occupant doesn't already exist, then one should be created.
 **/
- (void)handlePresence:(XMPPPresence *)presence room:(XMPPRoom *)room
{
    
}

/**
 * Stores or otherwise handles the given message element.
 **/
- (void)handleIncomingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}
- (void)handleOutgoingMessage:(XMPPMessage *)message room:(XMPPRoom *)room
{
    
}

/**
 * Handles leaving the room, which generally means clearing the list of occupants.
 **/
- (void)handleDidLeaveRoom:(XMPPRoom *)room
{
    
}

/**
 * May be used if there's anything special to do when joining a room.
 **/
- (void)handleDidJoinRoom:(XMPPRoom *)room withNickname:(NSString *)nickname
{
    
}

//================ MUC Delegate ================
#pragma mark - MUC Delegate
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitation:(XMPPMessage *)message
{
    if ([self didRecieveInviteAction]) {
        
        ZYXMPPClientDidRecieveInviteAction inviteAction = [self didRecieveInviteAction];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            inviteAction (YES,[roomJID full]);
            
        });
        
    }
}
- (void)xmppMUC:(XMPPMUC *)sender roomJID:(XMPPJID *)roomJID didReceiveInvitationDecline:(XMPPMessage *)message
{
    
}


@end
