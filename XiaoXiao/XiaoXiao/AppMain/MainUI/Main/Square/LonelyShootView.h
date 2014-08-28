//
//  LonelyShootView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LonelyShootViewDelegate <NSObject>

- (void)lonelyShootViewDidFinishShoot;

@end
@interface LonelyShootView : UIView
{
    
}
@property (nonatomic,strong)UIImageView *gongFirstState;
@property (nonatomic,strong)UIImageView *gongSecondState;
@property (nonatomic,strong)UIImageView *arrow;
@property (nonatomic,strong)UIView      *tapView;
@property (nonatomic,assign)CGPoint      lastTapPoint;
@property (nonatomic,assign)BOOL         isPulling;
@property (nonatomic,weak)id<LonelyShootViewDelegate> delegate;

@end
