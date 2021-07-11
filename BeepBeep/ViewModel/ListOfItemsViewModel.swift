//
//  ListOfItemsViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class ListOfItemsViewModel {
    private(set) var categoryObservable: Observable<Category>?

    func setCategory(at category: Category) {
        self.categoryObservable = RealmManager.shared.findByCategory(to: category.identifier)
    }
}
