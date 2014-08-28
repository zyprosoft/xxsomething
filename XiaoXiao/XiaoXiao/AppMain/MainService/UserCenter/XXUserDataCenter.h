//
//  XXUserDataCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXUserModel.h"

@interface XXUserDataCenter : NSObject
+ (XXUserModel*)currentLoginUser;
+ (void)loginThisUser:(XXUserModel*)aUser;
+ (void)currentUserLoginOut;
+ (NSString*)currentLoginUserToken;
+ (BOOL)checkLoginUserInfoIsWellDone;

@end
