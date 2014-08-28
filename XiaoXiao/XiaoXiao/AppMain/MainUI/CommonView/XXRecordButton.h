//
//  XXRecordButton.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-19.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTLinkButton.h"

@interface XXRecordButton : DTLinkButton
{
    UIButton *_recordButton;
    UIImageView *_playStateImageView;
    UILabel  *_recordTimeLabel;
    UIActivityIndicatorView *_indicatorView;
    UIImageView     *_backgroundImageView;
}
@property (nonatomic,strong)UILabel *recordTimeLabel;
@property (nonatomic,strong)UIImageView *backgroundImageView;

- (void)startPlay;
- (void)endPlay;
- (void)startLoading;
- (void)endLoading;
@end
