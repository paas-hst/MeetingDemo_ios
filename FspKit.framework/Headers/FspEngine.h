
#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import <FspKit/FspCommon.h>
#import <FspKit/FspSignaling.h>

//官方保留的videoid,代表特定类型的广播，广播时不能取这些值
/**
 * @brief 屏幕共享
 */
extern NSString * _Nonnull const FSP_RESERVED_VIDEOID_SCREENSHARE;


/**
 * 视频显示缩放模式
 */
typedef NS_ENUM(NSInteger, FspRemoteVideoOperate) {
    FSP_REMOTE_VIDEO_OPEN = 0, ///<打开远端视频
    FSP_REMOTE_VIDEO_CLOSE = 1  ///<关闭远端视频
};


/**
 * 视频显示缩放模式
 */
typedef NS_ENUM(NSInteger, FspRenderMode) {
    FSP_RENDERMODE_SCALE_FILL = 1, ///<缩放平铺
    FSP_RENDERMODE_CROP_FILL = 2,  ///<等比裁剪显示
    FSP_RENDERMODE_FIT_CENTER = 3 ///<等比居中显示
};


/**
 * @brief 视频设备信息
 */
@interface FspVideoDeviceInfo : NSObject
@property (assign, nonatomic) NSInteger cameraId; ///<摄像头id
@property (copy, nonatomic) NSString* _Nullable deviceName; ///<设备名
@end


/**
 * 视频统计信息
 */
@interface FspVideoStatsInfo : NSObject
@property (assign, nonatomic) NSInteger width; ///<视频宽,像素
@property (assign, nonatomic) NSInteger height; ///<视频高，像素
@property (assign, nonatomic) NSInteger framerate; ///<帧率
@property (assign, nonatomic) NSInteger bitrate; ///<码率
@end


/**
 * 本地视频profile信息
 */
@interface FspVideoProfile : NSObject
@property (assign, nonatomic) NSInteger width; ///<视频宽,像素
@property (assign, nonatomic) NSInteger height; ///<视频高，像素
@property (assign, nonatomic) NSInteger framerate; ///<帧率


/**
 * 通过width, height, framerate构造profile
 */
+ (FspVideoProfile* _Nullable)profileWith:(NSInteger)width height:(NSInteger)height framerate:(NSInteger)framerate;
@end


/**
 * fspEvent事件类型
 */
typedef NS_ENUM(NSInteger, FspEventType) {
    FSP_EVENT_JOINGROUP = 0,          ///<加入组结果
    FSP_EVENT_CONNECT_LOST = 1,       ///<与fsp服务的连接断开，应用层需要去重新加入组
    FSP_EVENT_RECONNECT_START = 2,    ///<网络断开过，开始重连
    FSP_EVENT_LOGIN_RESULT = 3        ///<登录结果
};


/**
 * 远端视频事件类型
 */
typedef NS_ENUM(NSInteger, FspRemoteVideoEventType) {
    FSP_REMOTE_VIDEO_PUBLISH_STARTED = 0, ///<远端广播了视频
    FSP_REMOTE_VIDEO_PUBLISH_STOPED = 1, ///<远端停止广播视频
    FSP_REMOTE_VIDEO_FIRST_RENDERED = 2  ///<远端视频加载完成第一帧渲染
};


/**
 * 远端音频事件类型
 */
typedef NS_ENUM(NSInteger, FspRemoteAudioEventType) {
    FSP_REMOTE_AUDIO_PUBLISH_STARTED = 0, ///<远端广播了音频
    FSP_REMOTE_AUDIO_PUBLISH_STOPED = 1 ///<远端停止广播音频
};


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

/**
 *@brief 登入
 *@param nToken 访问fsp的令牌，令牌的获取参考fsp鉴权
 *@param nUserId 自身的userId
 *@return 结果错误码
 */
- (FspErrCode)login:(NSString * _Nonnull)nToken userId:(NSString * _Nonnull)nUserId;

/**
 *@brief 登出
 *@return 结果错误码
 */
- (FspErrCode)loginOut;

/**
 *@param nGroupId 加入组的group Id
 *@return  结果错误码
 */
- (FspErrCode)joinGroup:(NSString *_Nonnull)nGroupId;

/**
 * @brief 退出组
 */
- (FspErrCode)leaveGroup;

/**
 *@brief 销毁
 */
- (FspErrCode)destoryFsp;


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
