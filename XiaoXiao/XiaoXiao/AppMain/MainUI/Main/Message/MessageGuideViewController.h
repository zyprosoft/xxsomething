//
//  MessageGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioMessageListViewController.h"
#import "ReplyMessageListViewController.h"
#import "TeaseMeListViewController.h"
#import "XXCustomTabBar.h"
#import "MessageGuideTabBar.h"
#import "XXBadgeView.h"

@interface MessageGuideViewController : UIViewController
{
    NSMutableArray *_viewControllers;
    MessageGuideTabBar *_menuBar;
    
    UIImageView     *_selectTagView;
    
    XXBadgeView     *_commentBadgeView;
    XXBadgeView     *_teaseMeBageView;
    XXBadgeView     *_msgBadgeView;
    
}
@end
