//
//  XXLoadMoreView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXLoadMoreView : UIView
{
    UIActivityIndicatorView *_indicatorView;
    UILabel                 *_titleLabel;
}
@property (nonatomic,strong)UIImageView  *backgroundImageView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIActivityIndicatorView *indicatorView;


- (void)startLoading;
- (void)endLoading;
- (void)setTitle:(NSString*)title;
- (void)setLabelModel;

@end
