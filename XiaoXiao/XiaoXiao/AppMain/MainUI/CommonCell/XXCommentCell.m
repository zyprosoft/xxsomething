//
//  XXCommentCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXCommentCell.h"

@implementation XXCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftMargin = 10.f;
        _topMargin = 10.f;
        _innerMargin = 10.f;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //back
        _backgroundImageView = [[UIImageView alloc]init];
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,self.frame.size.width-2*_leftMargin,10);
        _backgroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_backgroundImageView];
        
        //headView
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin+17,_topMargin,31,31)];
        _headView.roundImageView.layer.cornerRadius = 6.f;
        [self.contentView addSubview:_headView];
        
        //name label
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.frame = CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_innerMargin/2,_topMargin/2,_backgroundImageView.frame.size.width-4*_leftMargin-_headView.frame.size.width,20);
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.5];
        _nameLabel.textColor = [UIColor blackColor];
        [_backgroundImageView addSubview:_nameLabel];
        
        //sexImageView
        _sexImageView = [[UIImageView alloc]init];
        _sexImageView.frame = CGRectMake(0,0,12,12);
        [_backgroundImageView addSubview:_sexImageView];
        
        //reply who label
        _replyWhoLabel = [[UILabel alloc]init];
        _replyWhoLabel.frame = CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_topMargin*2,180,20);
        _replyWhoLabel.backgroundColor = [UIColor clearColor];
        _replyWhoLabel.font = [UIFont systemFontOfSize:11];
        _replyWhoLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        [_backgroundImageView addSubview:_replyWhoLabel];
        
        //reply this commentBtn
        _replyThisCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyThisCommentBtn.frame = CGRectMake(_backgroundImageView.frame.size.width-15-18,_topMargin,18,15);
        [_replyThisCommentBtn setBackgroundImage:[UIImage imageNamed:@"reply_comment.png"] forState:UIControlStateNormal];
        [_replyThisCommentBtn addTarget:self action:@selector(tapOnReplyThisComment) forControlEvents:UIControlEventTouchUpInside];
        _replyThisCommentBtn.hidden = YES;
        [_backgroundImageView addSubview:_replyThisCommentBtn];
        
//        //user view
//        _userView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_leftMargin,_topMargin,_backgroundImageView.frame.size.width-35-3*_leftMargin,35)];
//        _userView.backgroundColor = [UIColor clearColor];
//        [_backgroundImageView addSubview:_userView];
        
        //content text
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin+_topMargin,_backgroundImageView.frame.size.width-4*_leftMargin-_headView.frame.size.width,30)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_contentTextView];
        
        //audio
        _audioButton = [[XXRecordButton alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x+5,_nameLabel.frame.origin.y+_nameLabel.frame.size.height+_innerMargin+_topMargin,149,44)];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"audio_normal.png"] forState:UIControlStateNormal];
        [_audioButton setBackgroundImage:[UIImage imageNamed:@"audio_selected.png"] forState:UIControlStateSelected];
        [_audioButton addTarget:self action:@selector(tapOnAudioButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_audioButton];
        
        //_time label
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(0,0,80,20);
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        [_backgroundImageView addSubview:_timeLabel];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCommentModel:(XXCommentModel *)contentModel
{
    BOOL isAudioType = [contentModel.postAudioTime isEqualToString:@"0"]? NO:YES;
    
    if (isAudioType) {
        _audioButton.hidden = NO;
        _contentTextView.hidden = YES;
        _audioUrl = contentModel.postAudio;
    }else{
        _audioButton.hidden = YES;
        _contentTextView.hidden = NO;
    }
    
    //不能回复自己的评论
    if (![contentModel.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        _replyThisCommentBtn.hidden = NO;
    }else{
        _replyThisCommentBtn.hidden = YES;
    }
    
    _replyWhoLabel.text = [NSString stringWithFormat:@"回复 %@ :",contentModel.toUserName];
    
    //name label
    _nameLabel.text = contentModel.userName;
    CGSize nameSize = [_nameLabel.text sizeWithFont:[UIFont systemFontOfSize:12.5] constrainedToSize:CGSizeMake(280,_nameLabel.frame.size.height)];
    _nameLabel.frame = CGRectMake(_nameLabel.frame.origin.x,_nameLabel.frame.origin.y,nameSize.width,_nameLabel.frame.size.height);
    _sexImageView.frame = CGRectMake(_nameLabel.frame.origin.x+_nameLabel.frame.size.width+2,_nameLabel.frame.origin.y+5,12,12);
    NSString *sexTag = [contentModel.sex boolValue]? @"sex_tag_1.png":@"sex_tag_0.png";
    _sexImageView.image = [UIImage imageNamed:sexTag];
    _timeLabel.text = contentModel.friendAddTime;
    _audioButton.recordTimeLabel.text = contentModel.postAudioTime;
    
    //head
    [_headView setRoundHeadWithUserId:contentModel.userId];
//    [_userView setCommentModel:contentModel];
    
    //
    if (isAudioType) {
        
        //time label
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-80;
        _timeLabel.frame = CGRectMake(timeOriginX,_audioButton.frame.origin.y+_audioButton.frame.size.height+_topMargin/2,80,20);
        
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+_audioButton.frame.size.height+_topMargin/2+_timeLabel.frame.size.height);
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:_contentTextView.frame.size.width];
        
        //reset
        _contentTextView.frame = CGRectMake(_contentTextView.frame.origin.x,_contentTextView.frame.origin.y,_contentTextView.frame.size.width,contentHeight);
        [_contentTextView setAttributedString:contentModel.contentAttributedString];
        
        //time label
        CGFloat timeOriginX = _backgroundImageView.frame.size.width-_leftMargin-80;
        _timeLabel.frame = CGRectMake(timeOriginX,_contentTextView.frame.origin.y+_contentTextView.frame.size.height+_topMargin/2,80,20);
        
        //_background
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,_topMargin+_headView.frame.size.height+_innerMargin+contentHeight+_topMargin/2+_timeLabel.frame.size.height);
    }
}

