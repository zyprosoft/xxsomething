//
//  XXBaseTagLabelCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXBaseCell.h"

@interface XXBaseTagLabelCell : XXBaseCell
{
    UILabel *_tagLabel;
    UITextField *_inputTextField;
}
@property (nonatomic,strong)UITextField *inputTextField;

- (void)setTagName:(NSString*)tagName;
- (void)setContentText:(NSString*)contentText;
@end
