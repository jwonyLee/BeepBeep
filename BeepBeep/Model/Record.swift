//
//  Record.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/13.
//

import Foundation
import RealmSwift

class Record: Object {
    @objc dynamic var identifier: ObjectId = ObjectId.generate()
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

    // Primary key for Realm Entity. Required
    override static func primaryKey() -> String? {
        "identifier"
    }

    // properties that are either computed and lazy are mentioned here
    // since Realm cannnot store those.
    override static func ignoredProperties() -> [String] {
        ["Record"]
    }
}
