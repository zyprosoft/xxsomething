//
//  XXTeaseBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXTeaseBaseCell.h"

@implementation XXTeaseBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGFloat totalHeight = 225;
        _leftMargin = 10.f;
        _innerMargin = 4.f;
        _rightMargin = 10.f;
        _topMargin = 5.f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,0,self.contentView.frame.size.width-20,47)];
        [self.contentView addSubview:_backgroundImageView];
        
        _cellLineImageView = [[UIImageView alloc]init];
        _cellLineImageView.backgroundColor = rgb(233,233,233,1);
        _cellLineImageView.frame = CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1);
        [self.contentView addSubview:_cellLineImageView];
        
        _cellLineImageView.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        _backgroundImageView.image = [[UIImage imageNamed:@"share_post_back_normal.png"]makeStretchForSharePostList];
        _backgroundImageView.highlightedImage = [[UIImage imageNamed:@"share_post_back_selected.png"]makeStretchForSharePostList];
        _backgroundImageView.userInteractionEnabled = YES;
        _backgroundImageView.frame = CGRectMake(_leftMargin,0,_backgroundImageView.frame.size.width,totalHeight);
        
        _teaseImageView = [[UIImageView alloc]init];
        _teaseImageView.frame = CGRectMake(106.5,12.5,107,107);
        _teaseImageView.layer.borderWidth = 1.f;
        _teaseImageView.layer.borderColor = [XXCommonStyle xxThemeButtonBoardColor].CGColor;
        [_backgroundImageView addSubview:_teaseImageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(_backgroundImageView.frame.size.width-10-27,10,27,27);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"delete_share.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(tapOnDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_deleteButton];
        
        
        CGFloat originY = _teaseImageView.frame.origin.y+_teaseImageView.frame.size.height+6.5;

        _timeLabel = [[UILabel alloc]init];
        _timeLabel.frame = CGRectMake(60,originY,80,20);
        _timeLabel.font = [UIFont systemFontOfSize:9];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [_backgroundImageView addSubview:_timeLabel];
        
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = CGRectMake(_timeLabel.frame.origin.x+_timeLabel.frame.size.width+5,originY+5,14.5,12.5);
        _iconImageView.image = [UIImage imageNamed:@"tease_icon.png"];
        [_backgroundImageView addSubview:_iconImageView];
        
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.frame = CGRectMake(_iconImageView.frame.origin.x+_iconImageView.frame.size.width+5,originY,50,20);
        _tagLabel.text = @"挑逗了你";
        _tagLabel.font = [UIFont systemFontOfSize:10];
        _tagLabel.textColor = [UIColor blackColor];
        _tagLabel.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_tagLabel];
        
        //seprator line
        UIImageView *bottomSepLine = [[UIImageView alloc]init];
        bottomSepLine.frame = CGRectMake(_leftMargin,_teaseImageView.frame.origin.y+_teaseImageView.frame.size.height+34,_backgroundImageView.frame.size.width-2*_leftMargin,1);
        bottomSepLine.backgroundColor = [XXCommonStyle xxThemeGrayTitleColor];
        [_backgroundImageView addSubview:bottomSepLine];
        
        //headView
        originY = bottomSepLine.frame.origin.y+bottomSepLine.frame.size.height+12.5;
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(_leftMargin,originY,40,40)];
        _headView.roundImageView.layer.cornerRadius = 4.0f;
        [_headView addTarget:self action:@selector(tapOnHeadView) forControlEvents:UIControlEventTouchUpInside];
        [_backgroundImageView addSubview:_headView];
        
        _userView = [[XXSharePostUserView alloc]initWithFrame:CGRectMake(_headView.frame.origin.x+_headView.frame.size.width+_leftMargin,originY,_backgroundImageView.frame.size.width-55-3*_leftMargin,55)];
        _userView.backgroundColor = [UIColor clearColor];
        [_backgroundImageView addSubview:_userView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [_backgroundImageView setHighlighted:highlighted];
}
- (void)setContentModel:(XXTeaseModel *)aTease
{
    NSString *gifRealName = [NSString stringWithFormat:@"%@.gif",aTease.postEmoji];
    _teaseImageView.image = [UIImage animatedImageWithAnimatedGIFData:[XXFileUitil loadDataFromBundleForName:gifRealName]];
    [_headView setRoundHeadWithUserId:aTease.userId];
    [_userView setTeaseModel:aTease];
    _timeLabel.text = aTease.friendTeaseTime;
}
- (void)tapOnDeleteBtn
{
    if([self.delegate respondsToSelector:@selector(teaseCellDidTapOnDelegate:)]){
        [self.delegate teaseCellDidTapOnDelegate:self];
    }
}
- (void)tapOnHeadView
{
    if ([self.delegate respondsToSelector:@selector(teaseCellDidTapOnHeadView:)]) {
        [self.delegate teaseCellDidTapOnHeadView:self];
    }
}

@end
