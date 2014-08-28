//
//  XXMainDataCenter.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-16.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XXDataCenterRequestSuccessListBlock) (NSArray *resultList);
typedef void (^XXDataCenterRequestFaildMsgBlock) (NSString *faildMsg);
typedef void (^XXDataCenterRequestSuccessMsgBlock) (NSString *successMsg);
typedef void (^XXDataCenterRequestDetailUserBlock) (XXUserModel *detailUser);
typedef void (^XXDataCenterUploadFileProgressBlock) (CGFloat progressValue);
typedef void (^XXDataCenterUploadFileSuccessBlock) (XXAttachmentModel *resultModel);
typedef void (^XXDataCenterCommentDetailBlock)  (XXCommentModel *resultModel);
typedef void (^XXDataCenterRequestSchoolDataBaseUpdateSuccessBlock) (NSString *newDataBaseUrl,NSString *newVersion);

@interface XXMainDataCenter : NSObject
+ (XXMainDataCenter*)shareCenter;

//上传文件
- (void)uploadFileWithData:(NSData*)fileData withFileName:(NSString*)fileName withUploadProgressBlock:(XXDataCenterUploadFileProgressBlock)uploadProgressBlock withSuccessBlock:(XXDataCenterUploadFileSuccessBlock)success withFaildBlock:(XXDataCenterRequestFaildMsgBlock)faild;

//登录
- (void)requestLoginWithNewUser:(XXUserModel*)newUser withSuccessLogin:(XXDataCenterRequestDetailUserBlock)success withFaildLogin:(XXDataCenterRequestFaildMsgBlock)faild;

//注册
- (void)requestRegistWithNewUser:(XXUserModel*)newUser withSuccessRegist:(XXDataCenterRequestDetailUserBlock)success withFaildRegist:(XXDataCenterRequestFaildMsgBlock)faild;

//搜索学校
- (void)requestSearchSchoolListWithDescription:(XXSchoolModel*)conditionSchool WithSuccessSearch:(XXDataCenterRequestSuccessListBlock)success withFaildSearch:(XXDataCenterRequestFaildMsgBlock)faild;

//潜伏学校
- (void)requestStrollSchoolWithConditionSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//更新用户资料
- (void)requestUpdateUserInfoWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//附件详情
- (void)requestAttachmentDetailWithConditionAttachment:(XXAttachmentModel*)conditionAttachment withSuccess:(XXDataCenterUploadFileSuccessBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//添加好友关心
- (void)requestAddFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//取消好友关心
- (void)requestCancelFriendCareWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//我关心的列表搜索
- (void)requestMyCareFriendWithConditionFriend:(XXConditionModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//关心我的列表搜索
- (void)requestCareMeFriendWithConditionFriend:(XXUserModel*)conditionFriend withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//发表评论
- (void)requestPublishCommentWithConditionComment:(XXCommentModel*)conditionComment withSuccess:(XXDataCenterCommentDetailBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//评论列表
- (void)requestCommentListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//追捧
- (void)requestPraisePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//分享列表
- (void)requestSharePostListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//发表分享
- (void)requestPostShareWithConditionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//发表相册
- (void)requestPostTalkWithCondistionSharePost:(XXSharePostModel*)conditionPost withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//校园搬家
- (void)requestMoveHomeWithDestinationSchool:(XXSchoolModel*)conditionSchool withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//用户详情
- (void)requestUserDetailWithDetinationUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestDetailUserBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//射孤独
- (void)requestLonelyShootWithSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//校内人
- (void)requestSameSchoolUsersWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//挑逗
- (void)requestTeaseUserWithCondtionTease:(XXTeaseModel*)conditionTease withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//挑逗我的列表
- (void)requestTeaseMeListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//附近的人
- (void)requestNearbyUserWithConditionUser:(XXUserModel*)conditionUser withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//建议反馈
- (void)requestAdvicePublishWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//回复我的列表
- (void)requestReplyMeListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//更新学校数据库
- (void)updateSchoolDatabaseWithSuccess:(XXDataCenterRequestSchoolDataBaseUpdateSuccessBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//取消追捧
- (void)requestCancelPraiseWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//删除帖子
- (void)requestDeletePostWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//删除挑逗
- (void)requestDeleteTeaseWithTeaseModel:(XXTeaseModel*)tease withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//下载文件
- (void)downloadFileWithLinkPath:(NSString*)linkPath WithDestSavePath:(NSString*)savePath withSuccess:(XXDataCenterRequestSuccessMsgBlock)sucess withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//关心他的列表
- (void)requestCareUserFansListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//访客列表
- (void)requestVisitRecordListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//访问空间
- (void)requestVisitUserHomeWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//获取新的提醒
- (void)requestGetRemindNewCountWithSuccess:(XXDataCenterRequestDetailUserBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//告知已经读取提醒
- (void)requestIKnowNewRemindWithCondition:(XXConditionModel*)condition WithSuccess:(XXDataCenterRequestSuccessMsgBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//追捧列表
- (void)requestPraiseListWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//同步经纬度
- (void)requestSyncLocationWithCondition:(XXConditionModel*)condition withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;

//删除评论
- (void)requestDeleteCommentWithComment:(XXCommentModel*)comment withSuccess:(XXDataCenterRequestSuccessListBlock)success withFaild:(XXDataCenterRequestFaildMsgBlock)faild;


//退出上传请求
- (void)cancelAllUploadRequest;

@end
