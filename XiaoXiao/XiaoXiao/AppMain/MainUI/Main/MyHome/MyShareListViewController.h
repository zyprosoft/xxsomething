//
//  MyShareListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXShareListViewController.h"
#import "SharePostGuideViewController.h"

@interface MyShareListViewController : XXShareListViewController<UIAlertViewDelegate,SharePostGuideViewControllerDelegate>
{
    NSIndexPath *_tapPath;
}
@end
