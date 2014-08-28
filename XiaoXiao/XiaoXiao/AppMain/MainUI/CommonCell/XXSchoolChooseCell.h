//
//  XXSchoolChooseCell.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSchoolModel.h"

@interface XXSchoolChooseCell : XXBaseCell
{
    UIImageView *_chooseImageView;
}
@property (nonatomic,strong)UIImageView *chooseImageView;

- (void)setContentModel:(XXSchoolModel*)contentModel;
- (void)setTitle:(NSString*)title;
- (void)setChooseState:(BOOL)state;
@end
