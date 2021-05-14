//
//  CreateCategoryViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/13.
//

import UIKit
import SnapKit
import Then

class CreateCategoryViewController: UIViewController {

    // MARK: - View Properties
    private let emojiField = UITextField().then {
        $0.placeholder = "emoji!"
        $0.backgroundColor = .label
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureViews()
        setEmojiFieldConstraints()
    }

}

private extension CreateCategoryViewController {
    func configureViews() {
        view.addSubview(emojiField)
    }

    func setEmojiFieldConstraints() {
        emojiField.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide.snp.center)
            $0.width.equalTo(100)
            $0.height.equalTo(emojiField.snp.width)
        }
    }
}
