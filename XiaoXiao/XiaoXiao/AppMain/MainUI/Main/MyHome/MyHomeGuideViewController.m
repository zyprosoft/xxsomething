//
//  MyHomeGuideViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "MyHomeGuideViewController.h"
#import "XXPhotoChooseViewController.h"
#import "SettingGuideViewController.h"


@interface MyHomeGuideViewController ()

@end

@implementation MyHomeGuideViewController

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

    //
    guideVCArray = [[NSMutableArray alloc]init];
    
    //my info
    NSDictionary *myInfo = @{@"icon":@""};
    XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
    NSString *myFansRemind = [cUser.friendHasNewShareCount intValue]==0? @"0":@"1";
    NSString *myPeerNew = [cUser.visitUserNewCount intValue]==0? @"0":@"1";
    
    
    //my share
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":cUser.postCount,@"title":@"故事",@"vcClass":@"MyShareListViewController"};
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    NSDictionary *myCare = @{@"icon":@"my_home_care.png",@"count":cUser.meCareCount,@"title":@"关心",@"vcClass":@"MyCareUserListViewController",@"remind":myFansRemind};
    NSDictionary *myFans = @{@"icon":@"my_home_fans.png",@"count":cUser.careMeCount,@"title":@"学粉",@"vcClass":@"MyFansUserListViewController",@"remind":@""};
    NSDictionary *myPee = @{@"icon":@"my_home_peer.png",@"count":cUser.visitCount,@"title":@"瞄客",@"vcClass":@"MyPeepUserListViewController",@"remind":myPeerNew};
    NSArray *userArray = @[myCare,myFans,myPee];
    NSMutableArray *userMutiArr = [NSMutableArray arrayWithArray:userArray];

    [guideVCArray addObject:myInfo];
    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userMutiArr];
    
    CGFloat originY = IS_IOS_7? 20:0;
    CGFloat totalHeight = XXNavContentHeight-49;
    CGFloat totalWidth = self.view.frame.size.width;
    
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,originY,totalWidth,totalHeight) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    guideTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    guideTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guideTable];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return guideVCArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[guideVCArray objectAtIndex:section]count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        static NSString *CellIdentifier = @"InfoIdentifier";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            //my home user head
            MyHomeUserHeadView *headView = [[MyHomeUserHeadView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width,309)];
            headView.layer.shadowOffset = CGSizeMake(0,0.1);
            headView.layer.shadowColor = [UIColor blackColor].CGColor;
            headView.layer.shadowOpacity = 0.1f;
            headView.tag = 889900;
            headView.delegate = self;
            [cell.contentView addSubview:headView];
            headView.tag = 1122;
            
            //theme back change
            _hud.labelText = @"正在更新...";
            WeakObj(_hud) weakHud = _hud;
            WeakObj(headView) weakUserHeadView = headView;
            WeakObj(self) weakSelf = self;
            
            [headView setDidTapThemeBackBlock:^{
                
                XXPhotoChooseViewController *photoChooseVC = [[XXPhotoChooseViewController alloc]initWithMutilPhotoChooseWithMaxChooseNumber:1 withFinishBlock:^(NSArray *resultImages) {
                    
                    [weakHud show:YES];
                    NSData *imageData = UIImageJPEGRepresentation([resultImages objectAtIndex:0],kCGInterpolationDefault);
                    [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"themeBack.png" withUploadProgressBlock:^(CGFloat progressValue) {
                        [SVProgressHUD showProgress:progressValue status:@"正在上传背景图片..."];
                    } withSuccessBlock:^(XXAttachmentModel *resultModel) {
                        
                        //更新壁纸
                        XXUserModel *updateUser = [[XXUserModel alloc]init];
                        updateUser.userId = [XXUserDataCenter currentLoginUser].userId;
                        updateUser.bgImage = resultModel.link;
                        
                        [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:updateUser withSuccess:^(NSString *successMsg) {
                            
                            [weakHud hide:YES];
                            [weakUserHeadView updateThemeBack:updateUser.bgImage];;
                            [weakUserHeadView updateThemeImage:[resultImages objectAtIndex:0]];
                            
                            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:weakSelf.navigationController.viewControllers.count-3] animated:YES];
                            [SVProgressHUD showSuccessWithStatus:successMsg];
                            
                        } withFaild:^(NSString *faildMsg) {
                            
                            [weakHud hide:YES];
                            [SVProgressHUD showErrorWithStatus:faildMsg];
                        }];
                        
                        
                    } withFaildBlock:^(NSString *faildMsg) {
                        [weakHud hide:YES];
                        [SVProgressHUD showErrorWithStatus:faildMsg];
                        
                    }];
                    
                }];
                photoChooseVC.needCrop = YES;
                photoChooseVC.title = @"选择图片";
                [weakSelf.navigationController pushViewController:photoChooseVC animated:YES];
                [XXCommonUitil setCommonNavigationReturnItemForViewController:photoChooseVC];
                
            }];
            [headView tapOnSettingAddTarget:self withSelector:@selector(tapOnSettingAction)];
            [headView tapOnEditProfileAddTarget:self withSelector:@selector(tapOnEditProfileAction)];
        }
        
        return cell;
        
    }else{
        
        static NSString *CellIdentifier = @"CellIdentifier";
        XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.customAccessoryView.hidden = NO;
        }
        
        if (indexPath.section==1) {
            cell.customAccessoryView.hidden = NO;

            [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
            
            CGRect iconFrame = cell.iconImageView.frame;
            cell.iconImageView.frame = CGRectMake(30,14,iconFrame.size.width,iconFrame.size.height);
            
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            CGRect tagFrame = cell.tagLabel.frame;
            cell.tagLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+16,5,tagFrame.size.width,tagFrame.size.height);
            
        }else if(indexPath.section==2){
            
            if (indexPath.row==0) {
                [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
                
            }else if(indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
                [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
                
            }else{
                [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
                
            }
            
            CGRect iconFrame = cell.iconImageView.frame;
            cell.iconImageView.frame = CGRectMake(30,iconFrame.origin.y,iconFrame.size.width,iconFrame.size.height);
            
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            CGRect tagFrame = cell.tagLabel.frame;
            cell.tagLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+16,tagFrame.origin.y,tagFrame.size.width,tagFrame.size.height);
            
        }
        
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [cell setContentDict:item];
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.f;
    }else if(section==1){
        return 15.f;
    }else if(section==2){
        return 15.f;
    }else{
        return 0.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 309;
    }else if(indexPath.section==2){
        
        if (indexPath.row == [[guideVCArray objectAtIndex:indexPath.section]count]-1) {
            return 46.5;
        }else if(indexPath.row == 0){
            return 46;
        }else{
            return 45.5;
        }
    }else if(indexPath.section == 1){
        return 47.f;
    }else{
        return 44.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 20.f;
    }else{
        return 0.f;
    }
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,0,tableView.frame.size.width-20,44)];
    headView.backgroundColor = [UIColor clearColor];
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section!=0) {
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        
        NSString *VCName = [item objectForKey:@"vcClass"];
        Class newVC = NSClassFromString(VCName);
        
        UIViewController *pushVC = [[newVC alloc]init];
        pushVC.title = [item objectForKey:@"title"];
        [self.navigationController pushViewController:pushVC animated:YES];
        [XXCommonUitil setCommonNavigationReturnItemForViewController:pushVC];
        
        if ([VCName isEqualToString:@"MyPeepUserListViewController"]) {
            //tell you i know new visit
            XXConditionModel *condtion = [[XXConditionModel alloc]init];
            condtion.type = @"new_audiences";
            [[XXMainDataCenter shareCenter]requestIKnowNewRemindWithCondition:condtion WithSuccess:^(NSString *successMsg) {
                
            } withFaild:^(NSString *faildMsg) {
                
            }];
            NSMutableArray *userArray = [guideVCArray objectAtIndex:2];
            [userArray removeLastObject];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            NSDictionary *myPee = @{@"icon":@"my_home_peer.png",@"count":cUser.visitCount,@"title":@"瞄客",@"vcClass":@"MyPeepUserListViewController",@"remind":@"0"};
            [userArray addObject:myPee];
            [guideVCArray replaceObjectAtIndex:2 withObject:userArray];
            [guideTable reloadData];
        }
        if ([VCName isEqualToString:@"MyCareUserListViewController"]) {
            NSMutableArray *userArray = [guideVCArray objectAtIndex:2];
            [userArray removeObjectAtIndex:0];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            NSDictionary *myCare = @{@"icon":@"my_home_care.png",@"count":cUser.meCareCount,@"title":@"关心",@"vcClass":@"MyCareUserListViewController",@"remind":@"0"};
            [userArray insertObject:myCare atIndex:0];
            [guideVCArray replaceObjectAtIndex:2 withObject:userArray];
            [guideTable reloadData];
        }
        if ([VCName isEqualToString:@"MyFansUserListViewController"]) {
            NSMutableArray *userArray = [guideVCArray objectAtIndex:2];
            [userArray removeObjectAtIndex:1];
            XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
            NSDictionary *myFans = @{@"icon":@"my_home_fans.png",@"count":cUser.careMeCount,@"title":@"学粉",@"vcClass":@"MyFansUserListViewController",@"remind":@"0"};
            [userArray insertObject:myFans atIndex:1];
            [guideVCArray replaceObjectAtIndex:2 withObject:userArray];
            [guideTable reloadData];
        }
    }
}

