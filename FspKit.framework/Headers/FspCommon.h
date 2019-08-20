//
//  FspCommon.h
//  FspKit
//
//  Created by 张涛 on 2019/7/26.
//  Copyright © 2019 hst. All rights reserved.
//

/**
 * 错误码集合
 */
typedef NS_ENUM(NSInteger, FspErrCode) {
    FSP_ERR_OK = 0, ///<成功
    
    FSP_ERR_INVALID_ARG = 1,      ///<非法参数
    FSP_ERR_NOT_INITED = 2,       ///<未初始化
    FSP_ERR_OUTOF_MEMORY = 3,     ///<内存不足
    FSP_ERR_DEVICE_FAIL = 4,      ///<访问设备失败
    
    FSP_ERR_CONNECT_FAIL = 30,     ///<网络连接失败
    FSP_ERR_NO_GROUP = 31,         ///<没加入组
    FSP_ERR_TOKEN_INVALID = 32,    ///<认证失败
    FSP_ERR_APP_NOT_EXIST = 33,    ///<app不存在，或者app被删除
    FSP_ERR_USERID_CONFLICT = 34,  ///<相同userid已经加入同一个组，无法再加入
    
    FSP_ERR_NO_BALANCE = 70,         ///<账户余额不足
    FSP_ERR_NO_VIDEO_PRIVILEGE = 71, ///<没有视频权限
    FSP_ERR_NO_AUDIO_PRIVILEGE = 72, ///<没有音频权限
    
    FSP_ERR_NO_SCREEN_SHARE = 73,    ///<当前没有屏幕共享
    
    FSP_ERR_RECVING_SCREEN_SHARE = 74,   ///<当前正在接收屏幕共享
    
    FSP_ERR_SERVER_ERROR = 301,        ///服务内部错误
    FSP_ERR_FAIL = 302              ///<操作失败
};

