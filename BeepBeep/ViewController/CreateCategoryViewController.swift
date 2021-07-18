//
//  CreateCategoryViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/14.
//

import UIKit
import SnapKit
import Then
import ISEmojiView
import RxSwift
import RxCocoa

class CreateCategoryViewController: UIViewController {
    private let viewModel: CreateCategoryViewModel = CreateCategoryViewModel()
    private var disposeBag: DisposeBag = DisposeBag()

    private let emojiField: UITextField = UITextField().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont(name: "AppleColorEmoji", size: 72)
        $0.backgroundColor = UIColor(named: "BeepGray")
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 15
        $0.tintColor = .clear
        $0.textAlignment = .center
        $0.becomeFirstResponder()
    }

    private let nameLabel: UILabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.pretendardTitle1
        $0.textAlignment = .left
        $0.text = I18N.newCollectionNameFieldDescription.localized
        $0.textColor = .label
    }

    private let nameField: UITextField = UITextField().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.pretendardBody
        $0.placeholder = I18N.newCollectionNameFieldPlaceholder.localized
        $0.backgroundColor = UIColor(named: "BeepGray")
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 15
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: $0.frame.height))
        $0.leftViewMode = .always
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
        configureViews()
        configureEmojiField()
        bindInput()
        bindOutput()
        setEmojiFieldConstraints()
        setNameLabelConstraints()
        setNameFieldConstraints()
    }
}

extension CreateCategoryViewController {
    private func configureNavigation() {
        self.title = "🗂 \(I18N.newCollectionTitle.localized)"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.pretendardHeadline]
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }

    private func configureViews() {
        view.addSubview(emojiField)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
    }

    private func configureEmojiField() {
        let keyboardSettings: KeyboardSettings = KeyboardSettings(bottomType: .categories)
        let emojiView: EmojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        emojiField.inputView = emojiView
    }

    private func setEmojiFieldConstraints() {
        emojiField.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.width.equalTo(150)
            $0.height.equalTo(emojiField.snp.width)
        }
    }

    private func setNameLabelConstraints() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            $0.top.equalTo(emojiField.snp.bottom).offset(48)
            $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
        }
    }

    private func setNameFieldConstraints() {
        nameField.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
            $0.height.equalTo(64)
        }
    }

    private func bindInput() {
        emojiField.rx.text.orEmpty
            .bind(to: viewModel.emojiField)
            .disposed(by: disposeBag)

        nameField.rx.text.orEmpty
            .bind(to: viewModel.nameField)
            .disposed(by: disposeBag)

        self.navigationItem.rightBarButtonItem!.rx.tap
            .bind(to: viewModel.saveButtonTapped)
            .disposed(by: disposeBag)
    }

    private func bindOutput() {
        viewModel.errorsRelay
            .subscribe(onNext: { error in
                switch error {
                case .isEmojiFieldEmpty:
                    print("emoji is empty")
                case .isNameFiledEmpty:
                    print("name is empty")
                case .duplicateName:
                    print("duplicate name")
                }
            })
            .disposed(by: disposeBag)

        viewModel.didPopRelay
            .subscribe(onNext: { [unowned self] in
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension CreateCategoryViewController: EmojiViewDelegate {
    // callback when tap a emoji on keyboard
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        emojiField.text = emoji
        emojiField.sendActions(for: .valueChanged)
    }

    // callback when tap change keyboard button on keyboard
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        emojiField.inputView = nil
        emojiField.keyboardType = .default
        emojiField.reloadInputViews()
    }

    // callback when tap delete button on keyboard
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        emojiField.deleteBackward()
    }

    // callback when tap dismiss button on keyboard
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        emojiField.resignFirstResponder()
    }
}
