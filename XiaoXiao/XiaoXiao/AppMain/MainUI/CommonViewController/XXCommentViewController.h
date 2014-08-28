//
//  XXCommentViewController.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBaseViewController.h"
#import "XXShareDetailViewController.h"

/*
 *基础评论列表
 */

@interface XXCommentViewController : XXShareDetailViewController
{
    XXCommentModel *_originComment;
    BOOL            _isGetDetailSuccess;
}
- (id)initWithSharePost:(XXSharePostModel *)aSharePost withOriginComment:(XXCommentModel*)aComment;

@end
