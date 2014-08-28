//
//  GuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "GuideViewController.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "XXSchoolSearchViewController.h"
#import "SettingMyProfileGuideViewController.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    
    CGFloat totalHeight = XXNavContentHeight;
    
    UIImageView *logoImgView = [[UIImageView alloc]init];
    if (IS_PHONE_5) {
        logoImgView.frame = CGRectMake(99,80,122,123);
    }else{
        logoImgView.frame = CGRectMake(99,60,122,123);
    }
    logoImgView.image = [UIImage imageNamed:@"login_logo.png"];
    [self.view addSubview:logoImgView];
    
//    UIImageView *logoNameImageView = [[UIImageView alloc]init];
//    logoNameImageView.frame = CGRectMake(121,210,79,35);
//    logoNameImageView.image = [UIImage imageNamed:@"login_logo_name.png"];
//    [self.view addSubview:logoNameImageView];
    
    UIImageView *loginIntroduceImageView = [[UIImageView alloc]init];
    loginIntroduceImageView.backgroundColor = [UIColor clearColor];
    if (IS_PHONE_5) {
        loginIntroduceImageView.frame = CGRectMake(79,280,162,108);
    }else{
        loginIntroduceImageView.frame = CGRectMake(79,243,162,108);
    }
    loginIntroduceImageView.image = [UIImage imageNamed:@"login_guide.png"];
    [self.view addSubview:loginIntroduceImageView];
    
    
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"login_button.png"]t:6 l:6 b:6 r:6];
    UIImage *buttonSelected = [[UIImage imageNamed:@"login_button_selected"]t:6 l:6 b:6 r:6];
    
    //
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(6,totalHeight-40-20,148,40);
    [loginBtn setTitle:@"学霸登陆" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:buttonNormal forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:buttonSelected forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(164,totalHeight-40-20,148,40);
    [registBtn setTitle:@"学霸注册" forState:UIControlStateNormal];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registBtn setBackgroundImage:buttonNormal forState:UIControlStateNormal];
    [registBtn setBackgroundImage:buttonSelected forState:UIControlStateHighlighted];
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    
//    //qq login
//    XXCustomButton *qqloginBtn = [XXCustomButton buttonWithType:UIButtonTypeCustom];
//    qqloginBtn.frame = CGRectMake(6,totalHeight-40-10,148,40);
//    [qqloginBtn setBackgroundImage:[UIImage imageNamed:@"input_box.png"] forState:UIControlStateNormal];
//    [qqloginBtn setNormalIconImage:@"login_QQ.png" withSelectedImage:@"login_QQ.png" withFrame:CGRectMake(30,10,20,20)];
//    [qqloginBtn setTitle:@"QQ登陆" withFrame:CGRectMake(65,5,80,30)];
//    [qqloginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    qqloginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [qqloginBtn addTarget:self action:@selector(qqLoginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:qqloginBtn];
//    
//    //weibo login
//    XXCustomButton *weibologinBtn = [XXCustomButton buttonWithType:UIButtonTypeCustom];
//    weibologinBtn.frame = CGRectMake(164,totalHeight-40-10,148,40);
//    [weibologinBtn setBackgroundImage:[UIImage imageNamed:@"input_box.png"] forState:UIControlStateNormal];
//    [weibologinBtn setNormalIconImage:@"login_WeiBo.png" withSelectedImage:@"login_WeiBo.png" withFrame:CGRectMake(30,10,20,20)];
//    [weibologinBtn setTitle:@"微博登陆" withFrame:CGRectMake(65,5,80,30)];
//    [weibologinBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    weibologinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [weibologinBtn addTarget:self action:@selector(weiboLoginAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:weibologinBtn];
}

- (void)setLoginGuideFinish:(LoginGuideFinishLoginBlock)finishBlock
{
    _finishBlock = finishBlock;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (self.view.window==nil) {
        if (_finishBlock) {
            _finishBlock = nil;
        }
    }
}

