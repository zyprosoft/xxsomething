//
//  XXConditionModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-24.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXConditionModel : NSObject
@property (nonatomic,copy)NSString *pageSize;
@property (nonatomic,copy)NSString *pageIndex;
@property (nonatomic,strong)NSString *keyword;
@property (nonatomic,strong)NSString *resId;
@property (nonatomic,strong)NSString *resType;
@property (nonatomic,strong)NSString *pId;
@property (nonatomic,strong)NSString *rootId;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *grade;
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *tag;
@property (nonatomic,strong)NSString *wellknow;
@property (nonatomic,strong)NSString *commentId;
@property (nonatomic,strong)NSString *postId;
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *desc;
@property (nonatomic,strong)NSString *toUserId;
@property (nonatomic,strong)NSString *isReaded;
@property (nonatomic,strong)NSString *praiseId;
@property (nonatomic,strong)NSString *userWellKnowRank;
@property (nonatomic,strong)NSString *userScoreRank;
@property (nonatomic,strong)NSString *schoolRoll;
@property (nonatomic,assign)BOOL     isRefresh;
@property (nonatomic,assign)BOOL     hideLoadMore;
@property (nonatomic,assign)long     latitude;
@property (nonatomic,assign)long     longtitude;

@end
