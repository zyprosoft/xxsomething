//
//  XXFormView.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXFormView : UIView<UITextFieldDelegate>
{
    
    UIImageView *backgroundAccount;
    UIImageView *backgroundPwd;
}
@property (nonatomic,strong)UITextField *accountTextField;
@property (nonatomic,strong)UITextField *passwordTextField;

@end
