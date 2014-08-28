//
//  XXBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKRoundedView.h"

typedef enum {
    
    XXBaseCellTypeTop = 0,
    XXBaseCellTypeMiddel,
    XXBaseCellTypeBottom,
    XXBaseCellTypeRoundSingle,
    XXBaseCellTypeCornerSingle,
    
}XXBaseCellType;


@interface XXBaseCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    UIImageView *_cellLineImageView;
    
    //
    CGFloat _leftMargin;
    CGFloat _rightMargin;
    CGFloat _innerMargin;
    CGFloat _topMargin;
}
@property (nonatomic,strong)UIImage *backImage;
@property (strong,nonatomic)UILabel *titleLabel;
@property (nonatomic,assign)BOOL     needCustomLine;
@property (strong,nonatomic)UIImageView *customAccessoryView;

- (void)setCellType:(XXBaseCellType)cellType withBottomMargin:(CGFloat)aMargin withCellHeight:(CGFloat)cellHeight;

@end
