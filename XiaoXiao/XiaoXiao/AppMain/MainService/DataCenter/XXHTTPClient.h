//
//  XXHTTPClient.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "AFHTTPClient.h"

@interface XXHTTPClient : AFHTTPClient
+ (XXHTTPClient*)shareClient;
- (void)updateToken;
@end
