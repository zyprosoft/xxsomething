//
//  XXBaseTagLabelCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseTagLabelCell.h"

@implementation XXBaseTagLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.frame = CGRectMake(25,7,40,30);
        _tagLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_tagLabel];
        _tagLabel.textAlignment = NSTextAlignmentRight;
        _tagLabel.textColor = [UIColor blackColor];
        
        _inputTextField = [[UITextField alloc]init];
        _inputTextField.frame = CGRectMake(75,5,150,34);
        _inputTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_inputTextField];
        _inputTextField.enabled = NO;
        _inputTextField.placeholder = @"请输入";
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
- (void)setTagName:(NSString *)tagName
{
    _tagLabel.text = [NSString stringWithFormat:@"%@:",tagName];
}
- (void)setContentText:(NSString *)contentText
{
    _inputTextField.text = contentText;
}

@end
