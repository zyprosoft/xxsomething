//
//  XXUserFilterCell.m
//  XiaoXiao
//
//  Created by wang on 14-2-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXUserFilterCell.h"

@implementation XXUserFilterCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _showItemLbl =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, self.frame.size.height-10)];
        _showItemLbl.backgroundColor = [UIColor clearColor];
        _showItemLbl.textAlignment = NSTextAlignmentCenter;
        _showItemLbl.highlightedTextColor = [UIColor whiteColor];
        [self.contentView addSubview:_showItemLbl];
        
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
    self.customAccessoryView.frame = CGRectMake(self.customAccessoryView.frame.origin.x,self.customAccessoryView.frame.origin.y-aMargin,self.customAccessoryView.frame.size.width,self.customAccessoryView.frame.size.height);
    
    CGRect oldFrame = _backgroundImageView.frame;
    UIImage *background = nil;
    UIImage *selecteBackground = nil;
    switch (cellType) {
        case XXBaseCellTypeTop:
        {
            background = [[UIImage imageNamed:@"cell_top_normal.png"]makeStretchForCellTop];
            selecteBackground = [[UIImage imageNamed:@"cell_filter_top.png"]makeStretchForCellTop];
            
            oldFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
        }
            break;
        case XXBaseCellTypeMiddel:
        {
            background = [[UIImage imageNamed:@"cell_middle_normal.png"]makeStretchForCellMiddle];
            selecteBackground = [[UIImage imageNamed:@"cell_filter_middle.png"]makeStretchForCellMiddle];
            
            oldFrame = CGRectMake(oldFrame.origin.x,oldFrame.origin.y,oldFrame.size.width,cellHeight);
            
        }
            break;
        case XXBaseCellTypeBottom:
        {
            background = [[UIImage imageNamed:@"cell_bottom_normal.png"]makeStretchForCellBottom];
            selecteBackground = [[UIImage imageNamed:@"cell_filter_bottom.png"]makeStretchForCellBottom];
            
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
