//
//  XXDataCenterConst.h
//  XiaoXiao
//
//  Created by ZYVincent on 13-12-19.
//  Copyright (c) 2013年 ZYProSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    XXRequestTypeLogin = 0,
    XXRequestTypeRegist,
    XXRequestTypeSearchSchool,
    XXRequestTypeUploadFile,
    XXRequestTypeStrollSchool,
    XXRequestTypeUpdateUserInfo,
    XXRequestTypeFileDetail,
    XXRequestTypeAddFriendCare,
    XXRequestTypeCancelFriendCare,
    XXRequestTypeMyCareFriend,
    XXRequestTypeCareMe,
    XXRequestTypeCommentPublish,
    XXRequestTypePraisePublish,
    XXRequestTypeCommentList,
    XXRequestTypeSharePostSearch,
    XXRequestTypePostShare,
    XXRequestTypePostTalk,
    XXRequestTypeMoveHome,
    XXRequestTypeUserDetail,
    XXRequestTypeLonelyShoot,
    XXRequestTypeSameSchoolUsers,
    XXRequestTypeTeaseUser,
    XXRequestTypeTeaseMeList,
    XXRequestTypeNearbyUsers,
    XXRequestTypeAdvicePublish,
    XXRequestTypeReplyMeList,
    XXRequestTypeUpdateSchoolDatabase,
    XXRequestTypeCancelPraise,
    XXRequestTypeDeletePost,
    XXRequestTypeCareUserFansList,
    XXRequestTypeDeleteTease,
    XXRequestTypeVisitMySpaceUserList,
    XXRequestTypeVisitUserHome,
    XXRequestTypePraiseList,
    XXRequestTypeGetRemindNewCount,
    XXRequestTypeIKnowRemindNow,
    XXRequestTypeSyncLocation,
    XXRequestTypeDeleteComment,
    
}XXRequestType;

#define XXBase_Host_Url @"http://api.quan-oo.com"

//登陆
/*
 POST account:注册账号
 POST password:注册密码
 */
#define XX_Login_Interface @"api/passport/login"

//注册
/*
 POST account:注册账号,如果账号是邮箱,就填邮箱
 POST password:注册密码
 POST xuexiao_id:选择学校ID
 POST grade:年级字符传
 FILE picture:照片上传资源,jpg 格式
 */
#define XX_Regist_Interface @"/api/passport/register"

//学校搜索，最多30条
/*
 可选 POST keyword:关键词
 可选 POST type:0大学,1中学
 可选 POST province:省份名
 可选 POST city:城市名
 可选 POST area:区县名
 */
#define XX_Search_School_Interface @"/api/xuexiao/search"

//编辑更新个人资料
/*
 可选 POST account:注册账号
 可选 POST password:注册密码
 可选 POST nickname:昵称
 可选 POST email:邮箱
 可选 POST grade:班级
 可选 POST sex:性别
 可选 POST birthday:生日
 可选 POST signature:签名
 可选 FILE picture:照片
 */
#define XX_Update_User_Info_Interface @"/api/users/upinfo"

//潜伏学校
/*
 POST xuexiao_id:学校ID
 */
#define XX_Stroll_School_Interface @"/api/xuexiao/stroll/"

//上传附件
/*
 FILE upload:上传任意资源资源
 可选 POST description:附件描述
 */
#define XX_Upload_File_Interface @"/api/attachment/upload"

//附件详情
/*
 POST attachment_id:附件ID
 */
#define XX_File_Detail_Interface @"/api/attachment/details"

//添加好友关心
/*
 POST user_id:用户ID
 */
#define XX_Add_Friend_Care_Interface @"/api/friends/add"

//取消好友关心
/*
 POST user_id:用户ID
 */
#define XX_Cancel_Friend_Care_Interface @"/api/friends/del"

//我关心的列表搜索
/*
 可选 POST keyword:好友的账号/昵称
 */
#define XX_My_Care_Friend_Search_Interface @"/api/friends/search"

//关心我的列表搜索
/*
 可选 POST keyword:好友的账号/昵称
 */
#define XX_Search_Care_Me_Interface @"/api/friends/search2"

//关心他的列表
/*
 关心他的列表
 */
#define XX_Care_User_Fans_List_Interface @"/api/friends/search3"

//发表评论
/*
 POST
 res_type:评论资源类型（posts目前就这1个值）
 res_id:资源ID
 content:评论内容自定义结构体
 p_id:回复ID（可选）
 root_id:回复跟ID（可选，就是回复时，如果有这个ID就设置当前ID，如果没有就是恢复的ID）
 */
#define XX_Comment_Publish_Interface @"/api/comment/publish"

