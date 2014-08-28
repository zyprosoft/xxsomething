//
//  OtherUserTeaseSelectViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserTeaseSelectViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_teaseImagesArray;
    UITableView *_tableView;
}
@property (nonatomic,strong)NSString *selectUser;

@end
