//
//  XXMainDataCenter.m
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import "XXMainDataCenter.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPRequestOperation.h"
#import "XXHTTPClient.h"
#import "NSDictionary+UrlEncodedString.h"

#define XXLoginErrorInvalidateParam @"请求参数不完整"
#define XXNetWorkDisConnected @"网络无法链接"
#define XXRegistDefaultHeadName @"head.jpg"
#define XXDefaultString @"xxdefault"

@implementation XXMainDataCenter
+ (XXMainDataCenter*)shareCenter
{
    static XXMainDataCenter *_sharedCenter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedCenter = [[self alloc]init];
    });
    
    return _sharedCenter;
}
- (void)checkNetWorkWithFaildBlck:(XXDataCenterRequestFaildMsgBlock)faild
{
    //是否存在网络
    if ([[XXHTTPClient shareClient] networkReachabilityStatus]==AFNetworkReachabilityStatusNotReachable) {
        if (faild) {
            faild(XXNetWorkDisConnected);
            return;
        }
    }
}

//纯POST
- (void)requestXXRequest:(XXRequestType)requestType withParams:(NSDictionary *)params withHttpMethod:(NSString *)method withSuccess:(void (^)(NSDictionary *resultDict))success withFaild:(void (^)(NSString *faildMsg))faild
{
    //是否存在网络
    [self checkNetWorkWithFaildBlck:faild];
    
    DDLogVerbose(@"start request with token:%@",[XXUserDataCenter currentLoginUserToken]);
    
    [[XXHTTPClient shareClient] postPath:[XXDataCenterConst switchRequestTypeToInterfaceUrl:requestType] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = (NSDictionary*)responseObject;
        
        //解析对错
        int status = [[resultDict objectForKey:@"ret"]intValue];
        
        if (status==0) {
            
            if (success) {
                DDLogVerbose(@"success post result:%@",resultDict);
                success(resultDict);
            }
        }else{
            
            DDLogVerbose(@"status:%d error Msg:%@",status,[responseObject objectForKey:@"msg"]);

            if (faild) {
                faild([resultDict objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            
            DDLogVerbose(@"connection server error:%@",[error description]);
            faild(@"连接服务器失败");
        }
        
    }];   
}
//POST,GET混合
- (void)requestXXRequest:(XXRequestType)requestType withPostParams:(NSDictionary*)pParams withGetParams:(NSDictionary*)gParams withSuccess:(void (^)(NSDictionary *resultDict))success withFaild:(void(^)(NSString *faildMsg))faild
{
    //是否存在网络
    [self checkNetWorkWithFaildBlck:faild];
    
    DDLogVerbose(@"start request with token:%@",[XXUserDataCenter currentLoginUserToken]);

    //GetParam
    NSString *interfaceUrl = [XXDataCenterConst switchRequestTypeToInterfaceUrl:requestType];
    NSString *gParamString = [gParams urlEncodedString];
    interfaceUrl = [NSString stringWithFormat:@"%@?%@",interfaceUrl,gParamString];
    
    DDLogVerbose(@"post params:%@",pParams);
    
    [[XXHTTPClient shareClient] postPath:interfaceUrl parameters:pParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *resultDict = (NSDictionary*)responseObject;

        //解析对错
        int status = [[resultDict objectForKey:@"ret"]intValue];
        if (status==0) {
            
            if (success) {
                DDLogVerbose(@"success post and get result:%@",resultDict);
                success(resultDict);
            }
            
        }else{
            
            DDLogVerbose(@"status:%d error Msg:%@",status,[responseObject objectForKey:@"msg"]);

            if (faild) {
                faild([resultDict objectForKey:@"msg"]);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (faild) {
            
            DDLogVerbose(@"connection server error:%@",[error description]);

            faild(@"连接服务器失败");
        }
        
    }];
}

#pragma mark - common upload
- (NSString*)mediaFileTypeForFileName:(NSString*)fileName
{
    NSArray *nameArray = [fileName componentsSeparatedByString:@"."];
    NSString *fileExtension = [nameArray lastObject];
    
    NSString *fileType = nil;
    if ([fileExtension isEqualToString:@"jpg"]) {
        fileType = @"image/jpeg";
    }
    
    if ([fileExtension isEqualToString:@"png"]) {
        fileType = @"image/png";
    }
    
    if ([fileExtension isEqualToString:@"jpeg"]) {
        fileType = @"image/jpeg";
    }
    
    if ([fileExtension isEqualToString:@"amr"]) {
        fileType = @"audio/amr";
    }
    
    if ([fileExtension isEqualToString:@"mp3"]) {
        fileType = @"audio/mp3";
    }
    
    return fileType;
    
}
- (NSData*)imageDataWithImage:(UIImage *)image WithName:(NSString*)imageName
{
    NSData *imageData = nil;
    if ([imageName rangeOfString:@"png"].location!=NSNotFound) {
        imageData = UIImagePNGRepresentation(image);
    }
    if ([imageName rangeOfString:@"jpg"].location!=NSNotFound || [imageName rangeOfString:@"jpeg"].location!=NSNotFound) {
        imageData = UIImageJPEGRepresentation(image,0.5);
    }
    return imageData;
}

- (void)uploadFileWithData:(NSData *)fileData withFileName:(NSString *)fileName withUploadProgressBlock:(XXDataCenterUploadFileProgressBlock)uploadProgressBlock withSuccessBlock:(XXDataCenterUploadFileSuccessBlock)success withFaildBlock:(XXDataCenterRequestFaildMsgBlock)faild
{
    //是否存在网络
    [self checkNetWorkWithFaildBlck:faild];

    NSMutableURLRequest *uploadRequest  = [[XXHTTPClient shareClient] multipartFormRequestWithMethod:@"POST" path:[XXDataCenterConst switchRequestTypeToInterfaceUrl:XXRequestTypeUploadFile] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:@"upload" fileName:fileName mimeType:[self mediaFileTypeForFileName:fileName]];
    }];
    AFJSONRequestOperation *jsonRequest = [AFJSONRequestOperation JSONRequestOperationWithRequest:uploadRequest success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *resultDict = (NSDictionary*)JSON;
        
        DDLogVerbose(@"resultDict -->%@",resultDict);
        NSInteger statusCode = [[resultDict objectForKey:@"ret"]intValue];
        if (statusCode==0) {
            
            NSArray *usefulProperty = @[@"attachment_id",@"user_id",@"add_time",@"filename",@"link",@"description"];
            NSDictionary *mDict = @{@"attachment_id": @"",@"user_id":@"",@"add_time":@"",@"filename":@"",@"link":@"",@"description":@""};
            NSMutableDictionary *modelDict = [NSMutableDictionary dictionaryWithDictionary:mDict];
            [resultDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                if ([usefulProperty containsObject:(NSString*)key]) {
                    [modelDict setObject:obj forKey:key];
                }
            }];
            DDLogVerbose(@"fileter dict -->%@",modelDict);
            XXAttachmentModel *attachModel = [[XXAttachmentModel alloc]initWithContentDict:modelDict];
            DDLogVerbose(@"attachModel --->%@",attachModel);
            if (success) {
                success(attachModel);
            }
            
        }else{
            if (faild) {
                faild([resultDict objectForKey:@"msg"]);
            }
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (error.code!=-999) {
            if (faild) {
                faild([error description]);
            }
        }
    }];
    [jsonRequest setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        CGFloat uploadKbSize = totalBytesWritten/1024.0f;
        CGFloat totoalSize = totalBytesExpectedToWrite/1024.0f;
        CGFloat uploadProgressValue = (uploadKbSize/1024.f)/(totoalSize/1024.f);

        if (uploadProgressBlock) {
            uploadProgressBlock(uploadProgressValue);
        }
        
    }];
    [[XXHTTPClient shareClient] enqueueHTTPRequestOperation:jsonRequest];
}