//评论列表
/*
 GET	page :评论页码
 GET	size:评论每页条数
 POST	user_id:用户ID（可选）
 POST	res_id:资源ID
 POST	res_type:资源类型
 POST	p_id:父ID
 POST	root_id:回复ID
 */
#define XX_Comment_List_Interface @"/api/comment/search"

//评论
/*
 POST	res_id:资源ID
 POST	res_type:资源类型
 */
#define XX_Comment_Count_Interface @"/api/comment/count"

//去追捧
/*
 POST	res_type:评论资源类型
 POST	res_id:资源ID
 */
#define XX_Praise_Publish_Interface @"/api/praise/publish"

//统计追捧数量
/*
 POST	res_id:资源ID
 POST	res_type:资源类型
 */
#define XX_Praise_Count_Interface @"/api/praise/count"

//帖子列表
/*
 GET	page:页码（可选）
 GET	size:每页条数（可选）
 POST	user_id:发表者ID（可选）
 POST	sex:发表者性别（0男1女）
 POST	grade:发表者年级（可选)
 POST	xuexiao_id:学校ID（可选）
 POST	type:类型（可选0相册,1共享）
 POST	tag:自定义标签（可选）
 */
#define XX_Share_Post_Search_Interface @"/api/posts/search"

//发表共享
/*
 POST	content:内容自定一结构提
 POST	xuexiao_id:指定学校ID（默认登录用户的生活校园ID）
 POST	tag:自定义标签（可选）
 */
#define XX_Post_Share_Interface @"/api/posts/share"

//发表相册
/*
 POST	content:内容自定一结构提
 POST	xuexiao_id:指定学校ID（默认登录用户的生活校园ID）
 POST	tag:自定义标签（可选）
 */
#define XX_Post_Talk_Interface @"/api/posts/talk"


//校园搬家
/*
 POST	xuexiao_id:校园搬家的校园ID
 */
#define XX_Move_Home_Interface @"/api/users/move"


//用户详情
/*
 POST	user_id:用户ID
 */
#define XX_User_Detail_Interface @"/api/users/details"


//射孤独
/*
 */
#define XX_Lonely_Shoot_Interface @"/api/lonely/shoot"

//校内人
/*
 GET	page:		页码(默认1)
 GET	size:		每页条数（默认30）
 POST	xuexiao_id:		学校ID
 POST	sex:     发表者性别（可选0男1女）
 POST	grade:		发表者年级（可选）
 */
#define XX_Same_School_User_Interface @"/api/xuexiao/users"

//挑逗
/*
 POST	user_id		被挑逗用户的ID
 POST	content		自定义结构体
 */
#define XX_Tease_User_Interface @"/api/tease/user"

//挑逗列表
/*
 POST	user_id		用户ID
 */
#define XX_Tease_Me_List_Interface @"/api/tease/lists"

//附近的人
/*
 POST	lat		经度
 POST	lng		纬度
 */
#define XX_Nearby_User_Interface @"/api/users/near"

//意见反馈
/*
 POST	content		建议内容
 */
#define XX_Advice_Interface @"/api/proposal/publish"

//回复我的列表
/*
 GET	page		评论页码
 GET	size		评论每页条数
 POST	res_id		资源ID(可选)
 POST	res_type		资源类型(可选)
 POST	p_id		父ID(可选)
 POST	root_id		回复ID(可选)
 */
#define XX_Reply_Me_List_Interface @"/api/comment/replyme"

//学校数据库更新
#define XX_School_Update_Interface @"/api/update/xuexiao"

//取用户头像地址
#define XX_Head_Url_Base_Url @"/api/picture"

//图片大小图获取接口
#define XX_Image_Resize_Url @"/api/preview"

//取消追捧
#define XX_Cancel_Praise_Interface @"/api/praise/cancel"

//删除帖子
#define XX_Delete_Post_Interface @"/api/posts/del"

//删除挑逗
#define XX_Delete_Tease_Interface @"/api/tease/del"

//访客
#define XX_Visit_Record_Interface @"/api/statistics/visitRecord"

//拜访空间
#define XX_Visit_User_Home_Interface @"/api/statistics/visit"

//追捧列表
#define XX_Praise_List_Interface @"/api/praise/lists"

//获取提醒数据
#define XX_Get_Remind_Count_Interface @"/api/remind/get"

//告知已读提醒
#define XX_Tell_Me_Has_Read_Remind_Interface @"/api/remind/know"

//同步经纬度
#define XX_Sync_Location_Interface @"/api/sync/coord"

//删除评论
#define XX_Delete_Comment_Interface @"/api/comment/del"



@interface XXDataCenterConst : NSObject

+ (NSString*)switchRequestTypeToInterfaceUrl:(XXRequestType)requestType;

@end
