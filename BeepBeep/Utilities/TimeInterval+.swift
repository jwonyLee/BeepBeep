//
//  TimeInterval+.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/08/27.
//

import Foundation

extension TimeInterval {
    var stringTime: String {
        let time: Int = Int(self)
        let seconds: Int = time % 60
        let minutes: Int = (time / 60) % 60
        let hours: Int = (time / 3_600)
        return String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
    }
}
