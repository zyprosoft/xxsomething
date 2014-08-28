//
//  ZYXMPPClient.h
//  ZYXMPPClient
//
//  Created by ZYVincent on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

/************
 
 ***  必须将所有ZYXMPPClient 下的文件都设置ARC标示，在build phases-> compile sources 双击.m文件，填写 -fobjc-arc
 ***  添加库文件支持  coreLocation.framework,libresolv.dylib,libxml2.dylib,scurity.framework,systemConfiguration.framework
 ***  CFNetWork.framework,CoreData.framework
 ***  添加头文件路径包含 Build Settings -> search Path -> Header search paths : 添加 /usr/include/libxml2
 
 ***********/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ZYXMPPUser.h"
#import "ZYXMPPMessage.h"
#import "ZYXMPPRoomConfig.h"
#import "ZYXMPPLocalPersist.h"

#import "XMPPFramework.h"
#import "GCDAsyncSocket.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPMessageDeliveryReceipts.h"
#import "XMPPMUC.h"
#import "XMPPRoomCoreDataStorage.h"
#import "XMPPRoomHybridStorage.h"
#import "XMPPRoomHybridStorageProtected.h"
#import "XMPPRoomMessage.h"
#import "XMPPRoomMessageMemoryStorageObject.h"
#import "XMPPRoomPrivate.h"
#import "XMPPRoomOccupantMemoryStorageObject.h"
#import "XMPPRoom.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
//文件传输协议
#import "TURNSocket.h"
#import <CFNetwork/CFNetwork.h>

typedef void (^ZYXMPPClientStartSuccessAction) (NSString *successMsg);
typedef void (^ZYXMPPClientStartFaildAction) (NSString *faildMsg);
typedef void (^ZYXMPPClientConnectServerErrorAction) (NSString *errMsg);
typedef void (^ZYXMPPClientSendMessageFaildAction) (ZYXMPPMessage *message,ZYXMPPUser *toUser);
typedef void (^ZYXMPPClientSendMessageSuccessAction) (ZYXMPPMessage *message,ZYXMPPUser *toUser);
typedef void (^ZYXMPPClientDidRecievedMessageAction) (ZYXMPPMessage *newMessage);
typedef void (^ZYXMPPClientDidSendMessageSuccessAction) (NSString *messageId);
typedef void (^ZYXMPPClientDidRecievedGroupChatMessage) (ZYXMPPMessage *newMessage);
typedef void (^ZYXMPPClientRoomExcuteResultAction) (BOOL state,NSString *message);
typedef void (^ZYXMPPClientGetRoomMemberListResultAction) (NSArray *memberList);
typedef void (^ZYXMPPClientDidRecieveInviteAction) (BOOL resultState,NSString *msg);


@interface ZYXMPPClient : NSObject<XMPPRosterDelegate,TURNSocketDelegate,XMPPRoomDelegate,XMPPRoomStorage,XMPPMUCDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
	XMPPMessageDeliveryReceipts* xmppMessageDeliveryRecipts;
    
    //聊天室
    XMPPRoomCoreDataStorage *xmppRoomStorage;
    XMPPRoom                *xmppRoom;
    NSMutableDictionary     *xmppRooms;
    NSMutableArray          *xmppRoomConfigs;
    NSInteger                roomIndex;
    
	NSString *_password;
    NSString *_jId;
    NSString *_serverHost;
    NSString *_serverPort;
    NSString *originJId;
    BOOL      shouldUseCustomHost;
    NSMutableDictionary *_actions;
    NSMutableDictionary *_msgActions;
    ZYXMPPRoomConfig *myRoomConfig;
    NSMutableDictionary *_innerConfigDict;
    NSInteger roomsCount;

	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    BOOL needAutoHostForJID;
    BOOL needBackgroundRecieve;
    
    BOOL isTraningFile;//是否正在传输文件
    NSMutableData *fileDataWillTrans;//将要传输的文件数据
}
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
@property (nonatomic, strong, readonly) XMPPRoom *xmppRoom;
@property (nonatomic, assign, readonly) BOOL hasConfigedClient;
@property (nonatomic, assign, readonly) BOOL backgroundActiveEnbaleState;

+ (ZYXMPPClient*)shareClient;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

//退出当前的登陆的xmpp用户
- (void)loginOutCurrentClient;

//默认配置
- (void)clientDefaultConfig;
- (NSString*)myChatID;
- (NSString*)myChatJID;
- (NSString*)genrateRoomID;

