//
//  XXMessageBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXMessageBaseCell.h"

@implementation XXMessageBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = rgb(255,255,255,1);
        _cellLineImageView.frame = CGRectMake(0,74,self.frame.size.width,1);
        _cellLineImageView.hidden = NO;
        
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin,_topMargin*2,50,50)];
        [self.contentView addSubview:_headView];
        
        //
        _badgeRemindView = [[JSBadgeView alloc]initWithParentView:_headView alignment:JSBadgeViewAlignmentTopLeft];
        [_badgeRemindView setBadgeBackgroundColor:[UIColor redColor]];
        [_badgeRemindView setBadgeTextColor:[UIColor whiteColor]];
        [_badgeRemindView setBadgeShadowColor:[UIColor clearColor]];
        [_badgeRemindView setBadgeShadowSize:CGSizeMake(0,0)];
        [_badgeRemindView setBadgeStrokeColor:[UIColor redColor]];
        _badgeRemindView.hidden = YES;
        
        _userHeadView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(_leftMargin+_headView.frame.size.width+_leftMargin,_topMargin*2,self.contentView.frame.size.width-2*_leftMargin-_headView.frame.size.width-_leftMargin,60)];
        _userHeadView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_userHeadView];
        
        _recieveTimeLabel = [[UILabel alloc]init];
        _recieveTimeLabel.frame = CGRectMake(150,55,150,20);
        _recieveTimeLabel.backgroundColor = [UIColor clearColor];
        _recieveTimeLabel.textAlignment = NSTextAlignmentRight;
        _recieveTimeLabel.font = [UIFont systemFontOfSize:11];
        _recieveTimeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        [self.contentView addSubview:_recieveTimeLabel];
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        normalBack.backgroundColor = [XXCommonStyle xxThemeDefaultSelectedColor];
        self.selectedBackgroundView = normalBack;
        
        //long tap delete action
        UILongPressGestureRecognizer *longTapR = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
        [self.contentView addGestureRecognizer:longTapR];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCommentModel:(XXCommentModel *)aComment
{
    [_headView setRoundHeadWithUserId:aComment.userId];
    [_userHeadView setCommentModel:aComment];
    _recieveTimeLabel.text = aComment.friendAddTime;
}
- (void)setXMPPMessage:(ZYXMPPMessage *)aMessage
{
    _recieveTimeLabel.text = aMessage.friendAddTime;
    [_headView setRoundHeadWithUserId:aMessage.userId];
    [_userHeadView setXMPPMessage:aMessage];
    NSString *newMsgCount = [[XXChatCacheCenter shareCenter]getConversationNewMsgCount:aMessage.conversationId];
    if ([newMsgCount intValue]==0) {
        _badgeRemindView.hidden = YES;
    }else{
        _badgeRemindView.hidden = NO;
        [_badgeRemindView setBadgeText:newMsgCount];
    }
}

- (void)longTapAction:(UILongPressGestureRecognizer*)longTapR
{
    if ([self.delegate respondsToSelector:@selector(messageBaseCellDidCallLongTapDelete:)]) {
        [self.delegate messageBaseCellDidCallLongTapDelete:self];
    }
}
@end
