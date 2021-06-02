//
//  String+.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/02.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
