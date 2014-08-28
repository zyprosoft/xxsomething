//
//  ZYImageFilter.h
//  ZYProSoft
//
//  Created by ZYVincent on 14-1-2.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InstaFilters.h"
#import "GPUImage.h"

/*
 库文件支持
 QuartzCore,AVFoundation,OpenGLES,CoreMedia,CoreVideo
 */
@interface ZYImageFilter : GPUImageVideoCamera
@property (nonatomic, strong) UIImage *rawImage;
@property (strong, readonly) GPUImageView *gpuImageView;
@property (strong, readonly) GPUImageView *gpuImageView_HD;

- (id)initWithSaveQuality:(BOOL)isHighQuality withShowEffectImageViewFrame:(CGRect)showFrame;

- (UIImage*)currentEffectImage;
- (void)saveCurrentStillImage;
- (void)switchFilter:(IFFilterType)type;

@end
