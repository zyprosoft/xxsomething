//
//  XXChatCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYXMPPMessage.h"
#import "XXBaseCell.h"
#import "XXImageView.h"

@class XXChatCell;
@protocol XXChatCellDelegate   <NSObject>
- (void)chatCellDidTapOnRecord:(XXChatCell*)chatCell;
- (void)chatCellDidTapOnImageView:(XXChatCell*)chatCell withContentImageView:(XXImageView*)aImageView;
@end

@interface XXChatCell : XXBaseCell
{
    XXHeadView *_headView;
    UIImageView *_bubbleBackView;
    XXBaseTextView *_contentTextView;
    
    XXRecordButton *_recordButton;
    UIActivityIndicatorView *_activeView;
    
    XXImageView *_contentImageView;
    UILabel     *_timeLabel;
    
}
@property (nonatomic,weak)id<XXChatCellDelegate> delegate;

- (void)setXMPPMessage:(ZYXMPPMessage*)aMessage;
+ (CGFloat)heightWithXMPPMessage:(ZYXMPPMessage*)aMessage  forWidth:(CGFloat)width;
- (void)setSendingState:(BOOL)state;

- (void)startAudioPlay;
- (void)endAudioPlay;
- (void)startLoadingAudio;
- (void)endLoadingAudio;

@end
