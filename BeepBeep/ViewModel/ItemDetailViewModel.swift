//
//  ItemDetailViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class ItemDetailViewModel {
    var records: [Record] = []
    lazy var recordSubject: BehaviorSubject<[Record]> = BehaviorSubject(value: records)
}
