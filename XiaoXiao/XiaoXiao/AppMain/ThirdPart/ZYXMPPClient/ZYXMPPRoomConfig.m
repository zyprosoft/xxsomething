//
//  ZYXMPPRoomConfig.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-29.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPRoomConfig.h"

NSString *const ZYXMPPRoomRoleAdmin = @"moderator";
NSString *const ZYXMPPRoomRoleMember = @"participant";
NSString *const ZYXMPPRoomRoleVisitor = @"visitor";
NSString *const ZYXMPPRoomRoleAnyone = @"anyone";

#define StringBOOL(x) [NSString stringWithFormat:@"%d",x]
#define StringInt(x) [NSString stringWithFormat:@"%d",x]

@implementation ZYXMPPRoomConfig
- (id)init
{
    self = [super init];
    if (self) {
        
        //初始化一些默认值的
        self.reconfigState = YES;
        self.isThisPublicRoom = YES;
        self.isRoomForAdminOnly = NO;
        self.isRoomForMemberOnly = YES;
        self.whoCanBroadCastMsg = ZYXMPPRoomRoleMember;
        self.needPersistThisRoom = YES;
        self.maxHistoryMessageReturnCount = 100;
        self.maxUserCount = 30;
        
    }
    return self;
}
+ (NSXMLElement *)configElementWithRoomConfigModel:(ZYXMPPRoomConfig*)configModel
{
    //参考:http://xmpp.org/extensions/xep-0045.html#createroom
    NSString *XMPPMUCRoomConfigProtocol = @"http://jabber.org/protocol/muc#roomconfig";
    NSString *XMPPMUCRoomNameNameSpace = @"muc#roomconfig_roomname";
    NSString *XMPPMUCRoomDescriptionNameSpace = @"muc#roomconfig_roomdesc";
    NSString *XMPPMUCRoomLanguageNameSpace = @"muc#roomconfig_lang";
    NSString *XMPPMUCRoomEnableLogging = @"muc#roomconfig_enablelogging";
    NSString *XMPPMUCRoomChangeSubject = @"muc#roomconfig_changesubject";
    NSString *XMPPMUCRoomAllowInivtes = @"muc#roomconfig_allowinvites";
    NSString *XMPPMUCRoomAllowPrivateMessage = @"muc#roomconfig_allowpm";
    NSString *XMPPMUCRoomMaxUser = @"muc#roomconfig_maxusers";
    NSString *XMPPMUCRoomBroadCastUserType = @"muc#roomconfig_presencebroadcast";
    NSString *XMPPMUCRoomGetMemeberList = @"muc#roomconfig_getmemberlist";
    NSString *XMPPMUCRoomPublicRoom = @"muc#roomconfig_publicroom";
    NSString *XMPPMUCRoomPersistRoom = @"muc#roomconfig_persistentroom";
    NSString *XMPPMUCRoomAdminHasThisRoom = @"muc#roomconfig_moderatedroom";
    NSString *XMPPMUCRoomMakeForMemberOnly = @"muc#roomconfig_membersonly";
    NSString *XMPPMUCRoomPasswordProtected = @"muc#roomconfig_passwordprotectedroom";
    NSString *XMPPMUCRoomRoomSecrect = @"muc#roomconfig_roomsecret";
    NSString *XMPPMUCRoomWhoCanDiscoveryJID = @"muc#roomconfig_whois";
    NSString *XMPPMUCRoomReturnMaxHistoryMessagesCount = @"muc#maxhistoryfetch";
    NSString *XMPPMUCRoomSetAdmins = @"muc#roomconfig_roomadmins";
    NSString *XMPPMUCRoomOwners = @"muc#roomconfig_roomowners";
    
    NSXMLElement *roomSettings = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    
    //form type
    NSXMLElement *roomConfigFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:@"FORM_TYPE"];
    NSXMLElement *roomConfigValue = [NSXMLElement elementWithName:@"value" stringValue:XMPPMUCRoomConfigProtocol];
    NSXMLElement *roomConfigField = [NSXMLElement elementWithName:@"field" children:@[roomConfigValue] attributes:@[roomConfigFieldAttri]];
    [roomSettings addChild:roomConfigField];
    
    //room description
    NSXMLElement *roomDescriptionFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomDescriptionNameSpace];
    NSXMLElement *roomDescription = [NSXMLElement elementWithName:@"value" stringValue:configModel.description];
    NSXMLElement *roomDescriptionField = [NSXMLElement elementWithName:@"field" children:@[roomDescription] attributes:@[roomDescriptionFieldAttri]];
    [roomSettings addChild:roomDescriptionField];
    
    //room name
    NSXMLElement *roomNameFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomNameNameSpace];
    NSXMLElement *roomName = [NSXMLElement elementWithName:@"value" stringValue:configModel.name];
    NSXMLElement *roomNameField = [NSXMLElement elementWithName:@"field" children:@[roomName] attributes:@[roomNameFieldAttri]];
    [roomSettings addChild:roomNameField];
    
    //room enable logging
    NSXMLElement *roomEnableLoggingFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomEnableLogging];
    NSXMLElement *roomEnableLoggin = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.enableLogging)];
    NSXMLElement *roomEnableLoggingField = [NSXMLElement elementWithName:@"field" children:@[roomEnableLoggin] attributes:@[roomEnableLoggingFieldAttri]];
    [roomSettings addChild:roomEnableLoggingField];
    
    //room change subject
    NSXMLElement *roomChangeSubjectFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomChangeSubject];
    NSXMLElement *roomChangeSubject = [NSXMLElement elementWithName:@"value" stringValue:configModel.subject];
    NSXMLElement *roomChangeSubjectField = [NSXMLElement elementWithName:@"field" children:@[roomChangeSubject] attributes:@[roomChangeSubjectFieldAttri]];
    [roomSettings addChild:roomChangeSubjectField];
    
    //room allow invites
    NSXMLElement *roomAllowIniviteFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomAllowInivtes];
    NSXMLElement *roomAllowInivite = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.allowInivite)];
    NSXMLElement *roomAllowIniviteField = [NSXMLElement elementWithName:@"field" children:@[roomAllowInivite] attributes:@[roomAllowIniviteFieldAttri]];
    [roomSettings addChild:roomAllowIniviteField];
    
    //room allow private message
    NSXMLElement *roomAllowPrivateMsgFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomAllowPrivateMessage];
    NSXMLElement *roomAllowPrivateMsg = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.allowPrivateMsg)];
    NSXMLElement *roomAllowPrivateMsgField = [NSXMLElement elementWithName:@"field" children:@[roomAllowPrivateMsg] attributes:@[roomAllowPrivateMsgFieldAttri]];
    [roomSettings addChild:roomAllowPrivateMsgField];
    
    //room allow user
    NSXMLElement *roomMaxUserFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomMaxUser];
    NSXMLElement *roomMaxUser = [NSXMLElement elementWithName:@"value" stringValue:StringInt(configModel.maxUserCount)];
    NSXMLElement *roomMaxUserField = [NSXMLElement elementWithName:@"field" children:@[roomMaxUser] attributes:@[roomMaxUserFieldAttri]];
    [roomSettings addChild:roomMaxUserField];
    
    //room allow max history messages
    NSXMLElement *roomAllowMaxHistoryMsgCountFieldAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomReturnMaxHistoryMessagesCount];
    NSXMLElement *roomAllowMaxHistoryMsgCount = [NSXMLElement elementWithName:@"value" stringValue:StringInt(configModel.maxHistoryMessageReturnCount)];
    NSXMLElement *roomAllowMaxHistoryMsgCountField = [NSXMLElement elementWithName:@"field" children:@[roomAllowMaxHistoryMsgCount] attributes:@[roomAllowMaxHistoryMsgCountFieldAttri]];
    [roomSettings addChild:roomAllowMaxHistoryMsgCountField];
    
    //room allow broadcast
    NSXMLElement *roomBroadcaseAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomBroadCastUserType];
    NSXMLElement *roomBroadcase = [NSXMLElement elementWithName:@"value" stringValue:configModel.whoCanBroadCastMsg];
    NSXMLElement *roomBroadcaseField = [NSXMLElement elementWithName:@"field" children:@[roomBroadcase] attributes:@[roomBroadcaseAttri]];
    [roomSettings addChild:roomBroadcaseField];
    
    //room owner
    NSXMLElement *roomOwnerAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomOwners];
    NSXMLElement *roomOwnerValue = [NSXMLElement elementWithName:@"value" stringValue:configModel.owner];
    NSXMLElement *roomOwnerField = [NSXMLElement elementWithName:@"field" children:@[roomOwnerValue] attributes:@[roomOwnerAttri]];
    [roomSettings addChild:roomOwnerField];
    
    //persist room
    NSXMLElement *roomPersistAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomPersistRoom];
    NSXMLElement *roomPersistValue = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.needPersistThisRoom)];
    NSXMLElement *roomPersistField = [NSXMLElement elementWithName:@"field" children:@[roomPersistValue] attributes:@[roomPersistAttri]];
    [roomSettings addChild:roomPersistField];
    
    //public room
    NSXMLElement *roomPublicAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomPublicRoom];
    NSXMLElement *roomPublicValue = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.isThisPublicRoom)];
    NSXMLElement *roomPublicField = [NSXMLElement elementWithName:@"field" children:@[roomPublicValue] attributes:@[roomPublicAttri]];
    [roomSettings addChild:roomPublicField];
    
    //language
    NSXMLElement *roomlanguageAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomLanguageNameSpace];
    NSXMLElement *roomlanguageValue = [NSXMLElement elementWithName:@"value" stringValue:@"chinese"];
    NSXMLElement *roomlanguageField = [NSXMLElement elementWithName:@"field" children:@[roomlanguageValue] attributes:@[roomlanguageAttri]];
    [roomSettings addChild:roomlanguageField];
    
    //language
    NSXMLElement *roomMemberListAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomGetMemeberList];
    NSXMLElement *roomMemberListValue = [NSXMLElement elementWithName:@"value" stringValue:configModel.whoCanGetRoomMemberList];
    NSXMLElement *roomMemberListField = [NSXMLElement elementWithName:@"field" children:@[roomMemberListValue] attributes:@[roomMemberListAttri]];
    [roomSettings addChild:roomMemberListField];
    
    //admin room
    NSXMLElement *roomAdminOnlyAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomAdminHasThisRoom];
    NSXMLElement *roomAdminOnlyValue = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.isRoomForAdminOnly)];
    NSXMLElement *roomAdminOnlyField = [NSXMLElement elementWithName:@"field" children:@[roomAdminOnlyValue] attributes:@[roomAdminOnlyAttri]];
    [roomSettings addChild:roomAdminOnlyField];
    
    //member only
    NSXMLElement *roomMemeberOnlyAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomMakeForMemberOnly];
    NSXMLElement *roomMemeberOnlyValue = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.isRoomForMemberOnly)];
    NSXMLElement *roomMemeberOnlyField = [NSXMLElement elementWithName:@"field" children:@[roomMemeberOnlyValue] attributes:@[roomMemeberOnlyAttri]];
    [roomSettings addChild:roomMemeberOnlyField];
    
    //password protect
    NSXMLElement *roomPasswordProtectAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomPasswordProtected];
    NSXMLElement *roomPasswordProtectValue = [NSXMLElement elementWithName:@"value" stringValue:StringBOOL(configModel.needPasswordProtect)];
    NSXMLElement *roomPasswordProtectField = [NSXMLElement elementWithName:@"field" children:@[roomPasswordProtectValue] attributes:@[roomPasswordProtectAttri]];
    [roomSettings addChild:roomPasswordProtectField];
    
    //who can discovery
    NSXMLElement *roomDiscoveryAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomWhoCanDiscoveryJID];
    NSXMLElement *roomDiscoveryValue = [NSXMLElement elementWithName:@"value" stringValue:configModel.whoCanDiscoveryOthersJID];
    NSXMLElement *roomDiscoveryField = [NSXMLElement elementWithName:@"field" children:@[roomDiscoveryValue] attributes:@[roomDiscoveryAttri]];
    [roomSettings addChild:roomDiscoveryField];
    
    //set admin
    NSXMLElement *roomSetAdminAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomSetAdmins];
    NSMutableArray *roomSetAdminvalues = [NSMutableArray array];
    [configModel.admins enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *adminJID = (NSString*)obj;
        NSXMLElement *roomSetAdminValue = [NSXMLElement elementWithName:@"value" stringValue:adminJID];
        [roomSetAdminvalues addObject:roomSetAdminValue];
    }];
    NSXMLElement *roomSetAdminField = [NSXMLElement elementWithName:@"field" children:roomSetAdminvalues attributes:@[roomSetAdminAttri]];
    [roomSettings addChild:roomSetAdminField];
    
    //开启密码需要密码验证
    if (configModel.needPasswordProtect) {
        
        //set passsword
        NSXMLElement *roomSecretAttri = [NSXMLElement attributeWithName:@"var" stringValue:XMPPMUCRoomRoomSecrect];
        NSXMLElement *roomSecretValue = [NSXMLElement elementWithName:@"value" stringValue:configModel.secret];
        NSXMLElement *roomSecretField = [NSXMLElement elementWithName:@"field" children:@[roomSecretValue] attributes:@[roomSecretAttri]];
        [roomSettings addChild:roomSecretField];
    }
   
    return roomSettings;
}

+ (NSString*)realRoomJIDWithID:(NSString *)qId withHostName:(NSString *)host
{
    return [NSString stringWithFormat:@"%@@conference.%@",qId,host];
}
@end
