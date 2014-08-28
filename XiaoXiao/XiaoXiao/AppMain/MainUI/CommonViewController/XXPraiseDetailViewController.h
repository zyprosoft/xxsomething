//
//  XXPraiseDetailViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 14-2-25.
//  Copyright (c) 2014年 ZYProSoft. All rights reserved.
//

#import "XXBaseViewController.h"

@interface XXPraiseDetailViewController : XXBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSInteger   _currentPageIndex;
    NSInteger   _pageSize;
    BOOL        _hiddenLoadMore;

    NSString *_postId;
    NSString *_postType;
    NSString *_praiseCount;
}
@property (nonatomic,strong)NSMutableArray *praiseArray;

- (id)initWithSharePostModel:(XXSharePostModel*)sharePost;

@end
