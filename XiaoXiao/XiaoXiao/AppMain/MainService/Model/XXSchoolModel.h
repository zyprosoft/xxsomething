//
//  XXSchoolModel.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXSchoolModel : NSObject
@property (nonatomic,strong)NSString *schoolId;
@property (nonatomic,strong)NSString *schoolName;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *searchKeyword;//搜索列表的时候可用

- (id)initWithContentDict:(NSDictionary*)contentDict;

@end
