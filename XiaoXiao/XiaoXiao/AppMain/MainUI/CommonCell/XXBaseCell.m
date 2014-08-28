//
//  XXBaseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseCell.h"


@implementation XXBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _leftMargin = 10.f;
        _innerMargin = 4.f;
        _rightMargin = 10.f;
        _topMargin = 5.f;
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,0,self.contentView.frame.size.width-20,47)];
        [self.contentView addSubview:_backgroundImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.frame = CGRectMake(25,0,self.frame.size.width-50,self.frame.size.height);
        [self.contentView addSubview:self.titleLabel];
        
        _cellLineImageView = [[UIImageView alloc]init];
        _cellLineImageView.backgroundColor = rgb(233,233,233,1);
        _cellLineImageView.frame = CGRectMake(0,self.frame.size.height-1,self.frame.size.width,1);
        [self.contentView addSubview:_cellLineImageView];
        
        self.customAccessoryView = [[UIImageView alloc]init];
        self.customAccessoryView.frame = CGRectMake(self.frame.size.width-10-10-17,5,7,12);
        self.customAccessoryView.image = [UIImage imageNamed:@"cell_indicator.png"];
        self.customAccessoryView.hidden = YES;
        [self.contentView addSubview:self.customAccessoryView];
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        self.selectedBackgroundView = normalBack;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setCellType:(XXBaseCellType)cellType withBottomMargin:(CGFloat)aMargin withCellHeight:(CGFloat)cellHeight
{
    _cellLineImageView.hidden = YES;
    self.customAccessoryView.frame = CGRectMake(self.frame.size.width-15-17,(cellHeight-aMargin-10)/2,7,12);
    [self bringSubviewToFront:self.customAccessoryView];
    
    CGRect oldFrame = _backgroundImageView.frame;
    CGRect newFrame = CGRectZero;
    UIImage *background = nil;
    UIImage *selecteBackground = nil;
    switch (cellType) {
        case XXBaseCellTypeTop:
        {
            background = [[UIImage imageNamed:@"cell_top_normal.png"]makeStretchForCellTop];
            selecteBackground = [[UIImage imageNamed:@"cell_top_selected.png"]makeStretchForCellTop];
            
            newFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
        }
            break;
        case XXBaseCellTypeMiddel:
        {
            background = [[UIImage imageNamed:@"cell_middle_normal.png"]makeStretchForCellMiddle];
            selecteBackground = [[UIImage imageNamed:@"cell_middle_selected.png"]makeStretchForCellMiddle];
            
            newFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
            
        }
            break;
        case XXBaseCellTypeBottom:
        {
            background = [[UIImage imageNamed:@"cell_bottom_normal.png"]makeStretchForCellBottom];
            selecteBackground = [[UIImage imageNamed:@"cell_bottom_selected.png"]makeStretchForCellBottom];
            
            newFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
            
        }
            break;
        case XXBaseCellTypeRoundSingle:
        {
            background = [[UIImage imageNamed:@"single_round_cell_normal.png"]makeStretchForSingleRoundCell];
            selecteBackground = [[UIImage imageNamed:@"single_round_cell_selected.png"]makeStretchForSingleRoundCell];
            
            newFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);

        }
            break;
        case XXBaseCellTypeCornerSingle:
        {
            background = [[UIImage imageNamed:@"single_corner_cell_normal.png"]makeStretchForSingleCornerCell];
            selecteBackground = [[UIImage imageNamed:@"single_corner_cell_selected.png"]makeStretchForSingleCornerCell];
            
            newFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);

        }
            break;
        default:
            break;
    }
    _backgroundImageView.frame = newFrame;
    _backgroundImageView.highlightedImage = selecteBackground;
    _backgroundImageView.image = background;

}

@end
