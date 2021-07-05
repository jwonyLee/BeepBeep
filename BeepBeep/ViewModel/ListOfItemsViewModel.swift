//
//  ListOfItemsViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class ListOfItemsViewModel {
    var items: [Item] = []
    lazy var itemsSubject: BehaviorSubject = BehaviorSubject(value: items)
}
