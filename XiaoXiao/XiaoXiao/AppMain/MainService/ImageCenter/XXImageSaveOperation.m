//
//  XXImageSaveOperation.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-3-7.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXImageSaveOperation.h"

@implementation XXImageSaveOperation
- (id)initWithImage:(UIImage *)aImage withSavePath:(NSString *)savePath
{
    if (self = [super init]) {
    
        _sImage = aImage;
        _sPath = savePath;

    }
    return self;
}

- (void)main
{
    NSData *imageData = UIImagePNGRepresentation(_sImage);
    BOOL saveImageResult = [imageData writeToFile:_sPath atomically:YES];
    DDLogVerbose(@"saveImage result :%d",saveImageResult);
}

@end
