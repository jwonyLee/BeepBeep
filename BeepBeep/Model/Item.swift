//
//  Item.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/13.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var identifier: ObjectId = ObjectId.generate()
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var interval: TimeInterval = 0
    @objc dynamic var isFavorite: Bool = false

    let category = LinkingObjects(fromType: Category.self, property: "items")
    let records = List<Record>()

    convenience init(title: String, content: String, interval: TimeInterval) {
        self.init()
        self.title = title
        self.content = content
        self.interval = interval
    }
}
