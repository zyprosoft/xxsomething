//
//  XXSchoolChooseCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXSchoolChooseCell.h"

@implementation XXSchoolChooseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _chooseImageView = [[UIImageView alloc]init];
        _chooseImageView.frame = CGRectMake(self.frame.size.width-23-15,10.5,23,23);
        _chooseImageView.image = [UIImage imageNamed:@"blue_right_selected.png"];
        [self.contentView addSubview:_chooseImageView];
        _chooseImageView.hidden = YES;
        
        UIView *normalBack = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
        normalBack.backgroundColor = rgb(233,233,234,1);
        self.selectedBackgroundView = normalBack;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
- (void)setContentModel:(XXSchoolModel *)contentModel
{
    self.titleLabel.text = contentModel.schoolName;
}
- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}
- (void)setChooseState:(BOOL)state
{
    _chooseImageView.hidden = !state;
}
@end