- (void)requestLoginWithNewUser:(XXUserModel *)newUser withSuccessLogin:(void (^)(XXUserModel *))success withFaildLogin:(void (^)(NSString *))faild
{
    if (!newUser.account||!newUser.password) {
        if (faild) {
            faild (XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"account":newUser.account,@"password":newUser.password};
    
    [self requestXXRequest:XXRequestTypeLogin withParams:params withHttpMethod:nil withSuccess:^(NSDictionary *resultDict) {
       
        DDLogVerbose(@"login result dict --->%@",resultDict);
        NSDictionary *userData = [resultDict objectForKey:@"user"];
        NSMutableDictionary *userMutil = [NSMutableDictionary dictionaryWithDictionary:userData];
        [userMutil setObject:[resultDict objectForKey:@"token"] forKey:@"token"];
        [userMutil setObject:@"1" forKey:@"status"];
        
        XXUserModel *loginUser = [[XXUserModel alloc]initWithContentDict:userMutil];
        loginUser.password = newUser.password;
        loginUser.account = newUser.account;
        [XXUserDataCenter loginThisUser:loginUser];//保存当前登录用户
        [[XXHTTPClient shareClient]updateToken];//刷新token
        if (success) {
            success(loginUser);
        }
        
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

- (void)requestRegistWithNewUser:(XXUserModel *)newUser withSuccessRegist:(XXDataCenterRequestDetailUserBlock)success withFaildRegist:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!newUser.account||!newUser.password||!newUser.schoolId||!newUser.headUrl) {
        if (faild) {
            faild (XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *normalParams = @{@"account":newUser.account,@"password":newUser.password,@"xuexiao_id":newUser.schoolId,@"picture":newUser.headUrl};
    
    [self requestXXRequest:XXRequestTypeRegist withParams:normalParams withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        DDLogVerbose(@"regist result -->%@",resultDict);
        XXUserModel *registUserModel = [[XXUserModel alloc]init];
        registUserModel.userId = [resultDict objectForKey:@"user_id"];
        if (success) {
            success(registUserModel);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
        DDLogVerbose(@"regist faild -->%@",faildMsg);
    }];
    
}

- (void)requestSearchSchoolListWithDescription:(XXSchoolModel*)conditionSchool WithSuccessSearch:(XXDataCenterRequestSuccessListBlock)success withFaildSearch:(XXDataCenterRequestFaildMsgBlock)faild
{
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (conditionSchool.searchKeyword) {
        [params setObject:conditionSchool.searchKeyword forKey:@"keyword"];
    }
    if (conditionSchool.type) {
        [params setObject:conditionSchool.type forKey:@"type"];
    }
    if (conditionSchool.area) {
        [params setObject:conditionSchool.area forKey:@"area"];
    }
    if (conditionSchool.city) {
        [params setObject:conditionSchool.city forKey:@"city"];
    }
    if (conditionSchool.province) {
        [params setObject:conditionSchool.province forKey:@"province"];
    }
    
    [self requestXXRequest:XXRequestTypeSearchSchool withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        DDLogVerbose(@"resultDict -->%@",resultDict);
        NSArray *schoolList = [resultDict objectForKey:@"data"];
        NSMutableArray *modelResultArray = [NSMutableArray array];
        for (NSDictionary *item in schoolList) {
            
            XXSchoolModel *schoolModel = [[XXSchoolModel alloc]initWithContentDict:item];
            [modelResultArray addObject:schoolModel];
        }
        if (success) {
            success(modelResultArray);
        }
        
    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
        
    }];
    
}

/////////////=====================    ===============================//////////////////
//潜伏学校
- (void)requestStrollSchoolWithConditionSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionSchool.schoolId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *param = @{@"xuexiao_id":conditionSchool.schoolId};
    [self requestXXRequest:XXRequestTypeStrollSchool withParams:param withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"stroll schooll success --->%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//更新用户资料
- (void)requestUpdateUserInfoWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (conditionUser.account) {
        [params setObject:conditionUser.account forKey:@"account"];
    }
    if (conditionUser.password) {
        [params setObject:conditionUser.password forKey:@"password"];
    }
    if (conditionUser.nickName) {
        [params setObject:conditionUser.nickName forKey:@"nickname"];
    }
    if (conditionUser.email){
        [params setObject:conditionUser.email forKey:@"email"];
    }
    if(conditionUser.grade){
        [params setObject:conditionUser.grade forKey:@"grade"];
    }
    if(conditionUser.sex){
        [params setObject:conditionUser.sex forKey:@"sex"];
    }
    if(conditionUser.birthDay){
        [params setObject:conditionUser.birthDay forKey:@"birthday"];
    }
    if(conditionUser.signature){
        [params setObject:conditionUser.signature forKey:@"signature"];
    }
    if(conditionUser.headUrl){
        [params setObject:conditionUser.headUrl forKey:@"picture"];
    }
    if(conditionUser.bgImage){
        [params setObject:conditionUser.bgImage forKey:@"bgimage"];
    }
    if(conditionUser.constellation){
        [params setObject:conditionUser.constellation forKey:@"constellation"];
    }
    if(conditionUser.schoolId){
        [params setObject:conditionUser.schoolId forKey:@"xuexiao_id"];
    }
    if(conditionUser.strollSchoolId){
        [params setObject:conditionUser.strollSchoolId forKey:@"stroll_xuexiao_id"];
    }
    if(conditionUser.schoolRoll){
        [params setObject:conditionUser.schoolRoll forKey:@"schoolroll"];
    }
    if(conditionUser.college){
        [params setObject:conditionUser.college forKey:@"college"];
    }
    if (conditionUser.type) {
        [params setObject:conditionUser.type forKey:@"type"];
    }
    DDLogVerbose(@"update user info-->%@",params);
    [self requestXXRequest:XXRequestTypeUpdateUserInfo withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];

}

//附件详情
- (void)requestAttachmentDetailWithConditionAttachment:(XXAttachmentModel*)conditionAttachment withSuccess:(XXDataCenterUploadFileSuccessBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionAttachment.attachementId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"attachment_id":conditionAttachment.attachementId};
    [self requestXXRequest:XXRequestTypeFileDetail withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"attchment detail:%@",resultDict);
        if (success) {
            XXAttachmentModel *newAttachment = [[XXAttachmentModel alloc]initWithContentDict:[resultDict objectForKey:@"attachment"]];
            success(newAttachment);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//添加好友关心
- (void)requestAddFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionFriend.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionFriend.userId};
    [self requestXXRequest:XXRequestTypeAddFriendCare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"add friend care resutl:%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//取消好友关心
- (void)requestCancelFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionFriend.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionFriend.userId};
    [self requestXXRequest:XXRequestTypeCancelFriendCare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"cancel friend care result:%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//我关心的列表搜索
- (void)requestMyCareFriendWithConditionFriend:(XXConditionModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(conditionFriend.keyword){
        [params setObject:conditionFriend.keyword forKey:@"keyword"];
    }
    NSMutableDictionary *getParams = [NSMutableDictionary dictionary];
    [getParams setObject:conditionFriend.pageIndex forKey:@"page"];
    [getParams setObject:conditionFriend.pageSize forKey:@"size"];
    
    [self requestXXRequest:XXRequestTypeMyCareFriend withPostParams:params withGetParams:nil withSuccess:^(NSDictionary *resultDict) {
       
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:item];
                DDLogVerbose(@"user profile:%@",newUser.signature);
                newUser.isInSchool = @"0";
                newUser.isInMyCareList = @"1";
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
            success(modelArray);
        }
        
    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
        
    }];
}

//关心我的列表搜索
- (void)requestCareMeFriendWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionFriend.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(conditionFriend.keyword){
        [params setObject:conditionFriend.keyword forKey:@"keyword"];
    }
    [self requestXXRequest:XXRequestTypeCareMe withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"my care friend list:%@",resultDict);
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:item];
                DDLogVerbose(@"user profile:%@",newUser.signature);
                newUser.isInSchool = @"0";
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//发表评论
- (void)requestPublishCommentWithConditionComment:(XXCommentModel*)conditionComment withSuccess:(XXDataCenterCommentDetailBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionComment.resourceId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if ([conditionComment.postAudioTime isEqualToString:@"0"]) {
        if (!conditionComment.postContent) {
            if (faild) {
                faild(XXLoginErrorInvalidateParam);
                return;
            }
        }
    }else{
        if (!conditionComment.postAudio) {
            if (faild) {
                faild(XXLoginErrorInvalidateParam);
                return;
            }
        }
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:conditionComment.resourceId forKey:@"res_id"];
    if (conditionComment.resourceType) {
        [params setObject:conditionComment.resourceType forKey:@"res_type"];
    }
    if (conditionComment.pCommentId) {
        [params setObject:conditionComment.pCommentId forKey:@"p_id"];
    }
    if (conditionComment.rootCommentId) {
        [params setObject:conditionComment.rootCommentId forKey:@"root_id"];
    }
    
    //自定义结构体
    NSMutableDictionary *customContent = [NSMutableDictionary dictionary];
    if ([conditionComment.postAudioTime isEqualToString:@"0"]) {
        [customContent setObject:conditionComment.postContent forKey:XXSharePostJSONContentKey];
    }else{
        [customContent setObject:conditionComment.postAudio forKey:XXSharePostJSONAudioKey];
    }
    [customContent setObject:conditionComment.postAudioTime forKey:XXSharePostJSONAudioTime];
    NSData *customContentData = [NSJSONSerialization dataWithJSONObject:customContent options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:customContentData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"content"];
    
    [self requestXXRequest:XXRequestTypeCommentPublish withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            DDLogVerbose(@"publish comment :%@",resultDict);
            conditionComment.commentId = [resultDict objectForKey:@"comment_id"];
            success(conditionComment);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//评论列表
- (void)requestCommentListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    //接口有问题，传递参数太多
    if (!condition.pageIndex || !condition.pageSize || !condition.postId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"res_id":condition.postId};
    NSMutableDictionary *mutilParams = [NSMutableDictionary dictionaryWithDictionary:params];
    if (condition.toUserId) {
        [mutilParams setObject:condition.toUserId forKey:@"to_user_id"];
        [mutilParams setObject:[XXUserDataCenter currentLoginUser].userId forKey:@"user_id"];
    }
    NSDictionary *getParams = @{@"page":condition.pageIndex,@"size":condition.pageSize};
    [self requestXXRequest:XXRequestTypeCommentList withPostParams:mutilParams withGetParams:getParams withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            
            NSDictionary *dataDict = [resultDict objectForKey:@"data"];
            NSArray *tableData = [dataDict objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [tableData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                XXCommentModel *commentModel = [[XXCommentModel alloc]initWithContentDict:obj];
                [modelArray addObject:commentModel];
            }];
            success(modelArray);
            
        }
        
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//追捧
- (void)requestPraisePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.resId||!condition.resType) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"res_id":condition.resId,@"res_type":condition.resType};
    [self requestXXRequest:XXRequestTypePraisePublish withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"praise publish count:%@",resultDict);
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//分享列表
- (void)requestSharePostListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSMutableDictionary *getParams = [NSMutableDictionary dictionary];
    if (condition.pageIndex) {
        [getParams setObject:condition.pageIndex forKey:@"page"];
    }
    if (condition.pageSize) {
        [getParams setObject:condition.pageSize forKey:@"size"];
    }
    if (condition.userId) {
        [postParams setObject:condition.userId forKey:@"user_id"];
    }
    if (condition.sex) {
        [postParams setObject:condition.sex forKey:@"sex"];
    }
    if (condition.grade) {
        [postParams setObject:condition.grade forKey:@"grade"];
    }
    if (condition.schoolId) {
        [postParams setObject:condition.schoolId forKey:@"xuexiao_id"];
    }
    if (condition.type) {
        [postParams setObject:condition.type forKey:@"type"];
    }
    if (condition.tag) {
        [postParams setObject:condition.tag forKey:@"tag"];
    }
    if (condition.resId) {
        [postParams setObject:condition.resId forKey:@"id"];
    }
    [self requestXXRequest:XXRequestTypeSharePostSearch withPostParams:postParams withGetParams:getParams withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"share post search result:%@",resultDict);
        if (success) {
            NSArray *shareList = [[resultDict objectForKey:@"data"]objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [shareList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *contentItem = (NSDictionary*)obj;
                XXSharePostModel *sharePost = [[XXSharePostModel alloc]initWithContentDict:contentItem];
                [modelArray addObject:sharePost];
            }];
            success(modelArray);
        }
        
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//发表分享
- (void)requestPostShareWithConditionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionPost.postContent&&!conditionPost.postType&&!conditionPost.postImages&&!conditionPost.postAudio) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if (![XXUserDataCenter currentLoginUser]) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    if (conditionPost.postContent) {
        [content setObject:conditionPost.postContent forKey:XXSharePostJSONContentKey];
    }
    if (conditionPost.postType) {
        [content setObject:[NSNumber numberWithInt:conditionPost.postType] forKey:XXSharePostJSONTypeKey];
    }
    if (conditionPost.postImages) {
        [content setObject:conditionPost.postImages forKey:XXSharePostJSONImageKey];
    }
    if (conditionPost.postAudio) {
        [content setObject:conditionPost.postAudio forKey:XXSharePostJSONAudioKey];
    }
    if (conditionPost.postAudioTime) {
        [content setObject:conditionPost.postAudioTime forKey:XXSharePostJSONAudioTime];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"content"];
    if (conditionPost.tag) {
        [params setObject:conditionPost.tag forKey:@"tag"];
    }
    [params setObject:[XXUserDataCenter currentLoginUser].schoolId forKey:@"xuexiao_id"];

    //request
    [self requestXXRequest:XXRequestTypePostShare withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"post share result:%@",resultDict);
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];
}

