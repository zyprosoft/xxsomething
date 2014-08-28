//
//  OtherHomeMutilTextCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-16.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherHomeMutilTextCell : XXBaseCell
{
    UILabel *_tagLabel;
    UILabel *_contentLabel;
    UILabel *_countLabel;
}
@property (nonatomic,strong)UILabel *tagLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UILabel *countLabel;

- (void)setContentDict:(NSDictionary*)contentDict;
+ (CGFloat)heightForContentDict:(NSDictionary*)contentDict forWidth:(CGFloat)width;

@end
