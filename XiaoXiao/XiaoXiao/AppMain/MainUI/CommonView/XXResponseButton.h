//
//  XXResponseButton.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-1-1.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XXResponseButtonDidTapBlock) (void);

@interface XXResponseButton : UIButton
{
    XXResponseButtonDidTapBlock _tapBlock;
}
@property (nonatomic,strong)UIImageView *iconImageView;
- (void)setNormalIconImage:(NSString*)nImage;
- (void)setButtonSelfTapInside;
- (void)setResponseButtonTapped:(XXResponseButtonDidTapBlock)tapBlock;

@end
