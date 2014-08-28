//
//  XXUserCacheCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface XXUserCacheCenter : NSObject
{
    FMDatabase *_innerDataBase;
}
+ (XXUserCacheCenter *)shareCenter;

- (void)saveUser:(XXUserModel*)aUser;
- (XXUserModel*)returnUserInfoById:(NSString*)userId;

- (void)saveStrolledSchool:(XXSchoolModel*)schoolModel;
- (void)returnHistoryStrollSchoolWithResult:(void (^) (NSArray*resultArray))result;

@end
