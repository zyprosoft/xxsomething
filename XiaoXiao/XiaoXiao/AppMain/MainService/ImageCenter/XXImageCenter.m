//
//  XXImageCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXImageCenter.h"
#import "XXImageSaveOperation.h"

#define ChatImageCacheDir @"xxchat_image_cache"
@implementation XXImageCenter
- (id)init
{
    if (self = [super init]) {
        
        _saveQueue = [[NSOperationQueue alloc]init];
    }
    return self;
}
+ (XXImageCenter*)shareCenter
{
    static XXImageCenter *cacheCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!cacheCenter) {
            cacheCenter = [[XXImageCenter alloc]init];
        }
    });
    return cacheCenter;
}
- (NSString*)rootPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths lastObject]stringByAppendingPathComponent:ChatImageCacheDir];
}
- (NSString*)getTimeStamp
{
    NSTimeInterval nowInterval = [[NSDate date]timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%d.jpg",(int)nowInterval];
}
- (NSString*)saveChatImageForLocal:(UIImage *)aImage
{
    NSString *timeNow = [self getTimeStamp];
    NSString *cachePath = [[self rootPath]stringByAppendingPathComponent:timeNow];
    NSData *imageData = UIImageJPEGRepresentation(aImage,kCGInterpolationDefault);
    [imageData writeToFile:cachePath atomically:YES];
    
    return cachePath;
    
}
- (UIImage*)getChatLocalImage:(NSString*)cachePath
{
    DDLogVerbose(@"get lcoal image path:%@",cachePath);
    UIImage *imageCache = [UIImage imageWithData:[NSData dataWithContentsOfFile:cachePath]];
    DDLogVerbose(@"cached image:%@",imageCache);
    return imageCache;
}

@end
