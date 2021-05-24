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

    let emojiField = PublishRelay<String>()
    let nameField = PublishRelay<String>()
    let saveButtonTapped = PublishRelay<Void>()
    let errorsRelay = PublishRelay<CreateCategoryError>()
    let didPopRelay = PublishRelay<Void>()

    /**
     emojiField가 비어있는지 여부
     - true: 값이 있음
     - false: 값이 없음(필드가 비어있음)
     */
    private var isEmojiValid: Observable<Bool> {
        return emojiField.map { !$0.isEmpty }
    }

    /**
     nameField가 비어있는지 여부
     - true: 값이 있음
     - false: 값이 없음(필드가 비어있음)
     */
    private var isNameValid: Observable<Bool> {
        return nameField.map { !$0.isEmpty }
    }

    /**
     중복된 카테고리 이름이 있는지 여부
     - true: 중복된 값이 없음
     - false: 중복된 값이 있음
     */
    private var isDuplicateByCategoryValid: Observable<Bool> {
        return nameField.map { !self.isDuplicateByCategory(of: $0) }
    }

    private var categoryObservable: Observable<Category> {
        return Observable.combineLatest(emojiField, nameField) { (emoji, name) in
            return Category(name: name, emoji: emoji)
        }
    }

    init() {
        saveButtonTapped
            .withLatestFrom(self.isEmojiValid)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsRelay.accept(CreateCategoryError.isEmojiFieldEmpty)
            })
            .disposed(by: disposeBag)

        saveButtonTapped
            .withLatestFrom(self.isNameValid)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsRelay.accept(CreateCategoryError.isNameFiledEmpty)
            })
            .disposed(by: disposeBag)

        saveButtonTapped
            .withLatestFrom(self.isDuplicateByCategoryValid)
            .filter { !$0 }
            .subscribe(onNext: { [weak self] _ in
                self?.errorsRelay.accept(CreateCategoryError.duplicateName)
            })
            .disposed(by: disposeBag)

        saveButtonTapped
            .withLatestFrom(self.isEmojiValid)
            .filter { $0 }
            .withLatestFrom(self.isNameValid)
            .filter { $0 }
            .withLatestFrom(self.isDuplicateByCategoryValid)
            .filter { $0 }
            .withLatestFrom(categoryObservable)
            .subscribe(onNext: { [weak self] category in
                self?.saveCategory(newCategory: category)
                self?.didPopRelay.accept(())
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
