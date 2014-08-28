//
//  XXCacheCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

#define XXCacheCenterSchoolDefaultVersion @"1.0"
#define XXCacheCenterSchoolVersionUDF @"XXCacheCenterSchoolVersionUDF"

@interface XXCacheCenter : NSObject
{
    FMDatabase *_innerDataBase;
}
+ (XXCacheCenter *)shareCenter;
- (void)updateSchoolDataBaseNow;
- (void)searchSchoolWithKeyword:(NSString*)keyword withResult:(void (^) (NSArray*resultArray))result withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize;
- (void)searchSchoolWithKeyword:(NSString*)keyword withResult:(void (^) (NSArray*resultArray))result;
- (NSString*)returnUserCityBySchoolId:(NSString*)schoolId;
- (NSString*)returnUserProvinceBySchoolId:(NSString*)schoolId;
- (NSString*)returnSchoolNameBySchoolId:(NSString*)schoolId;

- (NSString*)returnUserSchoolTypeBySchoolId:(NSString*)schoolId;
- (void)searchSchoolWithCityName:(NSString*)cityName withResult:(void (^) (NSArray*resultArray))result withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize;
- (void)searchSchoolWithCityName:(NSString*)cityName withResult:(void (^) (NSArray*resultArray))result withPageIndex:(NSInteger)pageIndex withPageSize:(NSInteger)pageSize withSchoolType:(NSString*)schoolType;
@end
