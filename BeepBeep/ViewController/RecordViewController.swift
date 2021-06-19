//
//  RecordViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/06/13.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: - View Properties
    let recordButton = RecordButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureViews()
        setRecordButtonConstraints()
    }
}

private extension RecordViewController {
    func configureViews() {
        view.addSubview(recordButton)
    }

    func setRecordButtonConstraints() {
        recordButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
