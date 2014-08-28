//
//  AudioMessageListViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "AudioMessageListViewController.h"

@interface AudioMessageListViewController ()

@end

@implementation AudioMessageListViewController

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
    
    //observe new message
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(observeNewMsgRecieved:) name:XXUserHasRecievedNewMsgNoti object:nil];
    
    [self refresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[XXChatCacheCenter shareCenter]getLatestMessageList].count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier ";
    XXMessageBaseCell *cell = (XXMessageBaseCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[XXMessageBaseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    ZYXMPPMessage *aMsg = [[[XXChatCacheCenter shareCenter]getLatestMessageList] objectAtIndex:indexPath.row];
    [cell setXMPPMessage:aMsg];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZYXMPPMessage *aMsg = [[[XXChatCacheCenter shareCenter]getLatestMessageList] objectAtIndex:indexPath.row];
    XXUserModel *toUser = [[XXUserModel alloc]init];
    toUser.userId = aMsg.userId;
    toUser.nickName = aMsg.user;
    XXChatViewController *chatViewController = [[XXChatViewController alloc]initWithChatUser:toUser];
    chatViewController.title = toUser.nickName;
    [self.superNav pushViewController:chatViewController animated:YES];
    NSInteger unReadCount = [[XXChatCacheCenter shareCenter]getUnReadMessagesCountByConversationId:aMsg.conversationId];
    [[XXChatCacheCenter shareCenter]reduceUnReadMessgeCount:unReadCount];
    [[XXCommonUitil appMainTabController]updateMainTabBarForNewMessage];
    [[XXChatCacheCenter shareCenter]setConvesationNewMsgHasRead:aMsg.conversationId];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}

- (void)requestMessageListNow
{
    [_refreshControl endRefreshing];
    [_messageListTable reloadData];
}
- (void)refresh
{
    [_refreshControl beginRefreshing];
    [self requestMessageListNow];
}
- (void)observeNewMsgRecieved:(NSNotification*)noti
{
    DDLogVerbose(@"success recieve new message!");
    
    [_messageListTable reloadData];

}

#pragma mark - message cell delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self deletePathAction];
    }
    _tapOnCellPath = nil;
}
- (void)deletePathAction
{
    ZYXMPPMessage *aMsg = [[[XXChatCacheCenter shareCenter]getLatestMessageList] objectAtIndex:_tapOnCellPath.row];
    [[XXChatCacheCenter shareCenter]deleteConversationByUserId:aMsg.userId];
    [_messageListTable reloadData];
}
- (void)messageBaseCellDidCallLongTapDelete:(XXMessageBaseCell *)cell
{
    if (_tapOnCellPath != nil) {
        return;
    }
    _tapOnCellPath = [_messageListTable indexPathForCell:cell];
    
    ZYXMPPMessage *aMsg = [[[XXChatCacheCenter shareCenter]getLatestMessageList] objectAtIndex:_tapOnCellPath.row];
    
    NSString *contentMsg = [NSString stringWithFormat:@"是否删除与%@的对话",aMsg.user];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:contentMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

@end
