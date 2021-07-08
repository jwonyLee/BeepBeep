//
//  MainViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class MainViewModel {
    private var categories: [Category] = []
    lazy var categorySubject: BehaviorSubject<[Category]> = BehaviorSubject<[Category]>(value: self.categories)

    init() {
        fetchCategory()
    }

    private func fetchCategory() {
        let data: [Category] = RealmManager.shared.getCategory()
        self.categorySubject.onNext(data)
        self.categories = data
    }
}