//是否需要用主机补全JID
- (void)setNeedAutoJIDWithCustomHostName:(BOOL)state;
- (void)setNeedUseCustomHostAddress:(BOOL)shouldUse;
- (void)setJabbredServerAddress:(NSString*)address;
- (void)setJabbredServerPort:(NSString*)port;
- (void)setNeedBackgroundRecieve:(BOOL)needBackground;
- (void)setMyDefaultNickName:(NSString*)nickName;
- (NSString*)myNickName;

- (void)setStartClientSuccessAction:(ZYXMPPClientStartSuccessAction)successAction;
- (void)setStartClientFaildAction:(ZYXMPPClientStartFaildAction)faildAction;
- (void)setDidSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction;
- (void)setConnectToServerErrorAction:(ZYXMPPClientConnectServerErrorAction)errorAction;
- (void)setSendMessageSuccessAction:(ZYXMPPClientSendMessageSuccessAction)successAction;
- (void)setSendMessageSuccessAction:(ZYXMPPClientDidSendMessageSuccessAction)successAction forReciever:(id)reciever;
- (void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction;
- (void)setSendMessageFaildAction:(ZYXMPPClientSendMessageFaildAction)faildAction forReciever:(id)reciever;
- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction;
- (void)setDidRecievedMessage:(ZYXMPPClientDidRecievedMessageAction)recievedAction forReciever:(id)reciever;
- (void)setDidRecieveInviteActioon:(ZYXMPPClientDidRecieveInviteAction)successAction;
- (void)removeMsgActionForReciever:(id)reciever;

- (void)startClientWithJID:(NSString *)jidString withPassword:(NSString*)password;
- (void)sendMessageToUser:(ZYXMPPUser *)toUser withContent:(ZYXMPPMessage*)newMessage withSendResult:(void (^)(NSString *messageId,NSString *addTime))sendResult;


- (void)clientTearDown;
- (BOOL)connect;
- (void)disconnect;

//-----流传送socket5byte扩展
- (void)sendFileWithData:(NSData*)fileData withFileName:(NSString*)fileName toJID:(NSString*)jID;

//--------------------------------- 群聊天 ----------------------------
//设置通用响应操作
- (void)setCreateRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction;
- (void)setLeaveRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction;
- (void)setDestroyRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction;
- (void)setJoinRoomSuccessAction:(ZYXMPPClientRoomExcuteResultAction)resultAction;
- (void)saveGroupChatViewController:(UIViewController*)groupVC forRoomID:(NSString*)roomID;
- (void)removeGroupChatViewForRoomID:(NSString*)roomID;

//群聊
- (void)setDidRecievedGroupMessageAction:(ZYXMPPClientDidRecievedGroupChatMessage)successAction;

//创建默认配置聊天室
- (void)createDefaultConfigRoomUseMyJID;

//根据配置创建
- (void)createGroupChatRoomWithRoomConfig:(ZYXMPPRoomConfig*)roomConfig;

//根据名字创建聊天，其他采用默认配置
- (void)createDefaultConfigGroupChatRoomSpecialWithRoomName:(NSString*)roomName;

//邀请别人
- (void)inviteUser:(NSString*)userJID toRoom:(NSString*)roomID;

//加入聊天室
- (void)joinGroupChatRoomWithRoomId:(NSString*)roomID withNickName:(NSString*)nickName;

//退群,实现退群就是从服务器和本地数据库上把属于我的这个群的配置信息给删掉，在客户端再也不登陆这个聊天室就实现退群
- (void)quitFromRoom:(NSString*)roomID withQuitResult:(ZYXMPPClientRoomExcuteResultAction)resultAction;

//创始人解散这个群
- (void)destoryRoomWithRoomID:(NSString*)roomID;

//设置管理员 admins:   xxx@host 中的 xxx 组成的数组
- (void)setAdminsForRoom:(NSString*)roomID withAdmins:(NSArray*)admins;

- (void)createRoomsWithRoomIndex:(NSInteger)roomIndex;

//获取群用户
- (void)getMemberListFomRoom:(NSString*)roomID withSuccessAction:(ZYXMPPClientGetRoomMemberListResultAction)successAction;

- (void)sendRoomChatMessage:(ZYXMPPMessage*)newMessage toRoomJID:(NSString*)roomJID;

@end
