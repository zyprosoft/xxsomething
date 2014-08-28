//
//  LonelyShootResultListViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseUserListViewController.h"

@protocol LonelyShootResultListViewControllerDelegate <NSObject>
- (void)shootFinishWithResult:(BOOL)result;
@end

@interface LonelyShootResultListViewController : XXBaseUserListViewController
{
    
}
@property (nonatomic,weak)id<LonelyShootResultListViewControllerDelegate> delegate;


@end
