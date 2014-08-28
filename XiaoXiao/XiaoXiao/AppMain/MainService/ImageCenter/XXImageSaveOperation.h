//
//  XXImageSaveOperation.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-7.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXImageSaveOperation : NSOperation
{
    NSString *_sPath;
    UIImage  *_sImage;
}
- (id)initWithImage:(UIImage*)aImage withSavePath:(NSString*)savePath;
@end
