//
//  XXCommentModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXCommentModel : NSObject
@property (nonatomic,strong)NSString *commentId;
@property (nonatomic,strong)NSString *resourceType;
@property (nonatomic,strong)NSString *resourceId;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *pCommentId;
@property (nonatomic,strong)NSString *rootCommentId;
@property (nonatomic,strong)NSString *addTime;
@property (nonatomic,strong)NSString *friendAddTime;
@property (nonatomic,strong)NSString *postAudio;
@property (nonatomic,strong)NSString *postAudioTime;
@property (nonatomic,strong)NSString *postContent;
@property (nonatomic,strong)NSString *schoolName;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *grade;
@property (nonatomic,strong)NSString *toUserId;
@property (nonatomic,strong)NSString *toUserName;
@property (nonatomic,strong)NSAttributedString *contentAttributedString;
@property (nonatomic,strong)NSAttributedString *userHeadContent;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
