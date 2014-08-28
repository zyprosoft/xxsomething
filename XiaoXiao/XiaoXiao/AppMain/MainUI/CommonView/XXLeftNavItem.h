//
//  XXLeftNavItem.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-10.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXLeftNavItem : UIView
{
    UILabel *titleLabel;
    UIImageView *iconImageView;
}
- (void)setTitle:(NSString*)title;
- (void)setIconName:(NSString*)iconName;
@end