//发表相册
- (void)requestPostTalkWithCondistionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionPost.postContent&&!conditionPost.postType&&!conditionPost.postImages&&!conditionPost.postAudio) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if (![XXUserDataCenter currentLoginUser]) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    //params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *content = [NSMutableDictionary dictionary];
    if (conditionPost.postContent) {
        [content setObject:conditionPost.postContent forKey:XXSharePostJSONContentKey];
    }
    if (conditionPost.postType) {
        [content setObject:[NSNumber numberWithInt:conditionPost.postType] forKey:XXSharePostJSONTypeKey];
    }
    if (conditionPost.postImages) {
        [content setObject:conditionPost.postImages forKey:XXSharePostJSONImageKey];
    }
    if (conditionPost.postAudio) {
        [content setObject:conditionPost.postAudio forKey:XXSharePostJSONAudioKey];
    }
    if (conditionPost.postAudioTime) {
        [content setObject:conditionPost.postAudioTime forKey:XXSharePostJSONAudioTime];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:content options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    [params setObject:jsonString forKey:@"content"];
    if (conditionPost.tag) {
        [params setObject:conditionPost.tag forKey:@"tag"];
    }
    [params setObject:[XXUserDataCenter currentLoginUser].schoolId forKey:@"xuexiao_id"];
    
    //request
    [self requestXXRequest:XXRequestTypePostTalk withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"post talk result:%@",resultDict);
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];

}