+ (CGFloat)heightForCommentModel:(XXCommentModel *)contentModel forWidth:(CGFloat)width
{
    BOOL isAudioType = [contentModel.postAudioTime isEqualToString:@"0"]? NO:YES;
    
    CGFloat leftMargin = 10;
    CGFloat innerMargin =10;
    CGFloat topMargin = 10;
    CGFloat headViewHeight=31;
    CGFloat audioButtonHeight = 44;
    CGFloat backgroundViewWidth = width- 2*leftMargin;
    CGFloat timeFontSize = 13;
    CGFloat timeHeight = 20;
    CGFloat contentWidth = width - 4*leftMargin - headViewHeight;
    
    CGFloat cellHeight = 0.f;
     //
    if (isAudioType) {
        
        cellHeight = topMargin + headViewHeight + innerMargin + audioButtonHeight + topMargin/2  + timeHeight;
        
    }else{
        
        CGFloat contentHeight = [XXBaseTextView heightForAttributedText:contentModel.contentAttributedString forWidth:contentWidth];
        
        //_background
        cellHeight = topMargin + headViewHeight + innerMargin + contentHeight+topMargin/2 + timeHeight;
    }
    
    return cellHeight;

}
- (void)setCellType:(XXBaseCellType)cellType
{
    UIImage *backgroundImage = nil;
    switch (cellType) {
        case XXBaseCellTypeMiddel:
        {
            backgroundImage = [[UIImage imageNamed:@"share_post_detail_middle.png"]makeStretchForSharePostDetailMiddle];
        }
            break;
        case XXBaseCellTypeBottom:
        {
            backgroundImage = [[UIImage imageNamed:@"share_post_detail_bottom.png"]makeStretchForSharePostDetailBottom];
        }
            break;
        case  XXBaseCellTypeTop:
        {
            backgroundImage = [[UIImage imageNamed:@"share_post_detail_top.png"]makeStretchForSharePostDetailBottom];

        }
            break;
        default:
            break;
    }
    _backgroundImageView.image = backgroundImage;
}

- (void)tapOnAudioButtonAction
{
    if ([self.delegate respondsToSelector:@selector(commentCellDidTapOnAudioButton:)]) {
        [self.delegate commentCellDidTapOnAudioButton:self];
    }
}
- (void)tapOnReplyThisComment
{
    if ([self.delegate respondsToSelector:@selector(commentCellDidCallReplyThisComment:)]) {
        [self.delegate commentCellDidCallReplyThisComment:self];
    }
}

- (void)startAudioPlay
{
    [_audioButton startPlay];
}
- (void)startLoadingAudio
{
    [_audioButton startLoading];
}
- (void)endAudioPlay
{
    [_audioButton endPlay];
}
- (void)endLoadingAudio
{
    [_audioButton endLoading];
}

@end
