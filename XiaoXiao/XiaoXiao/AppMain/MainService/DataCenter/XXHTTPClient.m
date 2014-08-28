//
//  XXHTTPClient.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation XXHTTPClient

+ (XXHTTPClient*)shareClient
{
    static XXHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:XXBase_Host_Url]];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"text/json",@"text/javascript",@"application/json",@"text/html",@"application/xhtml+xml",@"*/*",@"application/xhtml+xml",@"image/webp", nil]];
    [self setDefaultHeader:@"token" value:[XXUserDataCenter currentLoginUserToken]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    
    return self;
}
- (void)updateToken
{
    [self setDefaultHeader:@"token" value:[XXUserDataCenter currentLoginUserToken]];
}

@end
