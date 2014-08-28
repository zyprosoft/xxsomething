//
//  XXPraiseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXPraiseCell.h"

@implementation XXPraiseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _headView = [[XXHeadView alloc]initWithFrame:CGRectMake(2*_leftMargin,_topMargin+5,35,35)];
        _headView.roundImageView.layer.cornerRadius = 4.0f;
        [self.contentView addSubview:_headView];
        
        
        CGFloat originX = _headView.frame.origin.x+_headView.frame.size.width+10;
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(originX,_topMargin,100,25)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-2*_leftMargin-50,_topMargin,50,25)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_timeLabel];
        
        _praiseImageView = [[UIImageView alloc]init];
        _praiseImageView.frame = CGRectMake(_nameLabel.frame.origin.x,40,18,15);
        _praiseImageView.image = [UIImage imageNamed:@"share_post_praise_selected.png"];
        [self.contentView addSubview:_praiseImageView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setPraiseModel:(XXPraiseModel *)contentModel
{
    [_headView setRoundHeadWithUserId:contentModel.userId];
    _nameLabel.text = contentModel.nickname;
    _timeLabel.text = contentModel.friendlyTime;
}

@end
