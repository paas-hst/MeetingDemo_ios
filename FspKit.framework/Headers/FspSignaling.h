//
//  FspSignaling.h
//  FspKit
//
//  Created by 张涛 on 2019/7/26.
//  Copyright © 2019 hst. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FspKit/FspCommon.h>


/**
 *@brief 用户状态
 */
typedef NS_ENUM(NSUInteger, FspUserStatus) {
    FSP_USER_STATUS_ONLINE,  ///在线
    FSP_USER_STATUS_OFFLINE  ///下线
};

/**
 *@brief 用户信息
 */
@interface FspUserInfo : NSObject
@property (copy, nonatomic) NSString *_Nonnull userId; ///<用户id
@property (assign, nonatomic) FspUserStatus userStatus; ///<用户状态
@end


@protocol FspSignaling <NSObject>


/**
 *@brief 得到当前所有用户
 *@param nUserIds 如果为空数组 则刷新所有人状态，不为空 刷新指定userid的用户状态
 @param nRequestId 当次的请求id
 */
- (FspErrCode)userStatusRefresh:(NSArray <NSString *>*_Nullable)nUserIds requestId:(unsigned int *_Nonnull)nRequestId;

/**
 *@brief 邀请
 *@param nUsersId 邀请与会人员id数组
 *@param nGroupId 会议的组id
 *@param nExtraMsg 额外信息
 *@param nInviteId 邀请事件id
 *@return 结果错误码
 */
- (FspErrCode)inviteUser:(NSArray <NSString *>*_Nullable)nUsersId groupId:(NSString *_Nonnull)nGroupId extraMsg:(NSString *_Nullable)nExtraMsg inviteId:(unsigned int *_Nonnull)nInviteId;

/**
 *@brief 接受邀请
 *@param nInviteUserId 邀请与会人员id数组
 *@param nInviteId 邀请的事件id
 *@return 结果错误码
 */
- (FspErrCode)acceptInvite:(NSString *_Nonnull)nInviteUserId inviteId:(int)nInviteId;

/**
 *@brief 拒绝邀请
 *@param nInviteUserId 邀请与会人员id数组
 *@param nInviteId 邀请的事件id
 *@return 结果错误码
 */
- (FspErrCode)rejectInvite:(NSString *_Nonnull)nInviteUserId inviteId:(int)nInviteId;

/**
 *@brief 发送消息（私聊）
 *@param nUserId 目标用户Id
 *@param nMsg    消息内容
 *@param nMsgId  消息id
 *@return 结果错误码
 */
- (FspErrCode)sendUserMsg:(NSString *_Nonnull)nUserId msg:(NSString *_Nonnull)nMsg msgId:(unsigned int *_Nonnull)nMsgId;

/**
 *@brief 发送消息（群组）
 *@param nMsg    消息内容
 *@param nMsgId  消息id
 *@return 结果错误码
 */
- (FspErrCode)sendGroupMsg:(NSString *_Nonnull)nMsg msgId:(unsigned int *_Nonnull)nMsgId;

/**
 *@brief 发送消息（群组）
 *@param nUserIds  黑名单用户
 *@param nMsg    消息内容
 *@param nMsgId  消息id
 *@return 结果错误码
 */
- (FspErrCode)sendGroupMsgWithBlackList:(NSArray<NSString *> * _Nonnull)nUserIds msg:(NSString *_Nonnull)nMsg msgId:(unsigned int *_Nonnull)nMsgId;

/**
 *@brief 发送消息（群组）
 *@param nUserIds  白名单用户
 *@param nMsg    消息内容
 *@param nMsgId  消息id
 *@return 结果错误码
 */
- (FspErrCode)SendGroupMsgWithWhiteList:(NSArray<NSString *> * _Nonnull)nUserIds msg:(NSString *_Nonnull)nMsg msgId:(unsigned int *_Nonnull)nMsgId;

@end



/**
 * @brief sdk消息业务回调
 */
@protocol FspEngineMsgDelegate <NSObject>

/**
 * @brief 收到远端消息（用户私聊）
 * @param nSrcUserId 远端用户id
 * @param nMsg 消息
 * @param nMsgId  消息事件id
 */
- (void)onReceiveUserMsg:(NSString *_Nonnull)nSrcUserId msg:(NSString *_Nonnull)nMsg msgId:(int)nMsgId;

/**
 * @brief 收到远端消息（群组私聊）
 * @param nSrcUserId 远端用户id
 * @param nMsg 消息
 * @param nMsgId  消息事件id
 */
- (void)onReceiveGroupMsg:(NSString *_Nonnull)nSrcUserId msg:(NSString *_Nonnull)nMsg msgId:(int)nMsgId;

@end


/**
 * @brief sdk信令事件回调
 */
@protocol FspEngineSignalingDelegate <NSObject>
/**
 * @brief 刷新在线列表事件
 * @param errCode 错误码
 * @param nRequestId 请求id 与调用刷新的id成一对一关系
 * @param nUsrInfos 用户信息
 */
- (void)refreshUserStatusFinished:(FspErrCode)errCode requestId:(uint32_t)nRequestId usrInfo:(NSMutableArray<FspUserInfo*>*_Nonnull)nUsrInfos;

/**
 * @brief 收到邀请事件消息
 * @param nInviteUsrId 邀请者的用户id
 * @param nInviteId 邀请事件id
 * @param nGroupId  群组id
 * @param nMsg  信息
 */
- (void)onInviteIncome:(NSString *_Nonnull)nInviteUsrId inviteId:(int)nInviteId groupId:(NSString *_Nonnull)nGroupId msg:(NSString *_Nullable)nMsg;

/**
 * @brief 远端用户已经接受邀请
 * @param nRemoteUserId 远端用户id
 * @param nInviteId  邀请事件id
 */
- (void)onInviteAccepted:(NSString *_Nonnull)nRemoteUserId inviteId:(int)nInviteId;

/**
 * @brief 远端用户已经拒绝接受邀请
 * @param nRemoteUserId 远端用户id
 * @param nInviteId  邀请事件id
 */
- (void)onInviteRejected:(NSString *_Nonnull)nRemoteUserId inviteId:(int)nInviteId;

/**
 * @brief 远端用户加入组
 * @param userId 远端用户id
 */
- (void)onGroupUserJoined:(NSString * _Nonnull)userId;

/**
 * @brief 远端用户离开组
 * @param userId 远端用户id
 */
- (void)onGroupUserLeaved:(NSString * _Nonnull)userId;

/**
 * @brief 组内当前的人员个数（加入组成功后会调用一次）
 * @param user_ids 用户id
 */
- (void)onGroupUsersRefreshed:(NSArray<NSString *> * _Nonnull)user_ids;

/**
 *@brief 通知有用户状态改变
 *@param nNewStatus 改变后的用户状态
 */
- (void) onUserStatusChanged:(NSString *_Nonnull)remoteUserId newStatus:(FspUserStatus)nNewStatus;


@end
