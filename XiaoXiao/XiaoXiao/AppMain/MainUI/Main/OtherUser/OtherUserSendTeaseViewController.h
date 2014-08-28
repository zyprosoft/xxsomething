//
//  OtherUserSendTeaseViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"

@interface OtherUserSendTeaseViewController : XXBaseViewController
{
    UIImageView *_teaseImageView;
    XXCustomButton *_teaseButton;
    NSString    *_toUserId;
}
@property (nonatomic,strong)NSString *teaseEmoji;
@property (nonatomic,strong)NSString *toUserId;

- (void)setSelecteTeaseEmoji:(NSString*)teaseName toUser:(NSString*)useId;

@end