//校园搬家
- (void)requestMoveHomeWithDestinationSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionSchool.schoolId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"xuexiao_id":conditionSchool.schoolId};
    [self requestXXRequest:XXRequestTypeMoveHome withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//用户详情
- (void)requestUserDetailWithDetinationUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestDetailUserBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionUser.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"user_id":conditionUser.userId};
    [[XXMainDataCenter shareCenter]requestXXRequest:XXRequestTypeUserDetail withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"user detail :%@",resultDict);
        if (success) {
            XXUserModel *resultUser = [[XXUserModel alloc]initWithContentDict:[resultDict objectForKey:@"user"]];
            success(resultUser);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//射孤独
- (void)requestLonelyShootWithSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    [self requestXXRequest:XXRequestTypeLonelyShoot withParams:nil withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"lonely shoot result:%@",resultDict);
        if (success) {
            NSArray *userList = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [userList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXUserModel *userItem = [[XXUserModel alloc]initWithContentDict:item];
                userItem.isInSchool = @"0";
                userItem.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:userItem];
                [modelArray addObject:userItem];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//校内人
- (void)requestSameSchoolUsersWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.schoolId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    //
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    NSMutableDictionary *getParams = [NSMutableDictionary dictionary];
    
    [getParams setObject:condition.pageIndex forKey:@"page"];
    [getParams setObject:condition.pageSize forKey:@"size"];
    
    [postParams setObject:condition.schoolId forKey:@"xuexiao_id"];
    if (![condition.sex isEqualToString:@""]&&condition.sex!=nil) {
        [postParams setObject:condition.sex forKey:@"sex"];
    }
    if (![condition.grade isEqualToString:@""]&&condition.grade!=nil) {
        [postParams setObject:condition.grade forKey:@"grade"];
    }
    if (![condition.userWellKnowRank isEqualToString:@""]&&condition.userWellKnowRank!=nil) {
        [getParams setObject:@"wellkonw" forKey:@"by"];
    }
    if (![condition.userScoreRank isEqualToString:@""]&&condition.userScoreRank!=nil) {
        [getParams setObject:@"score" forKey:@"by"];
    }
    
    DDLogVerbose(@"in school search get params:%@",getParams);
    DDLogVerbose(@"in school search post params:%@",postParams);

    [self requestXXRequest:XXRequestTypeSameSchoolUsers withPostParams:postParams withGetParams:getParams withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"same school result :%@",resultDict);
        if (success) {
            NSArray *resultArray = [[resultDict objectForKey:@"data"]objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *userItem = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:userItem];
                //暂时取代，接口目前没有返回学校名字
                newUser.isInSchool = @"1";
                DDLogVerbose(@"user profile:%@",newUser.signature);
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
//            DDLogVerbose(@"model same school:%@",modelArray);
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//挑逗
- (void)requestTeaseUserWithCondtionTease:(XXTeaseModel *)conditionTease withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionTease.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    if(!conditionTease.postEmoji){
        if(faild){
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:conditionTease.userId forKey:@"user_id"];
    //conent
    NSMutableDictionary *contentParam = [NSMutableDictionary dictionary];
    [contentParam setObject:conditionTease.postEmoji forKey:XXTeasePostJSONEmojiKey];
    NSData *paramData = [NSJSONSerialization dataWithJSONObject:contentParam options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramContentStrng = [[NSString alloc]initWithData:paramData encoding:NSUTF8StringEncoding];
    [params setObject:conditionTease.postEmoji forKey:@"content"];

    [self requestXXRequest:XXRequestTypeTeaseUser withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if(success){
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if(faild){
            faild(faildMsg);
        }
    }];
}

//挑逗我的列表
- (void)requestTeaseMeListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    //param
    NSMutableDictionary *getParams = [NSMutableDictionary dictionary];
    [getParams setObject:condition.pageIndex forKey:@"page"];
    [getParams setObject:condition.pageSize forKey:@"size"];
    
    NSMutableDictionary *postParams = [NSMutableDictionary dictionary];
    [postParams setObject:condition.userId forKey:@"user_id"];
    
    [self requestXXRequest:XXRequestTypeTeaseMeList withPostParams:postParams withGetParams:getParams withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"tease me list :%@",resultDict);
        if (success) {
            NSArray *resultArray = [[resultDict objectForKey:@"data"]objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *teaseItem = (NSDictionary*)obj;
                XXTeaseModel *newTease = [[XXTeaseModel alloc]initWithContentDict:teaseItem];
                [modelArray addObject:newTease];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//附近的人
- (void)requestNearbyUserWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!conditionUser.latitude||!conditionUser.longtitude) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"lat":conditionUser.latitude,@"lng":conditionUser.longtitude};
    [self requestXXRequest:XXRequestTypeNearbyUsers withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"nearby success :%@",resultDict);
        if (success) {
            NSArray *resultArray = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *userItem = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:userItem];
                newUser.isInSchool = @"0";
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
            success(modelArray);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//建议反馈
- (void)requestAdvicePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.content) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"content":condition.content};
    [self requestXXRequest:XXRequestTypeAdvicePublish withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
    
}

//回复我的列表
- (void)requestReplyMeListWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.pageIndex || !condition.pageSize || !condition.desc) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSDictionary *params = @{@"page":condition.pageSize,@"size":condition.pageSize,@"desc":condition.desc};
    [self requestXXRequest:XXRequestTypeReplyMeList withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            
            DDLogVerbose(@"%@",resultDict);
            NSDictionary *dataDict = [resultDict objectForKey:@"data"];
            NSArray *tableData = [dataDict objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [tableData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                XXCommentModel *commentModel = [[XXCommentModel alloc]initWithContentDict:obj];
                commentModel.grade = commentModel.schoolName;
                commentModel.schoolName = commentModel.postContent;
                commentModel.toUserName = [[obj objectForKey:@"user"]objectForKey:@"nickname"];
                XXSharePostUserStyle *style = [[XXSharePostUserStyle alloc]init];
                style.nameDes.fontSize = 12.5;
                style.nameDes.fontWeight = XXFontWeightNormal;
                commentModel.schoolName = [XXBaseTextView switchEmojiTextWithSourceText:commentModel.schoolName];
                commentModel.userHeadContent = [XXSharePostUserView useHeadAttributedStringWithCommnetModelForMessageList:commentModel withShareUserPostStyle:style];
                [modelArray addObject:commentModel];
            }];
            success(modelArray);
            
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }

    }];
}

