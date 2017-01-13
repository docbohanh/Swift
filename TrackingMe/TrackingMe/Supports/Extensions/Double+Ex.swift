//
//  Double+Ex.swift
//  OneTaxi
//
//  Created by Hoan Pham on 8/8/16.
//  Copyright © 2016 Hoan Pham. All rights reserved.
//

import Foundation
import PHExtensions

extension Double {
    public func toDistanceString(metersAccuracy meters: Bool) -> String {
        if self < 1000 && meters {
            return self.toString(0) + " " + "m"
        } else {
            return (self / 1000).toString(1) + " " + "Km"
        }
    }
    
    public func toRelativePastTime() -> String {
        let deltaTime  = Date().timeIntervalSince1970 - self
        var string = String()
        switch deltaTime {
        case 0..<10:
            string = LocalizedString("time_default_few", comment: "vài") + " " + LocalizedString("time_default_seconds", comment: "giây")
        case 10..<1.minutes:
            string = deltaTime.toString(0) + " " + LocalizedString("time_default_seconds", comment: "giây")
        case 1.minutes..<1.hours:
            string =  (deltaTime / 1.minutes).toString(0) + " " + (deltaTime > 2.minute ?
                LocalizedString("time_default_minutes", comment: "phút") :
                LocalizedString("time_default_minute", comment: "phút"))
        case 1.hours..<1.days:
            string = (deltaTime / 1.hours).toString(0) + " " + (deltaTime > 2.hour ?
                LocalizedString("time_default_hours",comment: "giờ") :
                LocalizedString("time_default_hour", comment: "giờ"))
        case 1.days..<7.days:
            string = (deltaTime / 1.days).toString(0) + " " + (deltaTime > 2.day ?
                LocalizedString("time_default_days", comment: "ngày") :
                LocalizedString("time_default_day", comment: "ngày"))
        case 7.days..<31.days:
            string = (deltaTime / 7.days).toString(0) + " " + (deltaTime > 14.days ?
                LocalizedString("time_default_weeks", comment: "tuần") :
                LocalizedString("time_default_week", comment: "tuần"))
        case 31.days..<1.years:
            string = (deltaTime / 31.days).toString(0) + " " + (deltaTime > 62.days ?
                LocalizedString("time_default_months", comment: "tháng") :
                LocalizedString("time_default_month", comment: "tháng"))
        case 1.year..<100.years:
            string = (deltaTime / 1.years).toString(0) + " " + (deltaTime > 2.hour ?
                LocalizedString("time_default_years", comment: "năm") :
                LocalizedString("time_default_year", comment: "năm"))
        default:
            break
        }
        string += " " + LocalizedString("time_default_before", comment: "trước")
        return string
    }
}
