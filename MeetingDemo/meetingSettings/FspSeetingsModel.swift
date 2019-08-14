//
//  FspSeetingsModel.swift
//  FspNewDemo
//
//  Created by admin on 2019/3/28.
//  Copyright © 2019年 hst. All rights reserved.
//

import UIKit
import AVFoundation

enum Codec_Type {
    case Codec_Type_Soft
    case Codec_Type_HD
}

enum Preset_Type {
    case Preset_Type_352x288
    case Preset_Type_640x288
    case Preset_Type_960x288
    case Preset_Type_1280x288
    case Preset_Type_1080x288
}

let fspSeetingManager = FspSeetingsModel()
class FspSeetingsModel: NSObject {
    //分辨率
    lazy var preset: AVCaptureSession.Preset = {
        let preset = AVCaptureSession.Preset.cif352x288
        return preset
    }()
    //帧率
    lazy var fps: Int = {
        let fps = 15
        return fps
    }()
    
    //码率
    lazy var kbps: Int = {
        let kbps = 500;
        return kbps
    }()
    
    //编码器
    lazy var codec_id: Codec_Type = {
        let codec_id = Codec_Type.Codec_Type_Soft
        return codec_id
    }()
    
    //自动打开摄像头
    lazy var auto_camera: Bool = {
        let auto_camera = false
        return auto_camera
    }()
    
    //自动打开麦克风
    lazy var auto_mic: Bool = {
        let auto_mic = true
        return auto_mic
    }()
    class var sharedInstance: FspSeetingsModel{
        return fspSeetingManager
    }
    
    override init() {
        super.init()
        self.defaultModel()
    }
    
    func defaultModel() -> Void {
        _ = preset
        _ = fps
        _ = kbps
        _ = codec_id
        _ = auto_camera
        _ = auto_mic
    }
}
