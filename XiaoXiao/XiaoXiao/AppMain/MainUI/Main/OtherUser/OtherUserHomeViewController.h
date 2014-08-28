//
//  OtherUserHomeViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *guideTable;
    
    NSMutableArray *guideVCArray;

    XXUserModel *_currentUser;
    __block BOOL         _isCareYou;
    
    XXCustomButton *_leaveMsgButton;
    XXCustomButton *_careButton;
    UIImageView *barBack;
}

- (id)initWithContentUser:(XXUserModel*)aUser;

@end