#pragma mark - action
- (void)loginAction
{
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    loginVC.title = @"登陆学霸";
    [loginVC setLoginResultBlock:^(BOOL resultState) {
        if (resultState) {
            if (_finishBlock) {
                _finishBlock(resultState);
            }
        }
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}
- (void)registAction
{
    XXUserModel *newUser = [[XXUserModel alloc]init];
    
    //school choose
    XXSchoolSearchViewController *chooseSchoolVC = [[XXSchoolSearchViewController alloc]init];
    chooseSchoolVC.title = @"选择学校";
    [self.navigationController pushViewController:chooseSchoolVC animated:YES];
    [chooseSchoolVC setNextStepAction:^(NSDictionary *resultDict) {
        
    } withNextStepTitle:@"下一步"];
    
    //can registAction
    XXDataCenterUploadFileSuccessBlock successUpload = ^ (XXAttachmentModel *resultModel){
        
        RegistViewController *registVC = [[RegistViewController alloc]init];
        registVC.title = @"注册学霸";
        [self.navigationController pushViewController:registVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:registVC withBackStepAction:^{
            [self.navigationController popToViewController:chooseSchoolVC animated:YES];
        }];
        [XXCommonUitil setCommonNavigationNextStepItemForViewController:registVC withNextStepAction:^{
            newUser.account = registVC.formView.accountTextField.text;
            newUser.password = registVC.formView.passwordTextField.text;
            [[XXMainDataCenter shareCenter]requestRegistWithNewUser:newUser withSuccessRegist:^(XXUserModel *detailUser) {
                
                [SVProgressHUD showSuccessWithStatus:@"注册成功"];
                
                //立即转向登陆
                [[XXMainDataCenter shareCenter]requestLoginWithNewUser:newUser withSuccessLogin:^(XXUserModel *detailUser) {
                    [XXUserDataCenter loginThisUser:detailUser];
                    [[XXCommonUitil appDelegate]loginNow];
                } withFaildLogin:^(NSString *faildMsg) {
                    [SVProgressHUD showErrorWithStatus:@"自动登陆失败!"];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
                
            } withFaildRegist:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:faildMsg];
            }];
        } withTitle:@"完成"];
    };
    
    //upload head image
    void (^UploadChooseImageBlock) (UIImage *aImage) = ^ (UIImage *aImage){
        NSData *imageData = UIImageJPEGRepresentation(aImage,1.0);
        [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"head.png" withUploadProgressBlock:^(CGFloat progressValue) {
            [SVProgressHUD showProgress:progressValue status:@"正在上传头像..."];
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            newUser.headUrl = resultModel.link;
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            //push regist
            successUpload(resultModel);
            
        } withFaildBlock:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:@"头像上传失败"];
        }];
    };
    
    //finish chooseImage
    XXCommonNavigationNextStepBlock finishChooseImage = ^ (NSDictionary *resultDict){
        UIImage *resultImage = [resultDict objectForKey:@"result"];
        UploadChooseImageBlock(resultImage);
    };
    
    //photo choose
    XXPhotoChooseViewController *chooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:1 withFinishBlock:^(NSArray *resultImages) {
    }];
    chooseVC.title = @"选择头像";
    chooseVC.needCrop = YES;
    chooseVC.needFilter = YES;
    chooseVC.singleImageCropHeight = 320;
    chooseVC.isSetHeadImage = YES;
    [chooseVC setNextStepAction:^(NSDictionary *resultDict) {
        finishChooseImage(resultDict);
    }];
    
    [chooseSchoolVC setNextStepAction:^(NSDictionary *resultDict) {
        [self.navigationController pushViewController:chooseVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:chooseVC];
    }];
    [chooseSchoolVC setFinishChooseSchool:^(XXSchoolModel *chooseSchool) {
        newUser.schoolId = chooseSchool.schoolId;
    }];
    
}
- (void)qqLoginAction
{
    
}
- (void)weiboLoginAction
{
    
}

@end

