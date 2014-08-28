//
//  XXBaseIconLabelCell.h
//  NavigationTest
//
//  Created by ZYVincent on 14-1-15.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseCell.h"

@interface XXBaseIconLabelCell : XXBaseCell
{
    UIImageView *_iconImageView;
    UILabel     *_tagLabel;
    UILabel     *_detailTagLabel;
    UIImageView *_indicatorView;
    UIImageView *_remindIconImgView;
}
@property (nonatomic,strong)UILabel *tagLabel;
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)UILabel *detailTagLabel;

- (void)setContentDict:(NSDictionary*)contentDict;

@end
