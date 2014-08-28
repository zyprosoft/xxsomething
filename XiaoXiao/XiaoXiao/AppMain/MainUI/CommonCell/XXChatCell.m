//
//  XXChatCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXChatCell.h"
#import "XXImageCenter.h"

@implementation XXChatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        CGRect initRect = CGRectMake(0,0,1,1);
        _cellLineImageView.hidden = YES;
        
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(0,0,41,41)];
        _headView.roundImageView.layer.cornerRadius = 4.f;
        [self.contentView addSubview:_headView];
        
        _bubbleBackView = [[UIImageView alloc]init];
        _bubbleBackView.frame = initRect;
        _bubbleBackView.userInteractionEnabled = YES;
        _bubbleBackView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_bubbleBackView];
        
        _contentTextView = [[XXBaseTextView alloc]initWithFrame:initRect];
        _contentTextView.backgroundColor = [UIColor clearColor];
        [_bubbleBackView addSubview:_contentTextView];
        
        //record button
        CGFloat totalWidth = self.frame.size.width*4/5;
        CGFloat maxContentWidth = totalWidth-2*_leftMargin-41-2*_leftMargin-_leftMargin;
        _recordButton = [[XXRecordButton alloc]initWithFrame:CGRectMake(0,0,maxContentWidth*4/5,26)];
        //tapGesture
        UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnRecordButton)];
        [_recordButton addGestureRecognizer:tapR];
        [_bubbleBackView addSubview:_recordButton];
        
        //
        _activeView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activeView.frame = initRect;
        [self.contentView addSubview:_activeView];
        
        //
        _contentImageView = [[XXImageView alloc]initWithFrame:initRect];
        UITapGestureRecognizer *tapImageR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImageView:)];
        [_contentImageView addGestureRecognizer:tapImageR];
        [_bubbleBackView addSubview:_contentImageView];
        
        //
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake((self.frame.size.width-150)/2,2*_topMargin+5, 150, 10);
        _timeLabel.font = [UIFont systemFontOfSize:11];
        _timeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setXMPPMessage:(ZYXMPPMessage *)aMessage
{
    _leftMargin = 10.f;
    _topMargin = 10.f;
    CGFloat headWidth = 41.f;
    
    CGFloat originX = 0.f;
    CGFloat originY = _topMargin+2*_topMargin;
    
    CGFloat totalWidth = self.frame.size.width*4/5;
    CGFloat maxContentWidth = totalWidth-2*_leftMargin-headWidth-2*_leftMargin-_leftMargin;
//    DDLogVerbose(@"maxContentWidth in set:%f",maxContentWidth);
    
    //contentHeight
    CGFloat contentHeight = 0.f;
    CGFloat contentWidth = 0.f;
    CGFloat contentMaxHeight = 46-2*_topMargin;
    
    DDLogVerbose(@"xmppMessage type:%d",[aMessage.messageType intValue]);
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            CGSize contentSize = [XXBaseTextView sizeForAttributedText:aMessage.messageAttributedContent forWidth:maxContentWidth];
//            DDLogVerbose(@"chat in set contentSize:%@",NSStringFromCGSize(contentSize));
            contentHeight = contentSize.height>contentMaxHeight? contentSize.height:46-20;
            contentWidth = contentSize.width;
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            contentWidth = maxContentWidth*4/5;
            contentHeight = contentWidth*3/4;
        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            contentWidth = maxContentWidth*4/5;
            contentHeight = 26;
        }
            break;
        default:
            break;
    }
    
    if (aMessage.isFromSelf) {
        
        originX = self.frame.size.width-_leftMargin-headWidth;
        _headView.frame = CGRectMake(originX,originY+2.5,headWidth,headWidth);
        originX = self.frame.size.width-_leftMargin-_leftMargin-contentWidth-headWidth-20;

    }else{
        originX = _leftMargin;
        _headView.frame = CGRectMake(originX,originY+2.5,headWidth,headWidth);
        originX = originX+headWidth+2;
    }

    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            if (aMessage.isFromSelf) {
                _contentTextView.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
                
            }else{
                _contentTextView.frame = CGRectMake(_leftMargin*2,_topMargin,contentWidth,contentHeight);
            }
            [_contentTextView setAttributedString:aMessage.messageAttributedContent];
            _recordButton.hidden = YES;
            _contentTextView.hidden = NO;
            _contentImageView.hidden = YES;
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            if (aMessage.isFromSelf) {
                _contentImageView.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
                [_contentImageView setContentImageViewFrame:_contentImageView.frame];
                [_contentImageView setImageUrl:aMessage.content];
            }else{
                _contentImageView.frame = CGRectMake(_leftMargin*2,_topMargin,contentWidth,contentHeight);
                [_contentImageView setContentImageViewFrame:_contentImageView.frame];
                [_contentImageView setImageUrl:aMessage.content];

            }
            _contentImageView.hidden = NO;
            _recordButton.hidden = YES;
            _contentTextView.hidden = YES;
        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            _recordButton.frame = CGRectMake(_leftMargin,_topMargin,contentWidth,contentHeight);
            _recordButton.hidden = NO;
            _contentTextView.hidden = YES;
            _contentImageView.hidden = YES;
            DDLogVerbose(@"audioTime:%@",aMessage.audioTime);
            _recordButton.recordTimeLabel.text = aMessage.audioTime;
        }
            break;
        default:
            break;
    }

    _bubbleBackView.frame = CGRectMake(originX,originY,contentWidth+3*_leftMargin,contentHeight+2*_topMargin);
    if (aMessage.isFromSelf) {
        _activeView.frame = CGRectMake(_bubbleBackView.frame.origin.x-20-5,25+13,20,20);
        _bubbleBackView.image = [[UIImage imageNamed:@"chat_right.png"]makeStretchForBubbleRight];
    }else{
        _activeView.frame = CGRectMake(_bubbleBackView.frame.origin.x+_bubbleBackView.frame.size.width+5,25+13,20,20);
        _bubbleBackView.image = [[UIImage imageNamed:@"chat_left.png"]makeStretchForBubbleLeft];
    }
    
    if(![aMessage.sendStatus boolValue]){
        [self setSendingState:YES];
    }else{
        [self setSendingState:NO];
    }
    _timeLabel.text = aMessage.addTime;
    [_headView setRoundHeadWithUserId:aMessage.userId];
    
}
+ (CGFloat)heightWithXMPPMessage:(ZYXMPPMessage *)aMessage forWidth:(CGFloat)width
{
    CGFloat totalHeight = 0.f;
    CGFloat leftMargin = 10.f;
    CGFloat topMargin = 10.f;
    CGFloat headWidth = 41.f;
    
    CGFloat totalWidth = width*4/5;
    CGFloat maxContentWidth = totalWidth-2*leftMargin-headWidth-2*leftMargin-leftMargin;
    CGFloat contentMaxHeight = 46-2*topMargin;
//    DDLogVerbose(@"maxContentWidth in height:%f",maxContentWidth);

    //contentHeight
    CGFloat contentHeight = 0.f;
    CGFloat contentWidth = 0.f;
    
    switch ([aMessage.messageType intValue]) {
        case ZYXMPPMessageTypeText:
        {
            CGSize contentSize = [XXBaseTextView sizeForAttributedText:aMessage.messageAttributedContent forWidth:maxContentWidth];
            
//            DDLogVerbose(@"chat in user height contentSize:%@",NSStringFromCGSize(contentSize));

            contentHeight = contentSize.height>contentMaxHeight? contentSize.height:46-20;
            contentWidth = contentSize.width;
            
            totalHeight = 2*topMargin+contentHeight;
        }
            break;
        case ZYXMPPMessageTypeImage:
        {
            contentWidth = maxContentWidth*4/5;
            contentHeight = contentWidth*3/4;
            
            totalHeight = 2*topMargin+contentHeight;

        }
            break;
        case ZYXMPPMessageTypeAudio:
        {
            contentWidth = maxContentWidth/2;
            contentHeight = 26;
            
            totalHeight = 2*topMargin+contentHeight;

        }
            break;
        default:
            break;
    }
    
//    DDLogVerbose(@"totalHeight :%f",totalHeight);
    totalHeight = totalHeight+topMargin+2*topMargin;

    return totalHeight;
}
- (void)setSendingState:(BOOL)state
{
    if (state) {
        [_activeView startAnimating];
    }else{
        [_activeView stopAnimating];
    }
}

- (void)tapOnImageView:(UITapGestureRecognizer*)tapR
{
    XXImageView *tapView = (XXImageView*)tapR.view;
    if ([self.delegate respondsToSelector:@selector(chatCellDidTapOnImageView:withContentImageView:)]) {
        [self.delegate chatCellDidTapOnImageView:self withContentImageView:tapView];
    }
}

#pragma mark - tap on record button
- (void)tapOnRecordButton
{
    if ([self.delegate respondsToSelector:@selector(chatCellDidTapOnRecord:)]) {
        [self.delegate chatCellDidTapOnRecord:self];
    }
}
- (void)startAudioPlay
{
    [_recordButton startPlay];
}
- (void)endAudioPlay
{
    [_recordButton endPlay];
}
- (void)startLoadingAudio
{
    [_recordButton startLoading];
}
- (void)endLoadingAudio
{
    [_recordButton endLoading];
}

@end
