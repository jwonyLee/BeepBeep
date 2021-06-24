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
    private let disposeBag: DisposeBag = DisposeBag()

    let emojiField: PublishRelay<String> = PublishRelay<String>()
    let nameField: PublishRelay<String> = PublishRelay<String>()
    let saveButtonTapped: PublishRelay<Void> = PublishRelay<Void>()
    let errorsRelay: PublishRelay<CreateCategoryError> = PublishRelay<CreateCategoryError>()
    let didPopRelay: PublishRelay<Void> = PublishRelay<Void>()

    /**
     emojiField가 비어있는지 여부
     - true: 값이 있음
     - false: 값이 없음(필드가 비어있음)
     */
    private var isEmojiValid: Observable<Bool> {
        emojiField.map { !$0.isEmpty }
    }

    /**
     nameField가 비어있는지 여부
     - true: 값이 있음
     - false: 값이 없음(필드가 비어있음)
     */
    private var isNameValid: Observable<Bool> {
        nameField.map { !$0.isEmpty }
    }

    /**
     중복된 카테고리 이름이 있는지 여부
     - true: 중복된 값이 없음
     - false: 중복된 값이 있음
     */
    private var isDuplicateByCategoryValid: Observable<Bool> {
        nameField.map { !self.isDuplicateByCategory(of: $0) }
    }

    private var categoryObservable: Observable<Category> {
        Observable.combineLatest(emojiField, nameField) { emoji, name in
            return Category(name: name, emoji: emoji)
        }
    }

    init() {
        bindInput()
    }

    private func bindInput() {
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

extension CreateCategoryViewModel {
    private func isDuplicateByCategory(of query: String) -> Bool {
        !RealmManager.shared.findByCategory(query: query).isEmpty
    }

    private func saveCategory(newCategory: Category) {
        RealmManager.add(newCategory)
    }
}
