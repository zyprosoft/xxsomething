//
//  OtherUserHomeViewController.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "OtherUserHomeViewController.h"
#import "OtherHomeHeadCell.h"
#import "OtherHomeButtonCell.h"	
#import "OtherHomeMutilTextCell.h"
#import "OtherUserTeaseSelectViewController.h"
#import "OtherUserShareListViewController.h"
#import "OtherUserFansListViewController.h"
#import "XXChatViewController.h"
#import "XXCustomButton.h"

@interface OtherUserHomeViewController ()

@end

@implementation OtherUserHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithContentUser:(XXUserModel *)aUser
{
    if (self = [super init]) {
        
        _currentUser = aUser;
        self.title = aUser.nickName;
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [XXCommonUitil setCommonNavigationReturnItemForViewController:self withBackStepAction:^{
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    //
    guideVCArray = [[NSMutableArray alloc]init];

    //load defaul data
    [self loadUserData];
    
    CGFloat totalHeight = XXNavContentHeight-44;
    CGFloat totalWidth = self.view.frame.size.width;
    
    //barBack
    barBack = [[UIImageView alloc]init];
    barBack.backgroundColor = [XXCommonStyle xxThemeDarkBlueColor];
    barBack.frame = CGRectMake(0,totalHeight-49,self.view.frame.size.width,49);
    barBack.userInteractionEnabled=YES;
    [self.view addSubview:barBack];
    
    UIImage *buttonNormal = [[UIImage imageNamed:@"other_button_back.png"]t:3 l:5 b:3 r:5];
    UIImage *buttonSelected = [[UIImage imageNamed:@"other_button__back_selected.png"]t:3 l:5 b:3 r:5];
    
    _leaveMsgButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _leaveMsgButton.frame = CGRectMake(3,7,156.5,35);
    _leaveMsgButton.layer.cornerRadius = 0.f;
    [_leaveMsgButton setNormalIconImage:@"other_home_leave_msg.png" withSelectedImage:@"other_home_leave_msg.png" withFrame:CGRectMake(50,7.5,20,20)];
    [_leaveMsgButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
    [_leaveMsgButton setTitle:@"对话" forState:UIControlStateNormal];
    [_leaveMsgButton setBackgroundImage:buttonNormal forState:UIControlStateNormal];
    [_leaveMsgButton setBackgroundImage:buttonSelected forState:UIControlStateHighlighted];
    [_leaveMsgButton addTarget:self action:@selector(leaveMessageAction) forControlEvents:UIControlEventTouchUpInside];
    [barBack addSubview:_leaveMsgButton];
    
    _careButton = [XXCustomButton buttonWithType:UIButtonTypeCustom];
    _careButton.frame = CGRectMake(161,7,156,35);
    _careButton.layer.cornerRadius = 0.f;
    [_careButton setNormalIconImage:@"other_home_tease.png" withSelectedImage:@"other_home_tease.png" withFrame:CGRectMake(50,8.5,21,18)];
    [_careButton setTitle:@"挑逗" forState:UIControlStateNormal];
    [_careButton setTitleEdgeInsets:UIEdgeInsetsMake(0,30,0,0)];
    [_careButton setBackgroundImage:buttonNormal forState:UIControlStateNormal];
    [_careButton setBackgroundImage:buttonSelected forState:UIControlStateHighlighted];
    [_careButton addTarget:self action:@selector(teaseAction) forControlEvents:UIControlEventTouchUpInside];
    [barBack addSubview:_careButton];
    
    CGFloat isSelfDetalHeight =  0.f;
    if ([_currentUser.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        isSelfDetalHeight = 0.f;
        barBack.hidden = YES;
    }else{
        isSelfDetalHeight = 49.f;
        barBack.hidden = NO;
    }
    guideTable = [[UITableView alloc]initWithFrame:CGRectMake(0,0,totalWidth,totalHeight-isSelfDetalHeight) style:UITableViewStylePlain];
    guideTable.dataSource = self;
    guideTable.delegate = self;
    guideTable.backgroundColor = [XXCommonStyle xxThemeBackgroundColor];
    guideTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:guideTable];
    
    if (![_currentUser.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        XXConditionModel *condtion = [[XXConditionModel alloc]init];
        condtion.userId = _currentUser.userId;
        [[XXMainDataCenter shareCenter]requestVisitUserHomeWithCondition:condtion withSuccess:^(NSString *successMsg) {
            DDLogVerbose(@"visit user home success:%@",successMsg);
        } withFaild:^(NSString *faildMsg) {
            
        }];
    }
    //load detail data
    [self requestUserDetailAction];
}

#pragma mark - table source
- (void)loadUserData
{
    //my share
    NSArray *headArray = @[_currentUser];
    [guideVCArray addObject:headArray];
    
    NSString *remindValue =nil;
    if ([_currentUser.hasNewPosts intValue]>0) {
        remindValue = @"1";
    }else{
        remindValue = @"0";
    }
    
    NSDictionary *myShare = @{@"icon":@"my_home_photo.png",@"count":_currentUser.postCount,@"title":@"故事",@"vcClass":@"OtherUserShareListViewController",@"remind":remindValue};
    
    NSArray *shareArray = [NSArray arrayWithObject:myShare];
    
//    NSDictionary *IDSource = @{@"tag":@"校校号",@"content":_currentUser.userId,@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *signSource = @{@"tag":@"个性签名",@"content":_currentUser.signature,@"isMutil":@"1",@"vcClass":@""};
    NSDictionary *collegeSource = @{@"tag":_currentUser.schoolName,@"content":@"",@"isMutil":@"0",@"vcClass":@""};
    NSInteger userType = [_currentUser.type intValue];
    NSDictionary *grageSource  = nil;
    if (userType == 2) {
        NSString *collegeCombine = [NSString stringWithFormat:@"%@",_currentUser.college];
        grageSource = @{@"tag":collegeCombine,@"content":@"",@"isMutil":@"0",@"vcClass":@""};
    }else{
        NSString *gradeCombine = [NSString stringWithFormat:@"%@ | %@",_currentUser.schoolRoll,_currentUser.grade];
        grageSource = @{@"tag":gradeCombine,@"content":@"",@"isMutil":@"0",@"vcClass":@""};
    }
    NSDictionary *grage = @{@"tag":_currentUser.grade,@"content":@"",@"isMutil":@"0",@"vcClass":@""};
    
    NSString *scoreCombine = [NSString stringWithFormat:@"校财富排名 | %@",_currentUser.schoolRank];
    NSDictionary *moneySource = @{@"tag":scoreCombine,@"content":@"",@"isMutil":@"0",@"vcClass":@""};
    NSDictionary *fansSource = @{@"tag":@"他的学粉",@"content":_currentUser.careMeCount,@"isMutil":@"0",@"vcClass":@"OtherUserFansListViewController"};
    
    NSArray *userArray = nil;
    if (userType==2) {
        userArray = @[signSource,collegeSource,grageSource,grage,moneySource,fansSource];
    }else{
        userArray = @[signSource,collegeSource,grageSource,moneySource,fansSource];
    }
    
    [guideVCArray addObject:shareArray];
    [guideVCArray addObject:userArray];
    
}

#pragma mark - request User detail
- (void)requestUserDetailAction
{
    [[XXMainDataCenter shareCenter]requestUserDetailWithDetinationUser:_currentUser withSuccess:^(XXUserModel *detailUser) {
       
        detailUser.hasNewPosts = _currentUser.hasNewPosts;
        _currentUser = detailUser;
        [guideVCArray removeAllObjects];
        [self loadUserData];
        [guideTable reloadData];
        
    } withFaild:^(NSString *faildMsg) {
        
    }];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        OtherHomeHeadCell *headCell = (OtherHomeHeadCell*)[guideTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if ([_currentUser.isCareYou boolValue]) {
            
            [[XXMainDataCenter shareCenter]requestCancelFriendCareWithConditionFriend:_currentUser withSuccess:^(NSString *successMsg) {
                _currentUser.isCareYou = @"0";
                _isCareYou = NO;
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [headCell updateUserCared:_isCareYou];
            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:@"取消失败"];
            }];
            
        }else{
            
            [[XXMainDataCenter shareCenter]requestAddFriendCareWithConditionFriend:_currentUser withSuccess:^(NSString *successMsg) {
                _currentUser.isCareYou = @"1";
                _isCareYou = YES;
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [headCell updateUserCared:_isCareYou];

            } withFaild:^(NSString *faildMsg) {
                [SVProgressHUD showErrorWithStatus:@"添加失败"];
            }];
        }
        

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
//    CGRect naviRect = self.navigationController.view.frame;
//    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
//
//}
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
//    CGRect naviRect = self.navigationController.view.frame;
//    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
//    [super viewWillDisappear:animated];
//}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[XXCommonUitil appMainTabController] setTabBarHidden:YES];
    CGRect naviRect = self.navigationController.view.frame;
    self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height+49);
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
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"CellIdentifier";
        OtherHomeHeadCell *cell = (OtherHomeHeadCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[OtherHomeHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setTeaseActionBlock:^{
                
                if (![_currentUser.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
                    BOOL isCared = [_currentUser.isCareYou boolValue];
                    
                    if (isCared) {
                        
                        UIAlertView *alertCare = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"确定取消对他的关心?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertCare show];
                        
                    }else{
                        
                        UIAlertView *alertCare = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"你确定成为他的学粉吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        [alertCare show];
                        
                    }
                }
                
            }];
        }
        [cell setContentUser:_currentUser];
        
        return cell;
        
    }else if(indexPath.section == 1){
        
        static NSString *CellIdentifier = @"IconTagCellIdentifier";
        XXBaseIconLabelCell *cell = (XXBaseIconLabelCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[XXBaseIconLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.customAccessoryView.hidden = NO;
            
            CGRect iconFrame = cell.iconImageView.frame;
            cell.iconImageView.frame = CGRectMake(30,iconFrame.origin.y+2,iconFrame.size.width,iconFrame.size.height);
            
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            CGRect tagFrame = cell.tagLabel.frame;
            cell.tagLabel.frame = CGRectMake(cell.iconImageView.frame.origin.x+cell.iconImageView.frame.size.width+16,tagFrame.origin.y+2,tagFrame.size.width,tagFrame.size.height);
        }
        
        [cell setCellType:XXBaseCellTypeRoundSingle withBottomMargin:0.f withCellHeight:47.f];
        NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
        [cell setContentDict:item];
        return cell;

    }else{
       
        static NSString *CellIdentifier = @"MutilCellIdentifier";
        OtherHomeMutilTextCell *cell = (OtherHomeMutilTextCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[OtherHomeMutilTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.tagLabel.font = [UIFont systemFontOfSize:17.5];
            cell.contentLabel.textColor = rgb(125,130,136,1);
            cell.contentLabel.font = [UIFont systemFontOfSize:13];
            cell.countLabel.textColor = rgb(125,130,136,1);
            cell.countLabel.font = [UIFont systemFontOfSize:13];
        }
        if(indexPath.section==2&&indexPath.row==0){
            [cell setCellType:XXBaseCellTypeTop withBottomMargin:0.f withCellHeight:46.f];
        }else if(indexPath.section==2&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1){
            [cell setCellType:XXBaseCellTypeBottom withBottomMargin:0.f withCellHeight:46.5f];
            cell.customAccessoryView.hidden = NO;
        }else{
            [cell setCellType:XXBaseCellTypeMiddel withBottomMargin:0.f withCellHeight:45.5f];
        }
        [cell setContentDict:[[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
        
        return cell;
        
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 223+223;
    }
    if (indexPath.section==1) {
        return 47.f;
    }
    if (indexPath.section==2) {
        
        if (indexPath.row == guideVCArray.count-1) {
            return 46.5;
        }else{
            NSDictionary *item = [[guideVCArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
            
            return [OtherHomeMutilTextCell heightForContentDict:item forWidth:tableView.frame.size.width];
        }
    }
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0.f;
    }else{
        return 15.f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==2) {
        return 15.f;
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

    if (indexPath.section==1) {
        OtherUserShareListViewController *shareVC = [[OtherUserShareListViewController alloc]init];
        shareVC.otherUserId = _currentUser.userId;
        shareVC.title = @"故事";
        [self.navigationController pushViewController:shareVC animated:YES];
        
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
        
    }
    if (indexPath.section==2&&indexPath.row==[[guideVCArray objectAtIndex:indexPath.section]count]-1) {
        OtherUserFansListViewController *fansVC = [[OtherUserFansListViewController alloc]init];
        fansVC.otherUserId = _currentUser.userId;
        fansVC.title = @"他的学粉";
        [self.navigationController pushViewController:fansVC animated:YES];
        
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
    }
}

#pragma mark config select tease
- (void)teaseAction
{
    if (![_currentUser.userId isEqualToString:[XXUserDataCenter currentLoginUser].userId]) {
        OtherUserTeaseSelectViewController *teaseVC = [[OtherUserTeaseSelectViewController alloc]init];
        teaseVC.selectUser = _currentUser.userId;
        [self.navigationController pushViewController:teaseVC animated:YES];
        [[XXCommonUitil appMainTabController] setTabBarHidden:NO];
        CGRect naviRect = self.navigationController.view.frame;
        self.navigationController.view.frame = CGRectMake(naviRect.origin.x,naviRect.origin.y,naviRect.size.width,naviRect.size.height-49);
    }else{
        [SVProgressHUD showErrorWithStatus:@"不能挑逗自己～,客官请自重"];
    }
}

- (void)careAction
{
    
}

- (void)leaveMessageAction
{
    XXChatViewController *chatViewController = [[XXChatViewController alloc]initWithChatUser:_currentUser];
    chatViewController.title = _currentUser.nickName;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

@end
