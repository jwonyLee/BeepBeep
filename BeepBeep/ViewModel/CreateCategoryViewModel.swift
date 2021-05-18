//
//  CreateCategoryViewModel.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/17.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class CreateCategoryViewModel {

    struct Input {
        let emoji: AnyObserver<String>
        let name: AnyObserver<String>
        let saveDidTap: AnyObserver<Void>
    }

    struct Output {
        let errorsObservable: Observable<Error>
        let didPopObservable: Observable<Void>
    }

    let input: Input
    let output: Output

    private var disposeBag = DisposeBag()

    private let emojiSubject = PublishSubject<String>()
    private let nameSubject = PublishSubject<String>()
    private let saveDidTapSubject = PublishSubject<Void>()
    private let errorsSubject = PublishSubject<Error>()
    private let didPopSubject = PublishSubject<Void>()

    private var categoryObservable: Observable<Category> {
        return Observable.combineLatest(emojiSubject.asObserver(), nameSubject.asObserver()) { (emoji, name) in
            return Category(name: name, emoji: emoji)
        }
    }

    init() {

        input = Input(emoji: emojiSubject.asObserver(),
                      name: nameSubject.asObserver(),
                      saveDidTap: saveDidTapSubject.asObserver())

        output = Output(errorsObservable: errorsSubject.asObservable(),
                        didPopObservable: didPopSubject.asObservable())

        saveDidTapSubject
            .withLatestFrom(categoryObservable)
            .subscribe(onNext: { [weak self] category in
                self?.saveCategory(newCategory: category)
                self?.didPopSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

private extension CreateCategoryViewModel {

    func saveCategory(newCategory: Category) {
        RealmManager.add(newCategory)
    }
}
