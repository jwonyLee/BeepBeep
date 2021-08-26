//
//  I18N.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/02.
//

import Foundation

enum I18N: String {
    case title = "title"
    case collection = "collection"
    case newCollection = "newCollection"
    case practice = "practice"
    case newCollectionTitle = "newCollectionTitle"
    case newCollectionNameFieldDescription = "newCollectionNameFieldDescription"
    case newCollectionNameFieldPlaceholder = "newCollectionNameFieldPlaceholder"
    case setting = "setting"
    case confirm = "confirm"
    case modify = "modify"
    case delete = "delete"
    case cancle = "cancle"
    case actionsheetMessage = "selectOption"
    case addItemTitle = "addItemTitle"

    var localized: String {
        self.rawValue.localized
    }
}
