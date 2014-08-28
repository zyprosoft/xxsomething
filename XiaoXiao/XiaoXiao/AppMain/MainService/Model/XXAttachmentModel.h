//
//  XXAttachmentModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-23.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXAttachmentModel : NSObject
@property (nonatomic,strong)NSString *attachementId;
@property (nonatomic,strong)NSString *createUserId;
@property (nonatomic,strong)NSString *description;
@property (nonatomic,strong)NSString *link;
@property (nonatomic,strong)NSString *fileName;
@property (nonatomic,strong)NSString *addTime;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
