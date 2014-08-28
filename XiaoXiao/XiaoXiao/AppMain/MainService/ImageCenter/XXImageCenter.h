//
//  XXImageCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXImageCenter : NSObject
{
    NSOperationQueue *_saveQueue;
}
+ (XXImageCenter*)shareCenter;
- (NSString*)saveChatImageForLocal:(UIImage*)aImage;
- (UIImage*)getChatLocalImage:(NSString*)cachePath;
@end
