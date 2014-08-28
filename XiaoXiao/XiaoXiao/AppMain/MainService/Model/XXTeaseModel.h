//
//  XXTeaseModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXUserModel.h"

@interface XXTeaseModel : NSObject
@property (nonatomic,strong)NSString *postContent;
@property (nonatomic,strong)NSString *postEmoji;

@property (nonatomic,strong)NSString *teaseId;
@property (nonatomic,strong)NSString *teaseTime;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *toUserId;
@property (nonatomic,strong)NSAttributedString *userHeadContent;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *grade;
@property (nonatomic,strong)NSString *friendTeaseTime;
@property (nonatomic,strong)NSString *schoolName;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)XXUserModel *sendFromUser;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
