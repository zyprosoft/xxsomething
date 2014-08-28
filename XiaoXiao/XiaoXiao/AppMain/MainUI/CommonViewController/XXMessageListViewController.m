//
//  XXMessageListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXMessageListViewController.h"

@interface XXMessageListViewController ()

@end

@implementation XXMessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _messagesArray = [[NSMutableArray alloc]init];
    _currentPageIndex = 0;
    _pageSize = 15;
    _hiddenLoadMore = NO;
    
    CGFloat totalHeight = XXNavContentHeight -44-49;
    _messageListTable = [[UITableView alloc]init];
    _messageListTable.frame = CGRectMake(0,0,self.view.frame.size.width,totalHeight-44);
    _messageListTable.delegate = self;
    _messageListTable.dataSource = self;
    _messageListTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    _messageListTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_messageListTable];
    
    _refreshControl = [[UIRefreshControl alloc]init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [_messageListTable addSubview:_refreshControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messagesArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXMessageBaseCell *cell = (XXMessageBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXMessageBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    NSObject *modelObj = [_messagesArray objectAtIndex:indexPath.row];
    if ([modelObj isKindOfClass:[ZYXMPPMessage class]]) {
        ZYXMPPMessage *aMsg = (ZYXMPPMessage*)modelObj;
        [cell setXMPPMessage:aMsg];
    }
    if ([modelObj isKindOfClass:[XXCommentModel class]]) {
        XXCommentModel *aComment =  (XXCommentModel*)modelObj;
        [cell setCommentModel:aComment];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - override api
- (void)requestMessageListNow
{
    
}
- (void)refresh
{
    
}
- (void)loadMoreResult
{
    
}
#pragma mark - message cell delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deletePathAction];
    }
}
- (void)deletePathAction
{
    
}
- (void)messageBaseCellDidCallLongTapDelete:(XXMessageBaseCell *)cell
{
    
}

@end
