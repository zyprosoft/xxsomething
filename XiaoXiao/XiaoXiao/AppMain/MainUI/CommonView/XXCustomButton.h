//
//  XXCustomButton.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXCustomButton : UIButton
{
}
@property (nonatomic,strong)UIImageView *iconImageView;
@property (nonatomic,strong)NSString *selectIconName;
@property (nonatomic,strong)NSString *normalIconName;

- (void)setNormalIconImage:(NSString*)nImage withSelectedImage:(NSString*)sImage withFrame:(CGRect)iconFrame;

- (void)setTitle:(NSString*)title withFrame:(CGRect)titleFrame;

@end
