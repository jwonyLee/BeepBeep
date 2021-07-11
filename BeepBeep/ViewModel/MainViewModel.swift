//
//  MainViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/07/05.
//

import Foundation
import RxSwift

class MainViewModel {
    let categoryObservable: Observable<[Category]> = RealmManager.shared.getCategory()
}
