//
//  ZYXMPPRoomConfig.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-29.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

/*
 需要另外建立系统来创建一个表，保存我创建的或者加入的群的配置信息，独立于Openfire之外
 */

/*
 注意事项:   当一个用户JID用来作为Owner之后，则不能再出现在Admins中，否则引起409 confilct错误,导致无法确认聊天室配置，无法完成聊天室创建
 */

/*
 聊天室密码设定:  将needPasswordProtect设置成YES,在secret属性填写你设定的密码
 */

/*
 当你每次修改了聊天室的配置，你都需要重新去服务器获取聊天室配置来确认
 */

extern NSString *const ZYXMPPRoomRoleAdmin;
extern NSString *const ZYXMPPRoomRoleMember;
extern NSString *const ZYXMPPRoomRoleVisitor;
extern NSString *const ZYXMPPRoomRoleAnyone;

@interface ZYXMPPRoomConfig : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,assign)NSInteger maxUserCount;
@property (nonatomic,assign)BOOL needPasswordProtect;
@property (nonatomic,assign)NSInteger maxHistoryMessageReturnCount;
@property (nonatomic,assign)BOOL enableLogging;
@property (nonatomic,strong)NSString *subject;
@property (nonatomic,assign)BOOL allowInivite;
@property (nonatomic,assign)BOOL allowPrivateMsg;
@property (nonatomic,strong)NSString *whoCanBroadCastMsg;
@property (nonatomic,strong)NSString *owner;//确保群主只有一个
@property (nonatomic,assign)BOOL needPersistThisRoom;
@property (nonatomic,assign)BOOL isThisPublicRoom;
@property (nonatomic,strong)NSString *whoCanGetRoomMemberList;
@property (nonatomic,assign)BOOL isRoomForAdminOnly;
@property (nonatomic,assign)BOOL isRoomForMemberOnly;
@property (nonatomic,strong)NSString *whoCanDiscoveryOthersJID;
@property (nonatomic,strong)NSArray  *admins;
@property (nonatomic,strong)NSString *secret;
@property (nonatomic,strong)NSString *roomID;//  xxx@conference.host 中的xxx
@property (nonatomic,assign)NSInteger reconfigState;//是否需要重新发送聊天室配置信息
@property (nonatomic,strong)NSString *myNickName;
@property (nonatomic,assign)NSInteger roomIndex;

+ (NSString*)realRoomJIDWithID:(NSString*)qId withHostName:(NSString*)host;

+ (NSXMLElement *)configElementWithRoomConfigModel:(ZYXMPPRoomConfig*)configModel;

@end
