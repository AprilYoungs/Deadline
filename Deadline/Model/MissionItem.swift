//
//  MissionItem.swift
//  Deadline
//
//  Created by April Yang on 2020/10/30.
//

import Foundation

struct MissionItem: Codable, Hashable {
    let mission: String
    var date: Date
    func leftTimeStr() ->  String {
        timeLeftTransfer(date: self.date).0
    }
    func exceed() -> Bool {
        timeLeftTransfer(date: self.date).1
    }
    init(mission: String, date: Date) {
        self.mission = mission
        self.date = date
    }

}
