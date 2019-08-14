
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <FspKit/FspSignaling.h>

/**
 * sdk回调事件和异步结果
 */
@protocol FspEngineDelegate <NSObject>

/**
 * @brief sdk回调事件和异步结果
 */
- (void)fspEvent:(FspEventType)eventType
         errCode:(FspErrCode)errCode;

/**
 * @brief 远端用户视频事件
 *
 * @param userId 远端视频所属的user id
 * @param videoId 远端视频所属的video id
 * @param eventType 事件类型
 */

- (void)remoteVideoEvent:(NSString * _Nonnull)userId
                 videoId:(NSString * _Nonnull)videoId
               eventType:(FspRemoteVideoEventType)eventType;

/**
 * @brief 远端用户音频事件
 * @param userId 远端用户的userid
 * @param eventType 事件类型
 */
- (void)remoteAudioEvent:(NSString* _Nonnull)userId
               eventType:(FspRemoteAudioEventType)eventType;

@end


/**
 * @brief sdk对外核心接口
 */
@interface FspEngine : NSObject <FspSignaling>


/**
 * @brief 初始化FspEngineKit对象
 * @param appId 分配的appid
 * @param logPath 日志目录
 * @param serverAddr 私有化部署的服务地址，一般填空字符串
 * @param delegate 事件回调实现
 * @return FspEngineKit对象
 */
+ (instancetype _Nonnull)sharedEngineWithAppId:(NSString* _Nonnull)appId
                                       logPath:(NSString* _Nullable)logPath
                                    serverAddr:(NSString* _Nullable)serverAddr
                                      delegate:(id<FspEngineDelegate,FspEngineSignalingDelegate,FspEngineMsgDelegate> _Nonnull)delegate;

/**
 * @brief sdk版本信息
 */
+ (NSString* _Nonnull) getVersionInfo;

#pragma mark media device methods

/**
 * @brief 视频设备列表
 */
- (NSArray<FspVideoDeviceInfo*> * _Nonnull)getVideoDevices;

#pragma mark Video common

/**
 * 本地视频增加预览渲染
 * @param render 渲染窗口
 * @return 结果错误码
 */
- (FspErrCode)setVideoPreview:(UIView * _Nonnull)render;

/**
 * 本地视频删除预览渲染
 * @return 结果错误码
 */
- (FspErrCode)stopVideoPreview;

/**
 * 切换前置/后置摄像头
 */
- (FspErrCode)switchCamera;

/**
 * 开始广播视频
 * @return 结果错误码
 */
- (FspErrCode)startPublishVideo;

/**
 * 停止广播视频
 */
- (FspErrCode)stopPublishVideo;

/**
 * 设置本地的视频profile
 * @param profile profile信息
 */
- (FspErrCode) setVideoProfile:(FspVideoProfile* _Nullable)profile;


/**
 * 设置远端用户视频的渲染窗口
 * @param userId 哪个用户
 * @param videoId 哪路视频的video id
 * @param render 渲染窗口
 */
- (FspErrCode)setRemoteVideoRender:(NSString * _Nonnull)userId
                           videoId:(NSString * _Nonnull)videoId
                            render:(UIView * _Nullable)render
                              mode:(FspRenderMode)mode;


/**
 * 获取视频统计信息
 * @param userId 用户id，可以是本地自身的userid
 * @param videoId 视频id, 如果获取本地信息，videoId传空串
 * @return 如果失败，返回nil
 */
- (FspVideoStatsInfo* _Nullable)getVideoStats:(NSString* _Nonnull)userId
                                      videoId:(NSString* _Nullable)videoId;

#pragma mark Audio common
/**
 * 开始广播音频
 */
- (FspErrCode)startPublishAudio;

/**
 * 停止广播音频
 */
- (FspErrCode)stopPublishAudio;

/**
 * 开关远端音频
 * @param userId 远端用户id
 * @param mute YES关闭远端音频，NO打开
 */
- (FspErrCode)muteRemoteAudio:(NSString * _Nonnull)userId
                         mute:(BOOL)mute;

/**
 * 获取远端用户的声音能量值
 * @param userId 对应的远端用户id
 * @return 能量值 范围： 0 - 100
 */
- (NSInteger)getRemoteAudioEnergy:(NSString* _Nonnull)userId;

@end
