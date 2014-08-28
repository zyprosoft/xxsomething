//
//  BFImageScroller.m
//  PPFIphone
//
//  Created by barfoo2 on 13-7-12.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "BFImageScroller.h"

@implementation BFImageScroller
@synthesize contentImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,frame.size.height)];
        [self addSubview:contentImageView];
        self.delegate = self;
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withTopVisiableHeight:(CGFloat)topVisiableHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,topVisiableHeight,frame.size.width,frame.size.height)];
        [self addSubview:contentImageView];
        self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Scroller delegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return contentImageView;
}

@end
