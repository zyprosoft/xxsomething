//
//  XXFileUitil.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-17.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXFileUitil : NSObject

+ (NSDictionary*)loadDictionaryFromBundleForName:(NSString*)fileName;
+ (NSArray*)loadArrayFromBundleForName:(NSString*)fileName;
+ (NSData*)loadDataFromBundleForName:(NSString*)fileName;
+ (NSString*)loadStringFromBundleForName:(NSString*)fileName;

+ (NSDictionary*)loadDictionaryFromBundleForName:(NSString*)fileName withType:(NSString*)typeName;
+ (NSArray*)loadArrayFromBundleForName:(NSString*)fileName withType:(NSString*)typeName;

+ (NSData*)loadDataFromBundleForName:(NSString*)fileName withType:(NSString*)typeName;
+ (NSString*)loadStringFromBundleForName:(NSString*)fileName withType:(NSString*)typeName;


+ (NSString*)documentFilePathWithFileName:(NSString*)fileName;
+ (NSString*)documentFilePathWithDirectorName:(NSString*)directorName withFileName:(NSString*)fileName;

@end
