//
//  XXLoadMoreCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-17.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXLoadMoreCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    UIActivityIndicatorView *_indicatorView;
    UILabel     *_titleLabel;
}
- (void)setTitle:(NSString*)title;
@end
