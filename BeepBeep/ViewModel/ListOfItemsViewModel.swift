//
//  ListOfItemsViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class ListOfItemsViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    private var category: Category = Category()
    private(set) var itemObservable: Observable<[Item]> = Observable.just([])

    func setCategory(at category: Category) {
        self.category = category
        if let findItem: Observable<[Item]> = RealmManager.shared.findByItem(at: category.identifier) {
            itemObservable = findItem
        }
    }
}
