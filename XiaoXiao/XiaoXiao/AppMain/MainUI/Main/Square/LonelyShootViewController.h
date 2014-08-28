//
//  LonelyShootViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArrowView.h"
#import "LonelyShootView.h"
#import "XXLoadMoreView.h"
#import "XXBaseViewController.h"
#import "LonelyShootResultListViewController.h"

@interface LonelyShootViewController :UIViewController<ArrowViewDelegate,LonelyShootResultListViewControllerDelegate,UIAlertViewDelegate>
{
    ArrowView       *_arrowView;
    LonelyShootView *_shootView;
    LonelyShootResultListViewController *resultVC;
    
    UIActivityIndicatorView *_indcatorView;
    UILabel                 *_loadingLabel;
    
}
@end
