//
//  XXUserInfoBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseTextView.h"
#import "XXUserModel.h"
#import "XXHeadView.h"
#import "XXBaseCell.h"
#import "XXBadgeView.h"

@class XXUserInfoBaseCell;
@protocol XXUserInfoBaseCellDelegate <NSObject>

- (void)userInfoBaseCellDidTapOnHeadView:(XXUserInfoBaseCell*)cell;

@end
@interface XXUserInfoBaseCell : XXBaseCell
{
    XXBaseTextView *contentTextView;
    XXHeadView     *headView;
    XXBadgeView    *remindNewImgView;
}
@property (nonatomic,weak)id<XXUserInfoBaseCellDelegate> delegate;
@property (nonatomic,strong)UILabel  *visitTimeLabel;

+ (NSAttributedString*)buildAttributedStringWithUserModel:(XXUserModel*)userModel;

- (void)setContentModel:(XXUserModel*)userModel;

+ (CGFloat)heightWithContentModel:(XXUserModel*)userModel;

@end
