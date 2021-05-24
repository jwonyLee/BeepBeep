//
//  Category.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/13.
//

import Foundation
import RealmSwift

class Category: Object {

    @objc dynamic var identifier: ObjectId = ObjectId.generate()
    @objc dynamic var createDate: Date = Date()
    @objc dynamic var name: String = ""
    @objc dynamic var emoji: String = ""
    @objc dynamic var isFavorite: Bool = false

    let items = List<Item>()

    convenience init(name: String, emoji: String) {
        self.init()
        self.name = name
        self.emoji = emoji
    }

    // Primary key for Realm Entity. Required
    override static func primaryKey() -> String? {
        return "identifier"
    }

    // properties that are either computed and lazy are mentioned here
    // since Realm cannnot store those.
    override static func ignoredProperties() -> [String] {
        ["Category"]
    }
}
