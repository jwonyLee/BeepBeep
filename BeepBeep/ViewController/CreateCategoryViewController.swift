//
//  CreateCategoryViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/14.
//

import UIKit
import SnapKit
import Then

class CreateCategoryViewController: UIViewController {

    private let emojiField = UITextField().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont(name: "AppleColorEmoji", size: 72)
        $0.backgroundColor = UIColor(named: "BeepGray")
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 15
        $0.tintColor = .clear
        $0.textAlignment = .center
    }

    private let nameLabel = UILabel().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
        $0.textAlignment = .left
        $0.text = "모음집 이름은 무엇인가요?"
        $0.textColor = .label
    }

    private let nameField = UITextField().then {
        $0.adjustsFontForContentSizeCategory = true
        $0.font = UIFont.preferredFont(forTextStyle: .title2)
        $0.placeholder = "모음집 이름을 적어주세요."
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
        setEmojiFieldConstraints()
        setNameLabelConstraints()
        setNameFieldConstraints()
    }
}

private extension CreateCategoryViewController {
    func configureNavigation() {
        self.title = "🗂 새 모음집 만들기"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }

    func configureViews() {
        view.addSubview(emojiField)
        view.addSubview(nameLabel)
        view.addSubview(nameField)
    }

    func configureEmojiField() {
        emojiField.delegate = self
    }

    func setEmojiFieldConstraints() {
        emojiField.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide.snp.centerX)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(48)
            $0.width.equalTo(150)
            $0.height.equalTo(emojiField.snp.width)
        }
    }

    func setNameLabelConstraints() {
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(32)
            $0.top.equalTo(emojiField.snp.bottom).offset(48)
            $0.trailing.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
        }
    }

    func setNameFieldConstraints() {
        nameField.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-32)
            $0.height.equalTo(64)
        }
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 1
    }
}
