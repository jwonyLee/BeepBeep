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

enum CreateCategoryError: Error {
    case isEmojiFieldEmpty
    case isNameFiledEmpty
    case duplicateName
}

class CreateCategoryViewModel {

    private var disposeBag = DisposeBag()

    let emojiSubject = PublishSubject<String>()
    let nameSubject = PublishSubject<String>()
    let saveDidTapSubject = PublishSubject<Void>()
    let errorsSubject = PublishSubject<CreateCategoryError>()
    let didPopSubject = PublishSubject<Void>()

    private var isEmojiFieldEmptyObservable: Observable<Bool> {
        return emojiSubject.asObserver()
            .map { $0.isEmpty }
            .asObservable()
    }

    private var isNameFieldEmptyObservable: Observable<Bool> {
        return nameSubject.asObserver()
            .map { $0.isEmpty }
            .asObservable()
    }

    private var isDuplicateByCategoryObservable: Observable<Bool> {
        return nameSubject.asObserver()
            .map { self.isDuplicateByCategory(of: $0) }
            .asObservable()
    }

    private var categoryObservable: Observable<Category> {
        return Observable.combineLatest(emojiSubject.asObserver(), nameSubject.asObserver()) { (emoji, name) in
            return Category(name: name, emoji: emoji)
        }
    }

    init() {
        saveDidTapSubject
            .withLatestFrom(isEmojiFieldEmptyObservable)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsSubject.onNext(CreateCategoryError.isEmojiFieldEmpty)
            })
            .disposed(by: disposeBag)

        saveDidTapSubject
            .withLatestFrom(isNameFieldEmptyObservable)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsSubject.onNext(CreateCategoryError.isNameFiledEmpty)
            })
            .disposed(by: disposeBag)

        saveDidTapSubject
            .withLatestFrom(isDuplicateByCategoryObservable)
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsSubject.onNext(CreateCategoryError.duplicateName)
            })
            .disposed(by: disposeBag)

        saveDidTapSubject
            .withLatestFrom(isEmojiFieldEmptyObservable)
            .filter { !$0 }
            .withLatestFrom(isNameFieldEmptyObservable)
            .filter { !$0 }
            .withLatestFrom(isDuplicateByCategoryObservable)
            .filter { !$0 }
            .withLatestFrom(categoryObservable)
            .subscribe(onNext: { [weak self] category in
                self?.saveCategory(newCategory: category)
                self?.didPopSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
}

private extension CreateCategoryViewModel {

    func isDuplicateByCategory(of query: String) -> Bool {
        return !RealmManager.shared.findByCategory(query: query).isEmpty
    }

    func saveCategory(newCategory: Category) {
        RealmManager.add(newCategory)
    }
}
