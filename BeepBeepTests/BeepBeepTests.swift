//
//  BeepBeepTests.swift
//  BeepBeepTests
//
//  Created by 이지원 on 2021/05/06.
//

import XCTest
import RealmSwift
@testable import BeepBeep

class BeepBeepTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testCreateCategory() throws {
        let newCategory: Category = Category()
        newCategory.name = "apple"
        newCategory.emoji = "🍎"

        // Create
        let realm: Realm = try? Realm()
        do {
            try realm.write {
                realm.add(newCategory)
            }
        } catch {
            print(error.localizedDescription)
        }

        // Read
        let category: Result<Category> = realm.objects(Category.self)
        XCTAssertEqual(1, c.count)
    }

    func testUpdateCategory() throws {
        let realm: Realm = try? Realm()
        let before: Result<Category> = realm.objects(Category.self)

        do {
            try realm.write {
                before[0].name = "samsung"
            }
        } catch {
            print(error.localizedDescription)
        }

        let after: Result<Category> = realm.objects(Category.self)
        XCTAssertEqual(after[0].name, "samsung")
    }
}
