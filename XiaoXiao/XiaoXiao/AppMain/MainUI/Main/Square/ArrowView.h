//
//  ArrowView.h
//  ArrowAnimation
//
//  Created by aclct on 14-2-17.
//  Copyright (c) 2014年 AC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArrowView;
@protocol ArrowViewDelegate <NSObject>

@optional

- (void)arrowMoveFinished:(ArrowView *)arrowView;

@end

@interface ArrowView : UIView
{
    UIImageView *tieTop;
    UIImageView *tieBottom;
}
@property (nonatomic,weak)id<ArrowViewDelegate> delegate;

@end
