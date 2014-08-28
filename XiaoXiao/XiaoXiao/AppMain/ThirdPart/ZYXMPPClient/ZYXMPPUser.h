//
//  ZYXMPPUser.h
//  ZYXMPPClient
//
//  Created by barfoo2 on 13-9-5.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYXMPPUser : NSObject
@property (nonatomic,strong)NSString *jID;
@property (nonatomic,strong)NSString *user;
@property (nonatomic,strong)NSString *domain;
@property (nonatomic,strong)NSString *resource;
@property (nonatomic,strong)NSString *state;
@property (nonatomic,strong)NSString *password;
@property (nonatomic,strong)NSString *roomId;
@property (nonatomic,strong)NSString *nickName;

@end
