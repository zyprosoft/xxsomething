//
//  ZYXMPPMessage.m
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "ZYXMPPMessage.h"

@implementation ZYXMPPMessage
- (id)init
{
    if (self = [super init]) {
        
        self.content = @"";
        self.sendStatus = @"0";
        self.user = @"";
        self.userId = @"";
        self.messageId = @"";
        self.messageType = @"";
        self.addTime = @"";
        self.audioTime = @"";
        self.groupRoomId = @"";
        self.isReaded = @"0";
        self.friendAddTime = @"";
    }
    return self;
}
+ (NSString*)conversationIdWithOtherUserId:(NSString *)oId withMyUserId:(NSString *)myId
{
    return [NSString stringWithFormat:@"%@_%@",oId,myId];
}
+ (NSAttributedString*)attributedContentStringWithMessage:(ZYXMPPMessage*)aMessage
{
    NSString *destContent = Nil;
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            destContent = aMessage.content;
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            destContent = @"图片";
        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            destContent = @"语音";
        }
            break;
        default:
            break;
    }
    return [XXBaseTextView formatteCommonTextToAttributedText:destContent];
}
+ (NSAttributedString*)userHeadAttributedStringWithMessage:(ZYXMPPMessage *)aMessage
{
    XXCommentModel *convertCommentModel = [[XXCommentModel alloc]init];
    convertCommentModel.userName = aMessage.user;
    convertCommentModel.sex = aMessage.sendUserSex;
    if ([aMessage.messageType intValue]==ZYXMPPMessageTypeAudio) {
        convertCommentModel.schoolName = @"语音";
    }
    if ([aMessage.messageType intValue]==ZYXMPPMessageTypeImage) {
        convertCommentModel.schoolName = @"图片";
    }
    if ([aMessage.messageType intValue]==ZYXMPPMessageTypeText) {
        convertCommentModel.schoolName = aMessage.content;
    }
    convertCommentModel.grade = aMessage.sendUserSchoolName;
    
    XXSharePostUserStyle *style = [[XXSharePostUserStyle alloc]init];
    style.nameDes.fontSize = 12.5;
    style.nameDes.fontWeight = XXFontWeightNormal;
    
    NSAttributedString *resultAttributedString = [XXSharePostUserView useHeadAttributedStringWithCommnetModelForMessageList:convertCommentModel withShareUserPostStyle:style];
    
    return resultAttributedString;
}

@end
