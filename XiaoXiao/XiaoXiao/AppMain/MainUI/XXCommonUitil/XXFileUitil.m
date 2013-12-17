//
//  XXFileUitil.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXFileUitil.h"

@implementation XXFileUitil


+ (NSDictionary*)loadDictionaryFromBundleForName:(NSString *)fileName
{
    if ([fileName rangeOfString:@"."].location==NSNotFound) {
        DDLogWarn(@"could not load from bundle with no file type!");
        return nil;
    }
    
    NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
    
    return [XXFileUitil loadDictionaryFromBundleForName:[fileNames objectAtIndex:0] withType:[fileNames objectAtIndex:1]];
}
+ (NSArray*)loadArrayFromBundleForName:(NSString *)fileName
{
    if ([fileName rangeOfString:@"."].location==NSNotFound) {
        DDLogWarn(@"could not load from bundle with no file type!");
        return nil;
    }
    
    NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
    
    return [XXFileUitil loadArrayFromBundleForName:[fileNames objectAtIndex:0] withType:[fileNames objectAtIndex:1]];
}
+ (NSData*)loadDataFromBundleForName:(NSString *)fileName
{
    if ([fileName rangeOfString:@"."].location==NSNotFound) {
        DDLogWarn(@"could not load from bundle with no file type!");
        return nil;
    }
    
    NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
    
    return [XXFileUitil loadDataFromBundleForName:[fileNames objectAtIndex:0] withType:[fileNames objectAtIndex:1]];
}
+ (NSString*)loadStringFromBundleForName:(NSString *)fileName
{
    if ([fileName rangeOfString:@"."].location==NSNotFound) {
        DDLogWarn(@"could not load from bundle with no file type!");
        return nil;
    }
    
    NSArray *fileNames = [fileName componentsSeparatedByString:@"."];
    
    return [XXFileUitil loadStringFromBundleForName:[fileNames objectAtIndex:0] withType:[fileNames objectAtIndex:1]];
}

+ (NSData*)loadDataFromBundleForName:(NSString *)fileName withType:(NSString *)typeName
{
    NSData *resultData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:typeName]];
    
    return resultData;
}
+ (NSDictionary*)loadDictionaryFromBundleForName:(NSString *)fileName withType:(NSString *)typeName
{
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:typeName]];
}
+ (NSArray*)loadArrayFromBundleForName:(NSString *)fileName withType:(NSString *)typeName
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:typeName]];
}
+ (NSString*)loadStringFromBundleForName:(NSString *)fileName withType:(NSString *)typeName
{
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:typeName] encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString*)documentFilePathWithFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *lastPath = [paths lastObject];
    
    return [lastPath stringByAppendingPathComponent:fileName];
}

+ (NSString*)documentFilePathWithDirectorName:(NSString *)directorName withFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *lastPath = [paths lastObject];
    NSString *directorPath = [lastPath stringByAppendingPathComponent:directorName];
    
    return [directorPath stringByAppendingPathComponent:fileName];
}

@end
