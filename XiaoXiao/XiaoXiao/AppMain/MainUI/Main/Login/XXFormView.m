//
//  XXFormView.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXFormView.h"

@implementation XXFormView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImage *formNormal = [[UIImage imageNamed:@"login_form_normal.png"]t:6 l:6 b:6 r:6];

        self.accountTextField = [[UITextField alloc]init];
        self.accountTextField.frame = CGRectMake(15,0,frame.size.width,45);
        self.accountTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.accountTextField.placeholder = @"请输入邮箱号或者学霸账号";
        self.accountTextField.keyboardType = UIKeyboardTypeASCIICapable;
        self.accountTextField.delegate = self;
        backgroundAccount = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,frame.size.width,45)];
        backgroundAccount.image = formNormal;
        [self addSubview:backgroundAccount];
        [self addSubview:self.accountTextField];
        
        self.passwordTextField = [[UITextField alloc]init];
        self.passwordTextField.frame = CGRectMake(15,60,frame.size.width,45);
        self.passwordTextField.placeholder = @"请输入密码";
        self.passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.passwordTextField.secureTextEntry = YES;
        self.passwordTextField.delegate = self;
        backgroundPwd = [[UIImageView alloc]initWithFrame:CGRectMake(0,60,frame.size.width,45)];
        backgroundPwd.image = formNormal;
        [self addSubview:backgroundPwd];
        [self addSubview:self.passwordTextField];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIImage *formSelected = [[UIImage imageNamed:@"login_form_selected.png"]t:6 l:6 b:6 r:6];
    
    if (textField==self.accountTextField) {
        backgroundAccount.image = formSelected;
    }
    if (textField==self.passwordTextField) {
        backgroundPwd.image = formSelected;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIImage *formNormal = [[UIImage imageNamed:@"login_form_normal.png"]t:6 l:6 b:6 r:6];
    
    if (textField==self.accountTextField) {
        backgroundAccount.image = formNormal;
    }
    if (textField==self.passwordTextField) {
        backgroundPwd.image = formNormal;
    }
}

@end
