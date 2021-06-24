//
//  Record.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/13.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var idnetifier: ObjectId = ObjectId.generate()
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var filePath: String = ""
    @objc dynamic var interval: TimeInterval = 0
    @objc dynamic var isFavorite: Bool = false

    let item: LinkingObjects = LinkingObjects(fromType: Item.self, property: "records")

    convenience init(filePath: String, interval: TimeInterval) {
        self.init()
        self.filePath = filePath
        self.interval = interval
    }
}
