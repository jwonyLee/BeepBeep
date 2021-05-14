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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        configureNavigation()
    }
}

private extension CreateCategoryViewController {
    func configureNavigation() {
        self.title = "🗂 새 모음집 만들기"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
    }
}
