//
//  I18N.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/02.
//

import Foundation

enum I18N {
    case title
    case collection
    case newCollection
    case practice
}

extension I18N: CustomStringConvertible {
    var description: String {
        switch self {
        case .title:
            return "title".localized
        case .collection:
            return "collection".localized
        case .newCollection:
            return "newCollection".localized
        case .practice:
            return "practice".localized
        }
    }
}