//更新学校数据库
- (void)updateSchoolDatabaseWithSuccess:(XXDataCenterRequestSchoolDataBaseUpdateSuccessBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults]objectForKey:XXCacheCenterSchoolVersionUDF];
    if (!currentVersion) {
        currentVersion = XXCacheCenterSchoolDefaultVersion;
    }
    NSDictionary *params = @{@"version":currentVersion};
    
    [self requestXXRequest:XXRequestTypeUpdateSchoolDatabase withParams:params  withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        DDLogVerbose(@"check school database version result:%@",resultDict);
        if (success) {
            NSString *newVersion = [resultDict objectForKey:@"version"];
            success([resultDict objectForKey:@"link"],newVersion);
        }
    } withFaild:^(NSString *faildMsg) {
        DDLogVerbose(@"check school database version faild:%@",faildMsg);
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//
- (void)requestCareUserFansListWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
        }
        return;
    }
    
    NSDictionary *params = @{@"user_id":condition.userId};
    [self requestXXRequest:XXRequestTypeCareUserFansList withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            
            
            DDLogVerbose(@"fans list:%@",[resultDict objectForKey:@"data"]);
            
            NSArray *resultArray = [resultDict objectForKey:@"data"];
            
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *userItem = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:userItem];
                DDLogVerbose(@"user profile:%@",newUser.signature);
                newUser.isInSchool = @"0";
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
            DDLogVerbose(@"model same school:%@",modelArray);
            success(modelArray);
        }
        
    } withFaild:^(NSString *faildMsg) {
       
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//取消追捧
- (void)requestCancelPraiseWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.resId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"praise_id":condition.resId};
    [self requestXXRequest:XXRequestTypeCancelPraise withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
        
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//删除帖子
- (void)requestDeletePostWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.postId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"posts_id":condition.postId};
    [self requestXXRequest:XXRequestTypeDeletePost withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//删除挑逗
- (void)requestDeleteTeaseWithTeaseModel:(XXTeaseModel *)tease withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!tease.teaseId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"tease_id":tease.teaseId};
    [self requestXXRequest:XXRequestTypeDeleteTease withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
    
}

