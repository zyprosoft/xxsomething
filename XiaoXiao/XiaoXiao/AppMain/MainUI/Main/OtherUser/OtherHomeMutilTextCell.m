//
//  OtherHomeMutilTextCell.m
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "OtherHomeMutilTextCell.h"

@implementation OtherHomeMutilTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _tagLabel = [[UILabel alloc]init];
        _tagLabel.frame = CGRectMake(2*_leftMargin+7,8,180,29);
        _tagLabel.backgroundColor = [UIColor clearColor];
        _tagLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_tagLabel];

        //
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.frame = CGRectMake(2*_leftMargin,40,self.contentView.frame.size.width-2*_leftMargin-2*_leftMargin,100);
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        //
        _countLabel = [[UILabel alloc]init];
        _countLabel.frame = CGRectMake(self.contentView.frame.size.width-60-2*_leftMargin,5,60,30);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_countLabel];
        
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
    BOOL isMutil = [[contentDict objectForKey:@"isMutil"]boolValue];
    NSString *tag = [contentDict objectForKey:@"tag"];
    NSString *content = [contentDict objectForKey:@"content"];
    
    _tagLabel.text = tag;
    if (isMutil) {
        _countLabel.hidden = YES;
        CGFloat contentWidth = _contentLabel.frame.size.width;
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(contentWidth,99999)];
        CGRect oldContentFrame = _contentLabel.frame;
        _contentLabel.frame = CGRectMake(3*_leftMargin,oldContentFrame.origin.y,oldContentFrame.size.width,contentSize.height);
        _contentLabel.text=content;
        CGRect backOldRect = _backgroundImageView.frame;
        _backgroundImageView.frame = CGRectMake(backOldRect.origin.x,backOldRect.origin.y,backOldRect.size.width,contentSize.height+45);
    }else{
        _contentLabel.hidden = YES;
        _countLabel.text = content;
    }

}
+ (CGFloat)heightForContentDict:(NSDictionary *)contentDict forWidth:(CGFloat)width
{
    BOOL isMutil = [[contentDict objectForKey:@"isMutil"]boolValue];
    NSString *content = [contentDict objectForKey:@"content"];
    
    CGFloat totalHeight = 45.5f;
    if (isMutil) {
        CGFloat leftMargin = 10.f;
        CGFloat contentWidth = width-2*leftMargin-2*leftMargin;
        CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(contentWidth,99999)];
        
        totalHeight = 35+5+contentSize.height+5;
    }
    return totalHeight;
}

@end
