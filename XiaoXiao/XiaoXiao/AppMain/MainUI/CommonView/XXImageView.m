//
//  XXImageView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXImageView.h"

@implementation XXImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        _contentImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentImageView];
        needOverlay = NO;
        
//        _overlayView = [[DAProgressOverlayView alloc]initWithFrame:_contentImageView.bounds];
//        [_contentImageView addSubview:_overlayView];

    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withNeedOverlay:(BOOL)needState
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:_contentImageView];
        
        _overlayView = [[DAProgressOverlayView alloc]initWithFrame:_contentImageView.bounds];
        [_contentImageView addSubview:_overlayView];
        needOverlay = needState;
    }
    return self;
}
- (void)setContentImageViewFrame:(CGRect)frame
{
    _contentImageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
}
- (void)setImageUrl:(NSString *)imageUrl
{
    imageUrl = [NSString stringWithFormat:@"%@%@/%d/%d%@",XXBase_Host_Url,XX_Image_Resize_Url,(int)self.frame.size.width*2,(int)self.frame.size.height*2,imageUrl];
    DDLogVerbose(@"theme back image :%@",imageUrl);
    if (needOverlay) {
        WeakObj(_contentImageView) weakContentView = _contentImageView;
        [_contentImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed|SDWebImageLowPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakContentView.image = image;
        }];
    }else{
        [_contentImageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
}
- (void)uploadImageWithProgress:(CGFloat)progress
{
    [_overlayView setProgress:progress];
}
- (void)setContentImage:(UIImage *)image
{
    _contentImageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