//访客列表
- (void)requestVisitRecordListWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"user_id":condition.userId};
    [self requestXXRequest:XXRequestTypeVisitMySpaceUserList withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            
            DDLogVerbose(@"peer user list:%@",resultDict);
            NSArray *resultArray = [resultDict objectForKey:@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *userItem = (NSDictionary*)obj;
                XXUserModel *newUser = [[XXUserModel alloc]initWithContentDict:userItem];
                DDLogVerbose(@"user profile:%@",newUser.signature);
                newUser.isInSchool = @"0";
                newUser.attributedContent = [XXUserInfoBaseCell buildAttributedStringWithUserModel:newUser];
                [modelArray addObject:newUser];
            }];
            DDLogVerbose(@"model same school:%@",modelArray);
            success(modelArray);
        }

    } withFaild:^(NSString *faildMsg) {
        
        if (faild) {
            faild(faildMsg);
        }
        
    }];
    
}

//访问空间
- (void)requestVisitUserHomeWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.userId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }

    NSDictionary *params = @{@"user_id":condition.userId};
    [self requestXXRequest:XXRequestTypeVisitUserHome withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];

}

//追捧列表
- (void)requestPraiseListWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.postId || !condition.resType) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    
    NSDictionary *params = @{@"page":condition.pageIndex,@"size":condition.pageSize};
    NSDictionary *postParams = @{@"res_id":condition.postId,@"res_type":condition.resType};
    
    [self requestXXRequest:XXRequestTypePraiseList withPostParams:postParams withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            
            DDLogVerbose(@"resultDict praise list:%@",resultDict);
            NSArray *resultArray = [[resultDict objectForKey:@"table"]objectForKey:@"table"];
            NSMutableArray *modelArray = [NSMutableArray array];
            [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSDictionary *item = (NSDictionary*)obj;
                XXPraiseModel *praiseModel = [[XXPraiseModel alloc]initWithContentDict:item];
                [modelArray addObject:praiseModel];
            }];
            DDLogVerbose(@"model same school:%@",modelArray);
            success(modelArray);
        }

    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//获取新的提醒
