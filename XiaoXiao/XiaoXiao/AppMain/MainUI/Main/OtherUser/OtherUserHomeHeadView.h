//
//  OtherUserHomeHeadView.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserHomeHeadView : UIView
{
    XXImageView *_themeBackgroundView;
    UIImageView *_infoBackgroundView;
    XXHeadView  *_headView;
    UILabel     *_nameLabel;
    UIImageView *_sexImageView;
    UILabel     *_starLabel;
    
    UILabel     *_distanceLabel;
    UILabel     *_timeLabel;
    
    XXOpacityView *_wellknowView;
    UIImageView  *timeView;
    
    XXCustomButton *_teaseButton;
}
- (void)setContentUser:(XXUserModel*)aUser;

- (void)addTagert:(id)target forTeaseAction:(SEL)teaseAction;

- (void)updateUserCared:(BOOL)isCared;

@end
