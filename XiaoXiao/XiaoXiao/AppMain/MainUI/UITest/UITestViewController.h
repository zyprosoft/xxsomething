//
//  UITestViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITestViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    BOOL backgroundRecieveMsg;
    XXBaseTextView *messageShowTextView;
    UITextView *searchResultTextView;
    UITextField *inputTextField;
    UITextField *roomTextField;
    UITableView *searchTable;
    NSInteger keywordCurrentPage;
    NSInteger keywordPageSize;
    BOOL needLoadMore;
    NSString *uploadFlag;
    XXImageView *testDownload;
    XXImageView *testUpload;
}
@property (nonatomic,strong)UITableView *testTable;
@property (nonatomic,strong)NSMutableArray *sourceArray;

@end
