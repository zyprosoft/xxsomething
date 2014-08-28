//
//  BFImageScroller.h
//  PPFIphone
//
//  Created by ZYVincent on 13-7-12.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+Screenshot.h"
#import "UIView+Screenshot.h"

@interface BFImageScroller : UIScrollView<UIScrollViewDelegate>
{
}
@property (nonatomic,retain)UIImageView *contentImageView;

- (id)initWithFrame:(CGRect)frame withTopVisiableHeight:(CGFloat)topVisiableHeight;

@end
