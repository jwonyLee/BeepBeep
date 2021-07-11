//
//  RealmManager.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/17.
//  source: https://medium.com/engineering-dr/simplify-data-store-operations-in-your-ios-projects-with-realm-dfec443f11d

import Foundation
import RealmSwift
import RxSwift
import RxRealm

private protocol RealmOperations {
    /// write operation
    static func write<T: Object>(_ object: T?, block: @escaping ((Realm, T?) -> Void))
    ///
    /// adds a single object to Realm
    static func add(_ object: Object)
    /// adds a list of objects to Realm
    static func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object

    /// gets objects from Realm that satisfy the given predicate
    static func get<R: Object>(fromEntity entity: R.Type,
                               withPredicate predicate: NSPredicate?,
                               sortedByKey sortKey: String?,
                               inAscending isAscending: Bool) -> Results<R>

    /// deletes a single object from Realm
    static func delete(_ object: Object)

    /// deletes a list of object from Realm
    static func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object

    /// deletes an Entity from Realm based  on the given predicate
    static func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate?)

    /// updates and overwrites a Realm object
    static func update<T: Object>(_ object: T, block: @escaping ((T) -> Void))
}

class RealmManager {
    static let shared: RealmManager = RealmManager()
    private init() { }

    // MARK: - functions
    static func realmConfig() -> Realm.Configuration {
        Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    }

    private static func realmInstance() -> Realm {
        do {
            let newRealm: Realm = try Realm(configuration: realmConfig())
            return newRealm
        } catch {
            print(error)
            fatalError("Unable to create an instance of Realm")
        }
    }
}

extension RealmManager: RealmOperations {
    /// Writes to Realm
    fileprivate static func write<T: Object>(_ object: T? = nil, block: @escaping ((Realm, T?) -> Void)) {
        DispatchQueue(label: "realm").sync {
            autoreleasepool {
                let currentRealm: Realm = realmInstance()

                if currentRealm.isInWriteTransaction {
                    return
                } else {
                    do {
                        try currentRealm.write {
                            block(currentRealm, object)
                        }
                    } catch {
                        return
                    }
                }
            }
        }
    }

    // MARK: - ADD functions
    /// adds an object to Realm
    static func add(_ object: Object) {
        Self.write { realmInstance, _ in
            realmInstance.add(object, update: .all)
        }
    }

    /// adds a list of objects to Realm
    static func add<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        Self.write { realmInstance, _ in
            realmInstance.add(objects, update: .all)
        }
    }

    // MARK: - GET function
    static func get<R: Object>(fromEntity entity: R.Type, withPredicate predicate: NSPredicate? = nil, sortedByKey sortKey: String? = nil, inAscending isAscending: Bool = true) -> Results<R> {
        var objects: Results<R> = realmInstance().objects(entity)
        if predicate != nil {
            objects = objects.filter(predicate!)
        }
        if sortKey != nil {
            objects = objects.sorted(byKeyPath: sortKey!, ascending: isAscending)
        }

        return objects
    }

    // MARK: - DELETE functions
    static func delete(_ object: Object) {
        Self.write(object) { realmInstance, newObject in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            realmInstance.delete(newObject)
        }
    }

    /// deletes a list of elements from Realm
    static func delete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        Self.write { realmInstance, _ in
            realmInstance.delete(objects)
        }
    }

    /// deletes an Entity from Realm, a predicate can be given
    static func delete(fromEntity entity: Object.Type, withPredicate predicate: NSPredicate? = nil) {
        Self.delete(Self.get(fromEntity: entity, withPredicate: predicate))
    }

    // MARK: - UPDATE function
    static func update<T: Object>(_ object: T, block: @escaping ((T) -> Void)) {
        guard !object.isInvalidated else {
            return
        }

        Self.write(object) { _, newObject in
            guard let newObject = newObject, !newObject.isInvalidated else {
                return
            }
            block(newObject)
        }
    }
}

extension RealmManager {
    // MARK: - functions
    func getCategories() -> Observable<[Category]> {
        Observable.array(from: RealmManager.get(fromEntity: Category.self))
    }

    func findByCategory(to identifier: ObjectId) -> Observable<Category>? {
        if let find: Category = RealmManager.get(fromEntity: Category.self,
                                                 withPredicate: NSPredicate(format: "identifier == %@", identifier),
                                                 sortedByKey: nil).first {
            return Observable.from(object: find)
        }
        return nil
    }

    func findByCategory(query: String) -> [Category] {
        let categories: Results<Category> = RealmManager.get(fromEntity: Category.self,
                                                             withPredicate: NSPredicate(format: "name == %@", query),
                                                             sortedByKey: "name",
                                                             inAscending: true)
        return Array(categories)
    }

    func findByCategory(to identifier: ObjectId) -> Category? {
        RealmManager.get(fromEntity: Category.self,
                         withPredicate: NSPredicate(format: "identifier == %@", identifier),
                         sortedByKey: nil).first
    }

    func findByItem(at categoryIdentifier: ObjectId) -> Observable<[Item]>? {
        if let category: Category = findByCategory(to: categoryIdentifier) {
            return Observable.array(from: category.items)
        }
        return nil
    }
}
