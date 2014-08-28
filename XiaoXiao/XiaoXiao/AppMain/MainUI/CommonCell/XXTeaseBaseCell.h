//
//  XXTeaseBaseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-25.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXHeadView.h"
#import "XXSharePostUserView.h"
#import "XXTeaseModel.h"

#define XXTeasePostJSONEmojiKey @"xxtease_post_emoji"
#define XXTeasePostJSONTextKey  @"xxtease_post_text"
#define XXTeasePostJSONAudioKey @"xxtease_post_audio"
#define XXTeasePostJSONImageKey @"xxtease_post_image"
#define XXTeasePostJSONAudioTimeKey @"xxtease_post_audio_time"

/*
 *挑逗内容规则
 *目前加入emoji表情，在本地做转化，采用中文表示，如 [小样]
 *占用EmojiKey,未来需要出现下面几种类型再使用,目前只需要占用EmojiKey来表达挑逗
 *
 *使用格式
 *
 content:{xxtease_post_emoji:"[小样]"}
 */

@class XXTeaseBaseCell;

@protocol XXTeaseBaseCellDelegate <NSObject>
- (void)teaseCellDidTapOnDelegate:(XXTeaseBaseCell*)teaseCell;
- (void)teaseCellDidTapOnHeadView:(XXTeaseBaseCell*)teaseCell;
@end

@interface XXTeaseBaseCell : UITableViewCell
{
    UIImageView *_backgroundImageView;
    UIImageView *_cellLineImageView;
    //
    CGFloat _leftMargin;
    CGFloat _rightMargin;
    CGFloat _innerMargin;
    CGFloat _topMargin;
    
    XXHeadView  *_headView;
    XXSharePostUserView *_userView;
    UIImageView *_teaseImageView;
    UILabel     *_timeLabel;
    UIImageView *_iconImageView;
    UILabel *_tagLabel;
    UIButton    *_deleteButton;
}
@property (nonatomic,weak)id<XXTeaseBaseCellDelegate> delegate;

- (void)setContentModel:(XXTeaseModel*)aTease;

@end
