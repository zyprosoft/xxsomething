//
//  XXPraiseModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXPraiseModel : NSObject
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *nickname;
@property (nonatomic,strong)NSString *paiseTIme;
@property (nonatomic,strong)NSString *friendlyTime;

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
