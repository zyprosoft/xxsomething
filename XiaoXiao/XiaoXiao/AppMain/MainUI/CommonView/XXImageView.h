//
//  XXImageView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"

@interface XXImageView : UIView
{
    UIImageView *_contentImageView;
    DAProgressOverlayView *_overlayView;
    BOOL needOverlay;
}
@property (nonatomic,strong)UIImageView *contentImageView;

- (id)initWithFrame:(CGRect)frame withNeedOverlay:(BOOL)needState;
- (void)setImageUrl:(NSString*)imageUrl;
- (void)setContentImage:(UIImage*)image;
- (void)uploadImageWithProgress:(CGFloat)progress;
- (void)setContentImageViewFrame:(CGRect)frame;

@end