#pragma mark - setting 
- (void)tapOnSettingAction
{
    SettingGuideViewController *settingVC = [[SettingGuideViewController alloc]init];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:settingVC];
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)tapOnEditProfileAction
{
    XXEditInputViewController *inputVC = [[XXEditInputViewController alloc]initWithFinishAction:^(NSString *resultText) {
        XXUserModel *cUser = [XXUserDataCenter currentLoginUser];
        cUser.signature = resultText;
        [XXUserDataCenter loginThisUser:cUser];
        [[NSNotificationCenter defaultCenter]postNotificationName:XXUserHasUpdateProfileNoti object:nil];
        [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:cUser withSuccess:^(NSString *successMsg) {
            [guideTable reloadData];
            [self.navigationController popViewControllerAnimated:YES];
        } withFaild:^(NSString *faildMsg) {
            [SVProgressHUD showErrorWithStatus:faildMsg];
        }];
    }];
    inputVC.title = @"编辑签名";
    [self.navigationController pushViewController:inputVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:inputVC];
    inputVC.inputTextView.text = [XXUserDataCenter currentLoginUser].signature;

}
#pragma mark Home User View Delegate
- (void)homeUserHeadViewDidTapOnHeadAction:(MyHomeUserHeadView *)headView
{
    DDLogVerbose(@"tapOnHeadView!!!!!+++++");
    XXUserModel *newUser = [[XXUserModel alloc]init];
    
    //upload head image
    void (^UploadChooseImageBlock) (UIImage *aImage) = ^ (UIImage *aImage){
        NSData *imageData = UIImageJPEGRepresentation(aImage,1.0);
        [[XXMainDataCenter shareCenter]uploadFileWithData:imageData withFileName:@"head.png" withUploadProgressBlock:^(CGFloat progressValue) {
            [SVProgressHUD showProgress:progressValue status:@"正在上传头像..."];
        } withSuccessBlock:^(XXAttachmentModel *resultModel) {
            newUser.headUrl = resultModel.link;
            [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
            
            //update visiable
            UITableViewCell *cell = [guideTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            MyHomeUserHeadView *headView = (MyHomeUserHeadView*)[cell.contentView viewWithTag:1122];
            [headView.headView.contentImageView setImage:aImage];
            
            //update
            [[XXMainDataCenter shareCenter]requestUpdateUserInfoWithConditionUser:newUser withSuccess:^(NSString *successMsg) {
                [SVProgressHUD showSuccessWithStatus:@"更新头像成功"];
                [self.navigationController popToViewController:self animated:YES];
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:@"更新头像失败"];
            }];
            
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
    [self.navigationController pushViewController:chooseVC animated:YES];
    [XXCommonUitil setCommonNavigationReturnItemForViewController:chooseVC];

}

@end
