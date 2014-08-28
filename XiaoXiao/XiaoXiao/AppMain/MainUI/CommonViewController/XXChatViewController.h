//
//  XXChatViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"
#import "XXChatToolBar.h"
#import "XXUserModel.h"
#import "XXConditionModel.h"
#import "XXChatCell.h"
#import "XXAudioManager.h"

/*
 *基础聊天视图列表
 */

@interface XXChatViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource,XXChatCellDelegate,XXAudioManagerDelegate,XXChatToolBarDelegate>
{
    UITableView *_messageListTable;
    NSMutableArray *_messagesArray;
    NSMutableArray *_rowHeightArray;
    
    XXChatToolBar *_chatToolBar;
    UIControl        *_whiteBoard;
    
    XXUserModel   *_chatUser;
    NSString      *_isFirstChat;
    XXConditionModel *_conversationCondition;
    
    NSIndexPath   *_playingAudioPath;
}

- (id)initWithChatUser:(XXUserModel*)chatUser;

@end
