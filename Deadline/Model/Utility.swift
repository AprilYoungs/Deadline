//
//  Utility.swift
//  Deadline
//
//  Created by April Yang on 2020/10/30.
//

import Foundation

func timeLeftTransfer(date: Date) -> (String, Bool) {
    var exceed = false
    var interval = Int(date.timeIntervalSince(Date()))
    if interval < 0 {
        interval = -interval
        exceed = true
    }
    let secs = interval % 60
    let totalMins = (interval - secs) / 60
    let mins = totalMins % 60
    let totalHours = (totalMins - mins) / 60
    let hours = totalHours % 24
    let days = (totalHours - hours) / 24
    
    let timeLeftStr = String(format: "%d day %02d hours %02d mins %02d secs %@", days, hours, mins, secs, exceed ? "Exceed!!" : "")
    
    return (timeLeftStr, exceed)
}
