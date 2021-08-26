//
//  ItemDetailViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class ItemDetailViewModel {
    private let disposeBag: DisposeBag = DisposeBag()
    var item: Item = Item()
    private(set) var recordObservable: Observable<[Record]> = Observable.just([])

    func setItem(at item: Item) {
        self.item = item
        fetchRecords(by: item)
    }
}

extension ItemDetailViewModel {
    private func fetchRecords(by item: Item) {
        if let findRecord: Observable<[Record]> = RealmManager.shared.findByRecord(at: item.identifier) {
            recordObservable = findRecord
        }
    }
}
