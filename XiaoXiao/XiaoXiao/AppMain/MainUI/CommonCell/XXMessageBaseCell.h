//
//  XXMessageBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSharePostUserView.h"
#import "XXHeadView.h"
#import "XXBaseTextView.h"
#import "XXCommentModel.h"
#import "XXBaseCell.h"
#import "XXRecordButton.h"
#import "ZYXMPPMessage.h"
#import "JSBadgeView.h"

@class XXMessageBaseCell;
@protocol XXMessageBaseCellDelegate <NSObject>
- (void)messageBaseCellDidCallLongTapDelete:(XXMessageBaseCell*)cell;
@end

@interface XXMessageBaseCell : XXBaseCell
{
    XXHeadView *_headView;
    XXSharePostUserView *_userHeadView;
    XXBaseTextView *_contentTextView;
    UILabel        *_recieveTimeLabel;
    XXRecordButton *_recordButton;
    JSBadgeView    *_badgeRemindView;
}
@property (nonatomic,weak)id<XXMessageBaseCellDelegate> delegate;

- (void)setCommentModel:(XXCommentModel*)aComment;
- (void)setXMPPMessage:(ZYXMPPMessage*)aMessage;

@end