- (void)requestGetRemindNewCountWithSuccess:(XXDataCenterRequestDetailUserBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    [self requestXXRequest:XXRequestTypeGetRemindNewCount withParams:nil withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        
        if (success) {
            
            DDLogVerbose(@"get remind new :%@",resultDict);
            NSDictionary *data = [resultDict objectForKey:@"data"];
            XXUserModel *newUser = [[XXUserModel alloc]init];
            newUser.friendHasNewShareCount = [data objectForKey:@"friends_news"];
            newUser.commentNewCount = [data objectForKey:@"comment"];
            newUser.visitUserNewCount = [data objectForKey:@"new_audiences"];
            newUser.teaseNewCount = [data objectForKey:@"tease"];
            
            success(newUser);
        }
        
    } withFaild:^(NSString *faildMsg) {
       
        if (faild) {
            faild(faildMsg);
        }
        
    }];
}
- (void)requestIKnowNewRemindWithCondition:(XXConditionModel *)condition WithSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!condition.type) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
        }
        return;
    }
    NSDictionary *params = @{@"types":condition.type};
    [self requestXXRequest:XXRequestTypeIKnowRemindNow withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
    
}

//同步经纬度
- (void)requestSyncLocationWithCondition:(XXConditionModel *)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (condition.longtitude == 0.f || condition.latitude == 0.f) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
            return;
        }
    }
    NSNumber *longtitued = [NSNumber numberWithLong:condition.longtitude];
    NSNumber *latitued = [NSNumber numberWithLong:condition.latitude];
    
    NSDictionary *params = @{@"lng":longtitued,@"lat":latitued};
    [self requestXXRequest:XXRequestTypeSyncLocation withParams:params withHttpMethod:@"POST" withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//删除评论
- (void)requestDeleteCommentWithComment:(XXCommentModel *)comment withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    if (!comment.commentId) {
        if (faild) {
            faild(XXLoginErrorInvalidateParam);
        }
        return;
    }
    NSDictionary *params = @{@"comment_id":comment.commentId};
    [self requestXXRequest:XXRequestTypeDeleteComment withPostParams:nil withGetParams:params withSuccess:^(NSDictionary *resultDict) {
        if (success) {
            success([resultDict objectForKey:@"msg"]);
        }
    } withFaild:^(NSString *faildMsg) {
        if (faild) {
            faild(faildMsg);
        }
    }];
}

