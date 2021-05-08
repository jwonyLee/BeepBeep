//
//  ViewController.swift
//  BeepBeep
//
//  Created by 이지원 on 2021/05/06.
//

import UIKit
import Then
import SnapKit

class ViewController: UIViewController {

    // MARK: - View Properties
    private let progressView = RoundView().then {
        $0.backgroundColor = .lightGray
    }

    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNavigation()
        configureViews()
        setProgressViewConstraints()
        setTableViewConstraints()
    }
}

// MARK: - Private
private extension ViewController {
    func configureNavigation() {
        self.title = "BeepBeep"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func configureViews() {
        view.addSubview(progressView)
        view.addSubview(tableView)
    }

    func setProgressViewConstraints() {
        progressView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.height.equalTo(64)
        }
    }

    func setTableViewConstraints() {
        tableView.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            $0.top.equalTo(progressView.snp.bottom).offset(16)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}
