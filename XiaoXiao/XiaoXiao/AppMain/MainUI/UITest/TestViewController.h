//
//  TestViewController.h
//  WordPressMobile
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *testTable;
@property (nonatomic,strong)NSMutableArray *sourceArray;

@end
