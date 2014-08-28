//
//  XXCommentCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXRecordButton.h"

@class XXCommentCell;
@protocol XXCommentCellDelegate <NSObject>

- (void)commentCellDidTapOnAudioButton:(XXCommentCell*)commentCell;
- (void)commentCellDidCallReplyThisComment:(XXCommentCell *)commentCell;
@end

@interface XXCommentCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    
    XXHeadView *_headView;
    XXSharePostUserView *_userView;

    XXBaseTextView *_contentTextView;
    UILabel *_nameLabel;
    XXRecordButton  *_audioButton;
    UILabel     *_timeLabel;
    UIImageView *_sexImageView;
    UILabel     *_replyWhoLabel;
    
    //
    CGFloat     _leftMargin;
    CGFloat     _topMargin;
    CGFloat     _innerMargin;
    CGFloat     _timeFontSize;
    
    XXShareStyle *_contentStyle;
    
    //data
    NSString    *_audioUrl;
    
    //reply button
    UIButton    *_replyThisCommentBtn;
    
}
@property (nonatomic,weak)id<XXCommentCellDelegate> delegate;
@property (nonatomic,strong)UIButton    *replyThisCommentBtn;

- (void)setCellType:(XXBaseCellType)cellType;
- (void)setCommentModel:(XXCommentModel*)contentModel;
+ (CGFloat)heightForCommentModel:(XXCommentModel*)contentModel forWidth:(CGFloat)width;

- (void)startAudioPlay;
- (void)endAudioPlay;
- (void)startLoadingAudio;
- (void)endLoadingAudio;

@end
