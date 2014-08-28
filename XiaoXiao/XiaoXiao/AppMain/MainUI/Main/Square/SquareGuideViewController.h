//
//  SquareGuideViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-18.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareGuideViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_guideTableView;
    NSMutableArray *_guideTitleArray;
}

@end
