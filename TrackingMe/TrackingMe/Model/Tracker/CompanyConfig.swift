//
//  CompanyConfig.swift
//  TrakingMe
//
//  Created by Thành Lã on 1/6/17.
//  Copyright © 2017 Bình Anh Electonics. All rights reserved.
//

import Foundation
open class CompanyConfiguration {
    
    // Lay thong tin Cameras server
    open var CameraImageServer                         = ""
    
    // Co su dung su lieu online tu Memory khong
    open var EnableUseOnlineFromServicesWCF            = false
    
    // Co update thoi gian dung do khi xe dung do ko (vi hien tai 2 phut moi gui 1 ban tin)
    open var EnableUpdateVehicleOnlineStopTime         = false
    
    // Co vo hieu thong tin BGT tren khung hien trang khong
    open var DisableDiplayBGTInfo                      = false
    
    // Thoi gian mat tin hieu
    open var DefaultTimeLossConnect                    = 150
    
    // Thoi gian mat GPS
    open var DefaultMinTimeLossGPS                     = 5
    
    // Thời gian mất GPS tối đa
    open var DefaultMaxTimeLossGPS                     = 150
    
    // Số phút GSM vẫn trong tình trạng bình thường
    open var DefaultTimeGMSNormal                      = 2
    
    // Range vận tốc mà icon màu xám
    open var DefaultMaxVelocityGray                    = 5
    
    // Range vận tốc mà icon màu xanh
    open var DefaultMaxVelocityBlue                    = 5
    
    // Range vận tốc mà icon màu cam
    open var DefaultMaxVelocityOrange                  = 100
    
    // Range vận tốc mà icon màu đỏ
    open var DefaultMaxVelocityRed                     = 500
    
    // So phut dung do lau
    open var EnableIconStopLongTime                    = false
    
    // Công ty có sử dụng hiển thị kinh độ, vĩ độ ở trang online không
    open var EnableDisplayLatLng                       = false
    
    // Co hien thi thong tin kmGPS hay khong
    open var EnableDisplayKmGPS                        = true
    
    // Có cập nhật km tích lũy trên online không
    open var EnableTotalKmTotaKmAccumulation           = false
    
    // Có sử dụng hiển thị trạng thái cửa ở trang online không
    open var EnableDisplayDoorStatus                   = false
    
    // Công ty có sử dụng panto theo vùng không
    open var UseRegionPanto                            = false
    
    // Công ty có sử dụng cảnh báo quá tốc độ trên online không
    open var EnableShowWarning                         = false
    
    // Thời gian refresh lại cảnh báo quá tốc độ
    open var RefreshTimeWarning                        = 5
    
    // Cấu hình hiển thị trạng thái dây máy in
    open var EnablePrinterLine                         = false
    
    // Có cập nhật km tích lũy trên online từ Mem không
    open var EnableTotalKmTotaKmAccumulationFromWCFMem = false
    
    
    open static var instance = CompanyConfiguration()
    
    open func resetToDefaultValues() {
        CompanyConfiguration.instance = CompanyConfiguration()
    }
}