//下载文件
- (void)downloadFileWithLinkPath:(NSString *)linkPath WithDestSavePath:(NSString *)savePath withSuccess:(XXDataCenterRequestSuccessMsgBlock)sucess withFaild:(XXDataCenterRequestFaildMsgBlock)faild
{
    //是否存在网络
    [self checkNetWorkWithFaildBlck:faild];
    
    NSString *downloadUrl = [NSString stringWithFormat:@"%@%@",XXBase_Host_Url,linkPath];
    DDLogVerbose(@"download arm:%@",downloadUrl);
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
    
    AFHTTPRequestOperation *downloadOperation = [[AFHTTPRequestOperation alloc]initWithRequest:downloadRequest];
    __weak typeof(AFHTTPRequestOperation*)selfDownloadOperation = downloadOperation;
    [downloadOperation setCompletionBlock:^{
        
        NSData *downloadFileData = selfDownloadOperation.responseData;
        DDLogVerbose(@"downloadFileData length :%d",downloadFileData.length);
        BOOL saveZipFileResult =  [downloadFileData writeToFile:savePath atomically:YES];
        DDLogVerbose(@"save zip file result:%d",saveZipFileResult);
        if (sucess) {
            sucess(linkPath);
        }
        DDLogVerbose(@"download complete!");
    }];
    [[XXHTTPClient shareClient] enqueueHTTPRequestOperation:downloadOperation];
}

- (void)cancelAllUploadRequest
{
    [[XXHTTPClient shareClient]cancelAllHTTPOperationsWithMethod:@"POST" path:[XXDataCenterConst switchRequestTypeToInterfaceUrl:XXRequestTypeUploadFile]];
}

@end
