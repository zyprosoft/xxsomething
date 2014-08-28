//
//  XXBaseIconLabelCell.m
//  NavigationTest
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBaseIconLabelCell.h"

@implementation XXBaseIconLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _leftMargin = 10.f;
        _innerMargin = 4.f;
        _rightMargin = 10.f;
        _topMargin = 5.f;
        
        //
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.frame = CGRectMake(2*_leftMargin,_topMargin*2+3,19,17);
        [self.contentView addSubview:_iconImageView];
        
        //
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont systemFontOfSize:13];
        _tagLabel.frame= CGRectMake(2*_leftMargin+19+_innerMargin+_innerMargin,_topMargin,80,35);
        [self.contentView addSubview:_tagLabel];
        
        //remind icon
        _remindIconImgView = [[UIImageView alloc]init];
        _remindIconImgView.frame = CGRectMake(110,20, 9.5,9.5);
        _remindIconImgView.image = [UIImage imageNamed:@"msg_remind.png"];
        [self.contentView addSubview:_remindIconImgView];
        _remindIconImgView.hidden = YES;
        
        //
        _detailTagLabel = [[UILabel alloc]init];
        _detailTagLabel.textAlignment = NSTextAlignmentRight;
        _detailTagLabel.font = [UIFont systemFontOfSize:13];
        _detailTagLabel.textColor = [XXCommonStyle xxThemeButtonGrayTitleColor];
        _detailTagLabel.frame = CGRectMake(self.customAccessoryView.frame.origin.x-_innerMargin-150,_topMargin,150,35);
        _detailTagLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_detailTagLabel];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setContentDict:(NSDictionary *)contentDict
{
    _iconImageView.image = [UIImage imageNamed:[contentDict objectForKey:@"icon"]];
    _tagLabel.text = [contentDict objectForKey:@"title"];
    _detailTagLabel.text = [contentDict objectForKey:@"count"];
    _remindIconImgView.hidden = ![[contentDict objectForKey:@"remind"]boolValue];
}

- (void)setCellType:(XXBaseCellType)cellType withBottomMargin:(CGFloat)aMargin withCellHeight:(CGFloat)cellHeight
{
    _cellLineImageView.hidden = YES;
    
    self.customAccessoryView.frame = CGRectMake(self.frame.size.width-15-17,(cellHeight-aMargin-14)/2,7,12);
    [self bringSubviewToFront:self.customAccessoryView];
//    _iconImageView.frame = CGRectMake(2*_leftMargin,(cellHeight-17-aMargin)/2,19,17);
    
    CGRect oldFrame = _backgroundImageView.frame;
    UIImage *background = nil;
    UIImage *selecteBackground = nil;
    switch (cellType) {
        case XXBaseCellTypeTop:
        {
            background = [[UIImage imageNamed:@"cell_top_normal.png"]makeStretchForCellTop];
            selecteBackground = [[UIImage imageNamed:@"cell_top_selected.png"]makeStretchForCellTop];
            
            oldFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
        }
            break;
        case XXBaseCellTypeMiddel:
        {
            background = [[UIImage imageNamed:@"cell_middle_normal.png"]makeStretchForCellMiddle];
            selecteBackground = [[UIImage imageNamed:@"cell_middle_selected.png"]makeStretchForCellMiddle];
            
            oldFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
            
        }
            break;
        case XXBaseCellTypeBottom:
        {
            background = [[UIImage imageNamed:@"cell_bottom_normal.png"]makeStretchForCellBottom];
            selecteBackground = [[UIImage imageNamed:@"cell_bottom_selected.png"]makeStretchForCellBottom];
            
            oldFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
            
        }
            break;
        case XXBaseCellTypeRoundSingle:
        {
            background = [[UIImage imageNamed:@"single_round_cell_normal.png"]makeStretchForSingleRoundCell];
            selecteBackground = [[UIImage imageNamed:@"single_round_cell_selected.png"]makeStretchForSingleRoundCell];
        }
            break;
        case XXBaseCellTypeCornerSingle:
        {
            background = [[UIImage imageNamed:@"single_corner_cell_normal.png"]makeStretchForSingleCornerCell];
            selecteBackground = [[UIImage imageNamed:@"single_corner_cell_selected.png"]makeStretchForSingleCornerCell];
        }
            break;
        default:
            break;
    }
    _backgroundImageView.highlightedImage = selecteBackground;
    _backgroundImageView.frame = oldFrame;
    _backgroundImageView.image = background;
    
}


@end
